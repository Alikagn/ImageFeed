//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Dmitry Batorevich on 04.04.2025.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    private let avatarImageView = UIImageView(image: UIImage(named: "avatar"))
    private let userNameLabel = UILabel()
    private let userLoginNameLabel = UILabel()
    private let userDescriptionLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        showAvatar()
        showUserName()
        userLoginName()
        userDescription()
        logout()
    }
    
    private func showAvatar () {
        avatarImageView.tintColor = .gray
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(avatarImageView)
        avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
        avatarImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        avatarImageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        avatarImageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
    }
    
    private func showUserName() {
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(userNameLabel)
        userNameLabel.text = "Екатерина Новикова"
        userNameLabel.font = .systemFont(ofSize: 23, weight: .bold)
        userNameLabel.textColor = .white
        userNameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 16).isActive = true
        userNameLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor).isActive = true
        userNameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 8).isActive = true
    }
    
    private func userLoginName() {
        userLoginNameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(userLoginNameLabel)
        userLoginNameLabel.text = "@ekaterina_nov"
        userLoginNameLabel.font = .systemFont(ofSize: 13, weight: .medium)
        userLoginNameLabel.textColor = .gray
        userLoginNameLabel.trailingAnchor.constraint(equalTo: userNameLabel.trailingAnchor).isActive = true
        userLoginNameLabel.leadingAnchor.constraint(equalTo: userNameLabel.leadingAnchor).isActive = true
        userLoginNameLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 8).isActive = true
    }
    
    private func userDescription() {
        userDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(userDescriptionLabel)
        userDescriptionLabel.text = "Hello, World!"
        userDescriptionLabel.font = .systemFont(ofSize: 13, weight: .medium)
        userDescriptionLabel.textColor = .white
        userDescriptionLabel.trailingAnchor.constraint(equalTo: userLoginNameLabel.trailingAnchor, constant: 16).isActive = true
        userDescriptionLabel.leadingAnchor.constraint(equalTo: userLoginNameLabel.leadingAnchor).isActive = true
        userDescriptionLabel.topAnchor.constraint(equalTo: userLoginNameLabel.bottomAnchor, constant: 8).isActive = true
    }
    
    private func logout() {
        let logoutButton = UIButton.systemButton(
            with: UIImage(named: "logout_button")!,
            target: nil,
            action: #selector(Self.didTapLogoutButton)
        )
        view.addSubview(logoutButton)
        
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.tintColor = .red
        logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        logoutButton.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor).isActive = true
        logoutButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
        logoutButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
    }
    
    @objc
    private func didTapLogoutButton() {
        
    }
}
