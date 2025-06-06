//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Dmitry Batorevich on 23.05.2025.
//

import Foundation

final class ProfileImageService {
    static let shared = ProfileImageService()
    private init() {}
    
    private let oAuth2TokenStorage = OAuth2TokenStorage.shared
    private(set) var avatarURL: String?
    private var isFetching: Bool = false
    private var task: URLSessionTask?
    
    static let didChangeNotification = Notification.Name("ProfileImageProviderDidChange")
    
    private func makeProfileImageRequest(username: String, token: String) -> URLRequest? {
        guard let url = URL(string: "/users/\(username)", relativeTo: Constants.defaultBaseURL) else {
            print("[makeProfileImageRequest]: Ошибка: невозможно создать URL для запроса")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        guard !isFetching else {
            print("[fetchProfileImageURL]: FetchingInProgress - запрос уже выполняется")
            return
        }
        
        guard let token = oAuth2TokenStorage.token else {
            print("[fetchProfileImageURL]: MissingToken - токен отсутствует")
            completion(.failure(AuthServiceError.missingToken))
            return
        }
        
        guard let request = makeProfileImageRequest(username: username, token: token) else {
            print("[fetchProfileImageURL]: InvalidRequest - не удалось создать URLRequest")
            DispatchQueue.main.async {
                completion(.failure(AuthServiceError.invalidRequest))
            }
            return
        }
        
        isFetching = true
        task?.cancel()
        
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
            DispatchQueue.main.async {
                guard let self else { return }
                self.isFetching = false
                
                switch result {
                case .success(let userResult):
                    guard let profileImageURL = userResult.profileImage?.large else {
                        print("[fetchProfileImageURL]: NoData - отсутствует URL аватара")
                        completion(.failure(AuthServiceError.noData))
                        return
                    }
                    
                    self.avatarURL = profileImageURL
                    completion(.success(profileImageURL))
                    
                    NotificationCenter.default.post(
                        name: ProfileImageService.didChangeNotification,
                        object: self,
                        userInfo: ["URL": profileImageURL]
                    )
                    
                case .failure(let error):
                    print("[fetchProfileImageURL]: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
        }
        
        self.task = task
        task.resume()
    }
}
