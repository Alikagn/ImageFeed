//
//  Photo.swift
//  ImageFeed
//
//  Created by Dmitry Batorevich on 01.06.2025.
//
import Foundation

 struct Photo {
     let id: String
     let size: CGSize
     let createdAt: Date?
     let welcomeDescription: String?
     let thumbImageURL: String
     let largeImageURL: String
     var isLiked: Bool
     var isValidLargeURL: Bool {
         !largeImageURL.isEmpty && URL(string: largeImageURL) != nil
     }
     var isValidThumbImageURL: Bool {
         !thumbImageURL.isEmpty && URL(string: thumbImageURL) != nil
     }
     
     init(from photoResult: PhotoResult) {
         self.id = photoResult.id
         self.size = CGSize(width: photoResult.width, height: photoResult.height)
         let dateFormatter = ISO8601DateFormatter()
         self.createdAt = dateFormatter.date(from: photoResult.createdAt)
         self.welcomeDescription = photoResult.description
         self.thumbImageURL = photoResult.urls.thumb
         self.largeImageURL = photoResult.urls.full
         self.isLiked = photoResult.likedByUser
     }
 }
 
