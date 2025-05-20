//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Dmitry Batorevich on 29.04.2025.
//

import Foundation

final class OAuth2TokenStorage {
   
    static let shared = OAuth2TokenStorage()
    private init() {}
    
    private let userDefaults = UserDefaults.standard
    private let tokenKey = "access_token"
    
    var token: String? {
        get {
            userDefaults.string(forKey: tokenKey)
        }
        
        set {
            userDefaults.set(newValue, forKey: tokenKey)
        }
    }
}
