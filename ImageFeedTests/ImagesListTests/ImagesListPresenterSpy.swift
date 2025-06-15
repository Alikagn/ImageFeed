//
//  ImagesListPresenterSpy.swift
//  ImageFeedTests
//
//  Created by Dmitry Batorevich on 14.06.2025.
//

@testable import ImageFeed
import Foundation

final class ImagesListPresenterSpy: ImagesListPresenterProtocol {
    var photosCount: Int {
        stubbedPhotosCount
    }
    
    weak var view: (any ImageFeed.ImagesListViewControllerProtocol)?
    
    var viewDidLoadCalled = false
    var fetchPhotosNextPageIfNeededCalled = false
    var changeLikeCalled = false
    var photoAtIndexCalled = false
    var calculateCellHeightCalled = false
    var shouldSucceed = true
    var dateFormatter: DateFormatter = DateFormatter()
    
    var stubbedPhoto: Photo?
    var stubbedCellHeight: CGFloat = 0
    var stubbedPhotosCount = 0
    
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func fetchPhotosNextPageIfNeeded() {
        fetchPhotosNextPageIfNeededCalled = true
    }
    
    func changeLike(for photoId: String, isLike: Bool, completion: @escaping (Result<Void, any Error>) -> Void) {
        changeLikeCalled = true
        if shouldSucceed {
            completion(.success(()))
        } else {
            completion(.failure(NSError(domain: "test", code: 500)))
        }
    }
    
    func photo(at index: Int) -> Photo? {
        photoAtIndexCalled = true
        return stubbedPhoto
    }
    
    func calculateCellHeight(for photo: ImageFeed.Photo, tableViewWidth: CGFloat) -> CGFloat {
        calculateCellHeightCalled = true
        return stubbedCellHeight
    }
}
