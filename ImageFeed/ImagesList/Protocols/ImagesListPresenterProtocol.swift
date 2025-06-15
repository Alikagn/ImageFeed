//
//  ImagesListPresenterProtocol.swift
//  ImageFeed
//
//  Created by Dmitry Batorevich on 11.06.2025.
//

import Foundation

protocol ImagesListPresenterProtocol: AnyObject {
    var view: ImagesListViewControllerProtocol? { get set }
    var dateFormatter: DateFormatter {get set}
    func viewDidLoad()
    func fetchPhotosNextPageIfNeeded()
    func changeLike(for photoId: String, isLike: Bool, completion: @escaping (Result<Void, Error>) -> Void)
    func photo(at index: Int) -> Photo?
    var photosCount: Int { get }
    func calculateCellHeight(for photo: Photo, tableViewWidth: CGFloat) -> CGFloat
}
