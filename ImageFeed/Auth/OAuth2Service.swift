//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Dmitry Batorevich on 29.04.2025.
//

import UIKit

struct OAuthTokenResponseBody: Codable {
    let accessToken: String
    let tokenType: String
    let scope: String
    let createdAt: Int
}

final class OAuth2Service {
    
    static let shared = OAuth2Service()
    private init() {}
    
    func makeOAuthTokenRequest(code: String) -> URLRequest? {
        guard let baseURL = URL(string: "https://unsplash.com") else {
            print("Ошибка: невозможно создать baseURL")
            return nil
        }
        
        guard let url = URL(
            string: "/oauth/token"
            + "?client_id=\(Constants.accessKey)"
            + "&&client_secret=\(Constants.secretKey)"
            + "&&redirect_uri=\(Constants.redirectURI)"
            + "&&code=\(code)"
            + "&&grant_type=authorization_code",
            relativeTo: baseURL
        ) else {
            print("Ошибка: невозможно создать URL для запроса")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        return request
    }
    
    func fetchOAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void) {
      
        guard let request = makeOAuthTokenRequest(code: code) else {
            DispatchQueue.main.async {
                completion(.failure(NSError(domain: "RequestError", code: 0)))
            }
            return
        }

            let task = URLSession.shared.data(for: request) { result in
                switch result {
                case .success(let data):
                    do {
                        let decoder = try JSONDecoder().decode(OAuthTokenResponseBody.self, from: data)
                        let token = decoder.accessToken
                        OAuth2TokenStorage.shared.token = token
                        DispatchQueue.main.async { completion(.success(token)) }
                         
                    } catch {
                        print("Ошибка декодирования: \(error.localizedDescription)")
                        DispatchQueue.main.async { completion(.failure(error)) }
                    }
                
                case .failure(let error):
                    if let networkError = error as? NetworkError {
                        switch networkError {
                        case .httpStatusCode(let code, let data):
                            print("Ошибка: сервер вернул статус-код \(code)")
                            if let data = data, let errorString = String(data: data, encoding: .utf8) {
                                print("Ответ сервера:\n\(errorString)")
                            } else {
                                print("Ответ сервера пустой или не удалось декодировать")
                            }
                        case .urlRequestError(let requestError):
                            print("Ошибка запроса: \(requestError)")
                        case .urlSessionError:
                            print("Неизвестная ошибка URLSession")
                        }
                    } else {
                        print("Неизвестная ошибка сети: \(error)")
                    }
                    DispatchQueue.main.async { completion(.failure(error)) }
                }
            }
            task.resume()
    }
}
