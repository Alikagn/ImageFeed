//
//  ProfileCotnrollerProtocol.swift
//  ImageFeed
//
//  Created by Dmitry Batorevich on 08.06.2025.
//

import Foundation

protocol ProfileViewControllerProtocol: AnyObject {
    func updateProfileDetails(name: String, loginName: String, bio: String)
    func updateAvatar(with url: URL)
    func showDefaultAvatar()
    func showLogoutAlert()
}
