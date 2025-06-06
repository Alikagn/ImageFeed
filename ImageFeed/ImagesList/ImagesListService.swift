//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Dmitry Batorevich on 01.06.2025.

 
import Foundation

final class ImagesListService {
    
    static let shared = ImagesListService()
    private init() {}
    
    private(set) var photos: [Photo] = []
    
    private let dateFormatter = ISO8601DateFormatter()
    
    func clearImages() {
        photos.removeAll()
    }
    
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    private var lastLoadedPage = 0
    private var isLoading = false
    
    func fetchPhotosNextPage() {
        guard !isLoading else { return }
        
        isLoading = true
        
        let nextPage = lastLoadedPage + 1
        
        guard let url = URL(string: "https://api.unsplash.com/photos?page=\(nextPage)&client_id=\(Constants.accessKey)") else {
            isLoading = false
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("Client-ID \(Constants.accessKey)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            defer { self?.isLoading = false }
            
            if let error {
                print("Ошибка загрузки фотографий \(error)")
                return
            }
            
            guard let data else {
                print("Нет данных")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let photoResults = try decoder.decode([PhotoResult].self, from: data)
                
                let newPhotos = photoResults.map { result in
                    Photo(
                        id: result.id,
                        size: CGSize(width: result.width, height: result.height),
                        createdAt: self?.dateFormatter.date(from: result.createdAt),
                        welcomeDescription: result.description,
                        thumbImageURL: result.urls.thumb,
                        largeImageURL: result.urls.full,
                        isLiked: result.likedByUser
                    )
                }
                
                DispatchQueue.main.async { [weak self] in
                    self?.photos.append(contentsOf: newPhotos)
                    self?.lastLoadedPage = nextPage
                    
                    print("Загружено фотографий: \(self?.photos.count ?? 0)")
                    
                    NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: nil)
                }
            } catch {
                let dataString = String(data: data, encoding: .utf8) ?? "недоступны"
                print("[ImagesListService.fetchPhotosNextPage]: Ошибка декодирования данных: \(error). Данные: \(dataString)")
            }
            
        } .resume()
    }
    
    func reset() {
        photos.removeAll()
        lastLoadedPage = 0
    }
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: "https://api.unsplash.com/photos/\(photoId)/like") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        guard let token = OAuth2TokenStorage.shared.token else {
            let error = NSError(domain: "TokenError", code: 401, userInfo: nil)
            print("Token error - \(error.localizedDescription)")
            completion(.failure(error))
            return
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = isLike ? HTTPMethod.post.rawValue : HTTPMethod.delete.rawValue
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        request.httpBody = nil
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NSError(domain: "InvalidResponse", code: 0, userInfo: nil)))
                return
            }
            
            if (200...299).contains(httpResponse.statusCode) {
                DispatchQueue.main.async {
                    if let index = self.photos.firstIndex(where: { $0.id == photoId }) {
                        let photo = self.photos[index]
                        
                        let newPhoto = Photo(
                            id: photoId,
                            size: photo.size,
                            createdAt: photo.createdAt,
                            welcomeDescription: photo.welcomeDescription,
                            thumbImageURL: photo.thumbImageURL,
                            largeImageURL: photo.largeImageURL,
                            isLiked: !photo.isLiked
                        )
                        self.photos = self.photos.withReplaced(itemAt: index, newValue: newPhoto)
                    }
                }
                
                DispatchQueue.main.async {
                    completion(.success(()))
                }
                
            } else {
                completion(.failure(NSError(domain: "ServerError", code: httpResponse.statusCode, userInfo:nil)))
            }
        }
        
        task.resume()
    }
}

extension Array {
    func withReplaced(itemAt index: Int, newValue: Element) -> [Element] {
        var newArray = self
        guard index >= 0 && index < newArray.count else { return newArray }
        newArray[index] = newValue
        return newArray
    }
}
