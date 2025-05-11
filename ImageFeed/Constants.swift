//
//  Constants.swift
//  ImageFeed
//
//  Created by Dmitry Batorevich on 17.04.2025.
//

import UIKit

enum Constants {
    static let accessKey = "<JJfKDqXgujgO-DwWv7e8dOIOZI8nYBhT2Grl90cnSkY>"
    static let secretKey = "<gfJiO1beOnkuuJV12l2Esp0qdXU5hqZynkwxMQ4lEaQ>"
    static let redirectURI = "<urn:ietf:wg:oauth:2.0:oob>"
    static let accessScope = "public+read_user+write_likes"
    static var defaultBaseURL: URL {
        guard let url = URL(string: "https://api.unsplash.com") else {
            fatalError("Failed to create default base URL")
        }
        return url
    }
}
