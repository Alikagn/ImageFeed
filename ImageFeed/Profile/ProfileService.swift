//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Dmitry Batorevich on 21.05.2025.
//
enum HttpMethodsConstants {
    static let httpMethodGet = "GET"
    static let httpMethodPost = "POST"
    static let httpMethodDelete = "DELETE"
    static let forHTTPHeaderField =  "Authorization"
}

import Foundation

final class ProfileService: ProfileServiceProtocol {
    static let shared = ProfileService()
    private init() {}
    
    private var task: URLSessionTask?
    var profile: Profile?
    private var isFetching: Bool = false
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        guard !isFetching else {
            print("[fetchProfile]: Ошибка - запрос уже выполняется")
            return
        }
        
        guard let url = URL(string: "/me", relativeTo: Constants.defaultBaseURL) else {
            print("[fetchProfile]: Ошибка - неверный URL")
            completion(.failure(AuthServiceError.invalidRequest))
            isFetching = false
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: HttpMethodsConstants.forHTTPHeaderField)
        request.httpMethod = HttpMethodsConstants.httpMethodGet
        
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
                        bio: profileResult.bio
                    )
                    self.profile = profile
                    completion(.success(profile))
                    
                    ProfileImageService.shared.fetchProfileImageURL(username: profileResult.username) { result in
                        switch result {
                        case .success(let avatarURL):
                            print("[fetchProfile]: Аватар успешно загружен: \(avatarURL)")
                        case .failure(let error):
                            print("[fetchProfile]: Ошибка загрузки аватара: \(error.localizedDescription)")
                        }
                    }
                case .failure(let error):
                    print("[fetchProfile]: Ошибка - \(error.localizedDescription)")
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
