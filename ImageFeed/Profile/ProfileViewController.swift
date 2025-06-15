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

final class ProfileViewController: UIViewController, ProfileViewControllerProtocol {
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
        button.accessibilityIdentifier = "logout button"
        button.setImage(UIImage(named: "logout_button"), for: .normal)
        button.tintColor = .ypRed
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        return button
    }()
    
    //private let profileLogoutService = ProfileLogoutService.shared
    
    var presenter: ProfilePresenterProtocol? = ProfilePresenter()
    
    // MARK: - Lifecycle
         override func viewDidLoad() {
             super.viewDidLoad()
             
             view.backgroundColor = .ypBlack
             
             setupView()
             
             presenter?.view = self
             presenter?.viewDidLoad()
         }
         
         override func viewDidAppear(_ animated: Bool) {
             super.viewDidAppear(animated)
         }
         
     //MARK: - Public Methods
         
         func updateProfileDetails(name: String, loginName: String, bio: String) {
             userNameLabel.text = name
             userLoginNameLabel.text = loginName
             userDescriptionLabel.text = bio
         }
         
         func updateAvatar(with url: URL) {
             userAvatarImageView.kf.setImage(
                 with: url,
                 placeholder: UIImage(named: "placeholderAvatar"),
                 options: [
                     .transition(.fade(0.2)),
                     .processor(DownsamplingImageProcessor(size: CGSize(width: 140, height: 140)))
                 ]
             )
         }
         
         func showDefaultAvatar() {
             userAvatarImageView.image = UIImage(named: "placeholderAvatar")
         }
         
         func showLogoutAlert() {
             let alert = UIAlertController(title: "Пока, пока!",
                                           message: "Уверены, что хотите выйти?",
                                           preferredStyle: .alert)
             
             let yesAction = UIAlertAction(title: "Да", style: .default) { [weak self] _ in
                 self?.presenter?.didTapLogoutButton()
             }
             yesAction.accessibilityIdentifier = "Да"
             alert.addAction(yesAction)
             
             let noAction = UIAlertAction(title: "Нет", style: .cancel)
             noAction.accessibilityIdentifier = "Нет"
             alert.addAction(noAction)
             
             present(alert, animated: true) {
                 alert.view.accessibilityIdentifier = "Пока, пока!"
             }
         }
         
     // MARK: - Private methods
         private func setupView() {
             [userAvatarImageView, userNameLabel, userLoginNameLabel, userDescriptionLabel, logoutButton].forEach {
                 $0.translatesAutoresizingMaskIntoConstraints = false
                 view.addSubview($0)
             }
             setConstraints()
         }
         
     // MARK: - Actions
         @objc private func didTapButton() {
             showLogoutAlert()
         }
     }

     //MARK: - Constraints
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

     extension ProfileViewController {
         func testableViews() -> (
             imageView: UIImageView,
             nameLabel: UILabel,
             loginNameLabel: UILabel,
             descriptionLabel: UILabel,
             logoutButton: UIButton
         ) {
             return (userAvatarImageView, userNameLabel, userLoginNameLabel, userDescriptionLabel, logoutButton)
         }
     }
