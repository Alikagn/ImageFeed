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
}
