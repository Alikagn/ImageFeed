//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Dmitry Batorevich on 29.04.2025.
//

enum AuthServiceError: Error {
    case invalidRequest
    case noData
    case missingToken
}

import UIKit

final class OAuth2Service {
    
    static let shared = OAuth2Service()
    private init() {}
    
    private var authToken: String?
    
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var lastCode: String?
    
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
        assert(Thread.isMainThread)
        
        guard lastCode != code else {
            print("[fetchOAuthToken]: InvalidRequest - код уже использовался")
            completion(.failure(AuthServiceError.invalidRequest))
            return
        }
        
        task?.cancel()
        lastCode = code
        
        guard let request = makeOAuthTokenRequest(code: code) else {
            print("[fetchOAuthToken]: InvalidRequest - не удалось создать URLRequest")
            DispatchQueue.main.async {
                completion(.failure(AuthServiceError.invalidRequest))
            }
            return
        }
        
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
            DispatchQueue.main.async {
                guard let self else { return }
                
                switch result {
                case .success(let oAuthTokenResponseBody):
                    self.authToken = oAuthTokenResponseBody.accessToken
                    OAuth2TokenStorage.shared.token = oAuthTokenResponseBody.accessToken
                    completion(.success(oAuthTokenResponseBody.accessToken))
                    
                case .failure(let error):
                    if let networkError = error as? NetworkError {
                        print("[fetchOAuthToken]: \(networkError.errorDescription ?? "Unknown error")")
                    } else {
                        print("[fetchOAuthToken]: \(error.localizedDescription)")
                    }
                    completion(.failure(error))
                }
                
                self.task = nil
                self.lastCode = nil
            }
        }
        
        self.task = task
        task.resume()
    }
}
