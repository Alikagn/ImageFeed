//
//  ProfileServiceSpy.swift
//  ImageFeedTests
//
//  Created by Dmitry Batorevich on 12.06.2025.
//

@testable import ImageFeed
import Foundation

final class ProfileServiceSpy: ProfileServiceProtocol {
    var profile: ImageFeed.Profile?
    
    init(profile: ImageFeed.Profile? = nil) {
        self.profile = profile
    }
}
