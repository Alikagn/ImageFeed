//
//  ProfilePresenterProtocol.swift
//  ImageFeed
//
//  Created by Dmitry Batorevich on 08.06.2025.
//

import Foundation

protocol ProfilePresenterProtocol: AnyObject {
    var view: ProfileViewControllerProtocol? { get set }
    
    func viewDidLoad()
    func didTapLogoutButton()
    func updateAvatar()
    func updateProfileDetails()
}
