//
//  TestPhoto.swift
//  ImageFeedTests
//
//  Created by Dmitry Batorevich on 14.06.2025.
//

@testable import ImageFeed
import Foundation

struct TestPhoto {
    static func createPhoto(
        id: String = "test123",
        width: Int = 100,
        height: Int = 100,
        description: String? = "Test description",
        isLiked: Bool = true,
        dateString: String = "2023-01-01T00:00:00Z"
    ) -> Photo {
        let photoResult = PhotoResult(
            id: id,
            createdAt: dateString,
            width: width,
            height: height,
            description: description,
            likedByUser: isLiked,
            urls: UrlsResult(
                raw: "https://example.com/raw.jpg",
                full: "https://example.com/full.jpg",
                regular: "https://example.com/regular.jpg",
                small: "https://example.com/small.jpg",
                thumb: "https://example.com/thumb.jpg"
            )
        )
        return Photo(from: photoResult)
    }
}
