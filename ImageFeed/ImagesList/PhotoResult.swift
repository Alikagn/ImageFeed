//
//  PhotoResult.swift
//  ImageFeed
//
//  Created by Dmitry Batorevich on 02.06.2025.
//

import Foundation

struct PhotoResult: Decodable {
    let id: String
    let createdAt: String
    let width: Int
    let height: Int
    let description: String?
    let likedByUser: Bool
    let urls: UrlsResult
}

struct LikeResult: Decodable {
    let photo: PhotoResult
}
