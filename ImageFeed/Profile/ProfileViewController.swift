//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Dmitry Batorevich on 04.04.2025.
//

import UIKit

final class ProfileViewController: UIViewController {
   
    private lazy var userAvatarImageView: UIImageView = {
        let profileImage = UIImage(named: "avatar")
        let imageView = UIImageView(image: profileImage)
        return imageView
    }()
    
    private lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Екатерина Новикова"
        label.textColor = .ypWhite
        label.font = .boldSystemFont(ofSize: 23)
        return label
    }()
    
    private lazy var userLoginNameLabel: UILabel = {
        let label = UILabel()
        label.text = "@ekaterina_nov"
        label.textColor = .ypGray
        label.font = .systemFont(ofSize: 13)
        return label
    }()
    
    private lazy var userDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Hello, world!"
        label.textColor = .ypWhite
        label.font = .systemFont(ofSize: 13)
        return label
    }()
    
    private lazy var logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "logout_button"), for: .normal)
        button.tintColor = .ypRed
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubView()
        setConstraints()
    }
    
    private func addSubView() {
        view.backgroundColor = .ypBlack
        
        let elementsOnView = [userAvatarImageView, userNameLabel, userLoginNameLabel, userDescriptionLabel, logoutButton]
        elementsOnView.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }
    
    @objc private func didTapButton() {
        // TODO: - Добавить логику при нажатии на кнопку
    }
}

extension ProfileViewController {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            userAvatarImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            userAvatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            userAvatarImageView.widthAnchor.constraint(equalToConstant: 70),
            userAvatarImageView.heightAnchor.constraint(equalToConstant: 70),
            
            userNameLabel.leadingAnchor.constraint(equalTo: userAvatarImageView.leadingAnchor),
            userNameLabel.topAnchor.constraint(equalTo: userAvatarImageView.bottomAnchor, constant: 8),
            
            userLoginNameLabel.leadingAnchor.constraint(equalTo: userAvatarImageView.leadingAnchor),
            userLoginNameLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 8),
            
            userDescriptionLabel.leadingAnchor.constraint(equalTo: userAvatarImageView.leadingAnchor),
            userDescriptionLabel.topAnchor.constraint(equalTo: userLoginNameLabel.bottomAnchor, constant: 8),
            
            logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            logoutButton.centerYAnchor.constraint(equalTo: userAvatarImageView.centerYAnchor)
        ])
    }
}
