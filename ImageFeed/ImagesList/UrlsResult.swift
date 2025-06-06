//
//  UrlsResult.swift
//  ImageFeed
//
//  Created by Dmitry Batorevich on 02.06.2025.
//
import Foundation

struct UrlsResult: Codable {
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
}
