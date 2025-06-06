//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Dmitry Batorevich on 04.04.2025.
//

import UIKit
import Kingfisher
import SwiftKeychainWrapper

struct ProfileImage: Codable {
    let large: String
}

final class ProfileViewController: UIViewController {
    private let profileService = ProfileService.shared
    private var profileImageServiceObserver: NSObjectProtocol? //
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProvideDidChange")
    
    private lazy var userAvatarImageView: UIImageView = {
        let profileImage = UIImage(named: "avatar")
        let imageView = UIImageView(image: profileImage)
        imageView.layer.cornerRadius = 35
        imageView.clipsToBounds = true
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
    
    private let profileLogoutService = ProfileLogoutService.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubView()
        setConstraints()
        updateProfileDetails()

    }
    
    private func addSubView() {
        view.backgroundColor = .ypBlack
        
        let elementsOnView = [userAvatarImageView, userNameLabel, userLoginNameLabel, userDescriptionLabel, logoutButton]
        elementsOnView.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }
    
    private func updateProfileDetails() {
        if let profile = profileService.profile {
            userNameLabel.text = profile.name
            userLoginNameLabel.text = profile.loginName
            userDescriptionLabel.text = profile.bio
        }
        updateUserFoto()
    }
    
   @objc private func didTapButton() {
       let alert = UIAlertController(title: "Пока, пока!",
                                     message: "Уверены, что хотите выйти?",
                                     preferredStyle: .alert)
       alert.addAction(UIAlertAction(title: "Да", style: .default) { [weak self] _ in
           self?.profileLogoutService.logout()
       })
       alert.addAction(UIAlertAction(title: "Нет", style: .cancel))
       present(alert, animated: true)
   }

    
    private func updateUserFoto() {
        
        DispatchQueue.main.async {
            guard
                let profileImageURL = ProfileImageService.shared.avatarURL,
                let url = URL(string: profileImageURL)
            else {
                print("[updateUserFotoImageView]: Картинка профиля не найдена или URL невалиден")
                return
            }
            
            self.userAvatarImageView.kf.setImage(
                with: url,
                placeholder: UIImage(named: "placeholder"),
                options: [
                    .transition(.fade(0.2)),
                    .processor(DownsamplingImageProcessor(size: CGSize(width: 140, height: 140)))
                ]
            ) { result in
                switch result {
                case .success(let value):
                    print("[updateUserFotoImageView]: Изображение успешно загружено: \(value.source.url?.absoluteString ?? "")")
                case .failure(let error):
                    print("[updateUserFotoImageView]: Ошибка загрузки изображения: \(error.localizedDescription)")
                }
            }
        }
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

