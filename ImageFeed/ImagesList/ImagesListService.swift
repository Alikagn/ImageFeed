//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Dmitry Batorevich on 01.06.2025.
import Foundation

final class ImagesListService: ImagesListServiceProtocol {
    static let shared = ImagesListService()
    private init() {}
    
    static let didChangeNotification = Notification.Name("ImagesListServiceDidChange")
    
    private (set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    private var task: URLSessionTask?
    private let perPage = 10
    private let oAuth2TokenStorage = OAuth2TokenStorage.shared
    private let urlSession = URLSession.shared
    private var isFetching: Bool = false
    
    private func makePhotosRequest(page: Int, perPage: Int) -> URLRequest? {
        guard let token = oAuth2TokenStorage.token else {
            print("[makePhotosRequest]: MissingToken - токен отсутствует")
            return nil
        }
        
        guard let baseURL = Constants.defaultBaseURL else {
            print("[makeProfileRequest]: Ошибка - baseURL отсутствует")
            return nil
        }
        
        let photoPath = baseURL.appendingPathComponent("/photos")
        
        var components = URLComponents(url: photoPath, resolvingAgainstBaseURL: true)
        components?.queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "per_page", value: "\(perPage)")
        ]
        
        guard let url = components?.url else {
            print("[makeProfileRequest]: Ошибка - Невозможно создать URL")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = HttpMethodsConstants.httpMethodGet
        request.setValue("Bearer \(token)", forHTTPHeaderField: HttpMethodsConstants.forHTTPHeaderField)
        return request
    }
    
    func fetchPhotosNextPage() {
        guard !isFetching else {
            print("[fetchPhotosNextPage]: FetchingInProgress - запрос уже выполняется")
            return
        }
        
        let nextPage = (lastLoadedPage ?? 0) + 1
        
        guard let request = makePhotosRequest(page: nextPage, perPage: perPage) else {
            print("[fetchPhotosNextPage]: InvalidRequest - не удалось создать URLRequest")
            return
        }
        
        isFetching = true
        task?.cancel()
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            assert(Thread.isMainThread)
            
            guard let self else { return }
            self.isFetching = false
            
            switch result {
            case .success(let photoResult):
                let newPhotos = photoResult.map { photoResult in
                    Photo(from: photoResult)
                }
                
                DispatchQueue.main.async {
                    self.photos.append(contentsOf: newPhotos)
                    self.lastLoadedPage = nextPage
                    NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: self)
                }
                
            case .failure(let error):
                print("[fetchPhotosNextPage]: Ошибка - \(error.localizedDescription)")
            }
        }
        
        self.task = task
        task.resume()
    }
    
    private func makeChangeLikeRequest(photoId: String, token: String, isLike: Bool) -> URLRequest? {
        guard let url = URL(string: "/photos/\(photoId)/like", relativeTo: Constants.defaultBaseURL) else {
            print("[makeChangeLikeRequest]: Ошибка - Невозможно создать URL")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = isLike ? HttpMethodsConstants.httpMethodPost : HttpMethodsConstants.httpMethodDelete
        request.setValue("Bearer \(token)", forHTTPHeaderField: HttpMethodsConstants.forHTTPHeaderField)
        return request
    }
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        guard !isFetching else {
            print("[changeLike]: FetchingInProgress - запрос уже выполняется")
            return
        }
        
        guard let token = oAuth2TokenStorage.token else {
            print("[changeLike]: MissingToken - токен отсутствует")
            return
        }
        
        guard let request = makeChangeLikeRequest(photoId: photoId, token: token, isLike: isLike) else {
            print("[changeLike]: InvalidRequest - не удалось создать URLRequest")
            DispatchQueue.main.async {
                completion(.failure(AuthServiceError.invalidRequest))
            }
            return
        }
        
        isFetching = true
        task?.cancel()
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<LikeResult, Error>) in
            assert(Thread.isMainThread)
            
            guard let self else { return }
            self.isFetching = false
            
            switch result {
            case .success:
                if let index = self.photos.firstIndex(where: { $0.id == photoId}) {
                
                    DispatchQueue.main.async {
                        self.photos[index].isLiked = isLike
                        completion(.success(()))
                        NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: self)
                    }
                }
                
            case .failure(let error):
                print("[changeLike]: Ошибка - \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        
        self.task = task
        task.resume()
    }
    
    func reset() {
        photos.removeAll()
        lastLoadedPage = nil
        task?.cancel()
        task = nil
        isFetching = false
    }
}
