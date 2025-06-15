//
//  ProfileImageServiceSpy.swift
//  ImageFeedTests
//
//  Created by Dmitry Batorevich on 12.06.2025.
//

@testable import ImageFeed
import Foundation
final class ProfileImageServiceSpy: ProfileImageServiceProtocol {
    var avatarURL: String?
    
    init(avatarURL: String? = nil) {
        self.avatarURL = avatarURL
    }
}
