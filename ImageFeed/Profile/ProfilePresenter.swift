//
//  ProfilePresenter.swift
//  ImageFeed
//
//  Created by Dmitry Batorevich on 08.06.2025.
//

import Foundation

final class ProfilePresenter: ProfilePresenterProtocol {
//MARK: - Public Properties
    weak var view: (any ProfileViewControllerProtocol)?
    
    
//MARK: - Private Properties
     let profileService: ProfileServiceProtocol
     let profileImageService: ProfileImageServiceProtocol
     let profileLogoutService: ProfileLogoutServiceProtocol
    
    init(profileService: ProfileServiceProtocol = ProfileService.shared,
         profileImageService: ProfileImageServiceProtocol = ProfileImageService.shared,
         profileLogoutService: ProfileLogoutServiceProtocol = ProfileLogoutService.shared)
    {
        self.profileService = profileService
        self.profileImageService = profileImageService
        self.profileLogoutService = profileLogoutService
    }
    
    
//MARK: - Public Methods
    func viewDidLoad() {
        updateProfileDetails()
        updateAvatar()
        setupObserver()
    }
    
    func didTapLogoutButton() {
        profileLogoutService.logout()
    }
    
    func updateAvatar() {
        guard let profileImageURL = profileImageService.avatarURL,
              let url = URL(string: profileImageURL) else {
            view?.showDefaultAvatar()
            return
        }
        
        view?.updateAvatar(with: url)
    }
    
    func updateProfileDetails() {
        guard let profile = profileService.profile else { return }
        view?.updateProfileDetails(name: profile.name,
                                   loginName: profile.loginName,
                                   bio: profile.bio ?? "")
    }
    
// MARK: - Private methods
    private func setupObserver() {
        NotificationCenter.default.addObserver(forName: ProfileImageService.didChangeNotification,
                                               object: nil,
                                               queue: .main)
        { [weak self] _ in
            self?.updateAvatar()
        }
    }
}
