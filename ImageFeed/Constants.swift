//
//  Constants.swift
//  ImageFeed
//
//  Created by Dmitry Batorevich on 17.04.2025.
//

import UIKit

enum Constants {
    static let accessKey = "32NoaBA8UhaIZy24NQMPCNieJuqdGMWXzoCpzWcL7sU"
    static let secretKey = "lQBnnuSz85KJVBsT_s5BHPkkp8JVX6Dy9NhtgWel1bY"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static var defaultBaseURL: URL {
        guard let url = URL(string: "https://api.unsplash.com") else {
            fatalError("Failed to create default base URL")
        }
        return url
    }
}
