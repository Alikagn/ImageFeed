//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Dmitry Batorevich on 29.04.2025.
//
import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
   
    static let shared = OAuth2TokenStorage()
    private init() {}
    private let keychainWrapper = KeychainWrapper.standard
    private let tokenKey = "access_token"
    
    var token: String? {
        get {
            keychainWrapper.string(forKey: tokenKey)
        }
        
        set {
           if let newValue {
               keychainWrapper.set(newValue, forKey: tokenKey)
            } else {
               keychainWrapper.removeObject(forKey: tokenKey)
            }
        }
    }
}
