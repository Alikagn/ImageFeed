//
//  ProfilePresenterSpy.swift
//  ImageFeedTests
//
//  Created by Dmitry Batorevich on 12.06.2025.
//

@testable import ImageFeed
import Foundation

final class ProfilePresenterSpy: ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol?
    
    var viewDidLoadCalled = false
    var didTapLogoutButtonCalled = false
    var updateAvatarCalled = false
    var updateProfileDetailsCalled = false
    
    func viewDidLoad() {
        viewDidLoadCalled = true
        updateProfileDetails()
        updateAvatar()
    }
    
    func didTapLogoutButton() {
        didTapLogoutButtonCalled = true
        view?.showLogoutAlert()
    }
    
    func updateAvatar() {
        updateAvatarCalled = true
        
        let testURL = URL(string: "https://example.com/avatar.jpg")!
        view?.updateAvatar(with: testURL)
    }
    
    func updateProfileDetails() {
        updateProfileDetailsCalled = true
    }
    
    
}
