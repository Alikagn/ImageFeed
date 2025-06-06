//
//  OAuthTokenResponseBody.swift
//  ImageFeed
//
//  Created by Dmitry Batorevich on 19.05.2025.
//

import Foundation

struct OAuthTokenResponseBody: Decodable {
    let accessToken: String
    let tokenType: String
    let scope: String
    let createdAt: Int
}
