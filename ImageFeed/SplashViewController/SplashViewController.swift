//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Dmitry Batorevich on 30.04.2025.
//

import UIKit

final class SplashViewController: UIViewController {
    private let ShowAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"
    
    private let oauth2Service = OAuth2Service.shared
    private let oauth2TokenStorage = OAuth2TokenStorage.shared
    
    private let profileService = ProfileService.shared
    
    private lazy var splashImageView: UIImageView = {
        let splashImage = UIImage(named: "Vector")
        let imageView = UIImageView(image: splashImage)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypBlack
        view.addSubview(splashImageView)
        setConstraints()
    }
    
     override func viewDidAppear(_ animated: Bool) {
         super.viewDidAppear(animated)
         
         if oauth2TokenStorage.token != nil {
             fetchProfile()
             print("Token exists, fetching profile")
         } else {
             presentAuthViewController()
             print("Token is nil, showing authentication screen")
         }
     }
    
     func presentAuthViewController() {
         let storyboard = UIStoryboard(name: "Main", bundle: nil)

         guard let authVC = storyboard.instantiateViewController(withIdentifier: "AuthViewController") as? AuthViewController else {
             return
         }
         
         authVC.delegate = self
         
         let navigationController = UINavigationController(rootViewController: authVC)

         navigationController.modalPresentationStyle = .fullScreen
         
         present(navigationController, animated: true, completion: nil)
     }
     
    private func fetchProfile() {
        UIBlockingProgressHUD.show()
        
        profileService.fetchProfile { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            
            guard let self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let profile):
                    let username = profile.username
                    ProfileImageService.shared.fetchProfileImageURL(username: username) { _ in }
                    self.switchToTabBarController()
                case .failure:
                    // TODO: Обработка ошибки загрузки профиля
                    print("Ошибка загрузки профиля")
                }
            }
        }
    }
    
private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }
}

extension SplashViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowAuthenticationScreenSegueIdentifier {
            guard
                let navigationController = segue.destination as? UINavigationController,
                let viewController = navigationController.viewControllers[0] as? AuthViewController
            else {
                print("Ошибка: не готов \(ShowAuthenticationScreenSegueIdentifier)")
                return
            }
            viewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        dismiss(animated: true) {
            self.fetchOAuthToken(code)
        }
    }
    
    private func fetchOAuthToken(_ code: String) {
        oauth2Service.fetchOAuthToken(code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                print("Токен получен")
                self.switchToTabBarController()
            case .failure:
                // TODO [Sprint 11]
                print("Ошибка получения токена")
                break
            }
        }
    }
}


extension SplashViewController {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            splashImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            splashImageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            splashImageView.widthAnchor.constraint(equalToConstant: 75),
            splashImageView.heightAnchor.constraint(equalToConstant: 78)
        ])
    }
}
