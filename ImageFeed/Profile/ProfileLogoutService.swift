//
//  ProfileLogoutService.swift
//  ImageFeed
//
//  Created by Dmitry Batorevich on 05.06.2025.
//

import Foundation
import WebKit

final class ProfileLogoutService: ProfileLogoutServiceProtocol {
    static let shared = ProfileLogoutService()
    private init() {}
    
    func logout() {
        cleanCookies()
        resetAllServices()
        switchToSplashViewController()
    }
    
    private func cleanCookies() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
    
    private func resetAllServices() {
            OAuth2TokenStorage.shared.token = nil
            ProfileService.shared.reset()
            ProfileImageService.shared.reset()
            ImagesListService.shared.reset()
        }
    
    private func switchToSplashViewController() {
            DispatchQueue.main.async {
                guard let window = UIApplication.shared.windows.first else {
                    fatalError("Invalid Configuration")
                }
                
                let splashViewController = SplashViewController()
                let navigationController = UINavigationController(rootViewController: splashViewController)
                window.rootViewController = navigationController
            }
        }
}
