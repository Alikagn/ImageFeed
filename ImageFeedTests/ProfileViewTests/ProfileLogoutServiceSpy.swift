//
//  ProfileLogoutServiceSpy.swift
//  ImageFeedTests
//
//  Created by Dmitry Batorevich on 12.06.2025.
//

@testable import ImageFeed
import Foundation

final class ProfileLogoutServiceSpy: ProfileLogoutServiceProtocol {
    var logoutCalled = false
    
    func logout() {
        logoutCalled = true
    }
}

