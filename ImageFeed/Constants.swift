//
//  Constants.swift
//  ImageFeed
//
//  Created by Dmitry Batorevich on 17.04.2025.
//

import Foundation

enum Constants {
    static let accessKey = "f69Mrx8PmdLC-DZoKREEKIAcw0DQ1HjJzXrkrhakPRg"
    static let secretKey = "BwBO0jVs6f4rq62x1qTeQSEtl1zVbUGFDwN39gQFRfA"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let defaultBaseURL: URL? = URL(string: "https://api.unsplash.com")
}
