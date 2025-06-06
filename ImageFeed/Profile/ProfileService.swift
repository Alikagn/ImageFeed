//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Dmitry Batorevich on 21.05.2025.
//

import Foundation

final class ProfileService {
    static let shared = ProfileService()
    private init() {}
    
    
    private let oAuthTokenStorage = OAuth2TokenStorage.shared
    private var task: URLSessionTask?
    private(set) var profile: Profile?
    private var isFetching: Bool = false
   
    func makeProfileRequest(token: String) -> URLRequest? {
        guard let url = URL(string: "/me", relativeTo: Constants.defaultBaseURL) else {
            print("[makeProfileRequest]: Ошибка: невозможно создать URL для запроса")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    func fetchProfile(completion: @escaping (Result<Profile, Error>) -> Void) {
        guard !isFetching else {
            print("[fetchProfile]: FetchingInProgress - запрос уже выполняется")
            return
        }
        
        guard let token = oAuthTokenStorage.token else {
            print("[fetchProfile]: MissingToken - токен отсутствует")
            completion(.failure(AuthServiceError.missingToken))
            return
        }
        
        guard let request = makeProfileRequest(token: token) else {
            print("[fetchProfile]: InvalidRequest - не удалось создать URLRequest")
            DispatchQueue.main.async {
                completion(.failure(AuthServiceError.invalidRequest))
            }
            return
        }
        
        isFetching = true
        task?.cancel()
        
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
            DispatchQueue.main.async {
                guard let self else { return }
                self.isFetching = false
                
                switch result {
                case .success(let profileResult):
                    let profile = Profile(
                        username: profileResult.username,
                        name: "\(profileResult.firstName ?? "") \(profileResult.lastName ?? "")".trimmingCharacters(in: .whitespacesAndNewlines),
                        loginName: "@\(profileResult.username)",
                        bio: profileResult.bio ?? "Hello, world!"
                    )
                    
                    self.profile = profile
                    completion(.success(profile))
                    
                case .failure(let error):
                    print("[fetchProfile]: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
        }
        
        self.task = task
        task.resume()
    }
    
    func reset() {
        profile = nil
        task?.cancel()
        task = nil
        isFetching = false
    }
}
