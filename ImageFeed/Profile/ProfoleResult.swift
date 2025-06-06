//
//  ProfoleResult.swift
//  ImageFeed
//
//  Created by Dmitry Batorevich on 23.05.2025.
//

import Foundation

struct ProfileResult: Codable {
    let username: String
    let firstName: String?
    let lastName: String?
    let bio: String?
}

struct Profile {
    let username: String
    let name: String
    let loginName: String
    let bio: String?
}

struct UserResult: Codable {
    let profileImage: ProfileImage?
    
    struct ProfileImage: Codable {
        let small: String?
        let medium: String?
        let large: String?
    }
}
