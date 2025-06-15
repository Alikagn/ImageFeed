//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Dmitry Batorevich on 30.04.2025.
//

import UIKit
/*
final class SplashViewController: UIViewController {
    // MARK: - Private Properties
    private let showAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"
    private let oauth2Service = OAuth2Service.shared
    private let oauth2TokenStorage = OAuth2TokenStorage.shared
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    /*
    private let splashImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Vector")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    */
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
       // setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        checkAuthStatusAndProceed()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    // MARK: - Status Bar Style
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    // MARK: - Private methods
    /*
    private func setupView() {
        view.backgroundColor = .ypBlack
        view.addSubview(splashImageView)
        
        setConstraints()
    }
    */
    
    private func checkAuthStatusAndProceed() {
        if let token = oauth2TokenStorage.token {
            fetchProfile(token)
        } else {
            showAuthViewController()
        }
    }
    
    private func switchToTabBarController() {
        DispatchQueue.main.async {
            guard let window = UIApplication.shared.windows.first else {
                assertionFailure("Invalid Configuration")
                return
            }
            
            let tabBarController = TabBarController()
            
            window.rootViewController = tabBarController
            
            print("TabBarController установлен как корневой контроллер.")
        }
    }
    
    private func fetchProfile(_ token: String) {
        profileService.fetchProfile(token) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let profile):
                
                self.profileImageService.fetchProfileImageURL(username: profile.username) { _ in }
                
                self.switchToTabBarController()
                
            case .failure(let error):
                print("Failed to fetch profile: \(error)")
                
                self.showErrorAlert(message: "Не удалось загрузить профиль. Пожалуйста, попробуйте снова.")
            }
        }
    }
    
    private func showAuthViewController() {
        let authViewController = AuthViewController()
        authViewController.delegate = self
        authViewController.modalPresentationStyle = .fullScreen
        present(authViewController, animated: true, completion: nil)
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(
            title: "Ошибка",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func fetchOAuthToken(_ code: String) {
        oauth2Service.fetchOAuthToken(code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let token):
                
                self.oauth2TokenStorage.token = token
                
                self.fetchProfile(token)
                
            case .failure(let error):
                print("Failed to fetch OAuth token: \(error)")
                
                self.showErrorAlert(message: "Не удалось войти. Пожалуйста, попробуйте снова.")
            }
        }
    }
}

// MARK: - AuthViewControllerDelegate
extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        dismiss(animated: true)
    }
}

//MARK: - Constraints
/*
extension SplashViewController {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            splashImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            splashImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            splashImageView.widthAnchor.constraint(equalToConstant: 75),
            splashImageView.heightAnchor.constraint(equalToConstant: 77.68)
        ])
    }
}
*/
*/

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
         //guard let token = oauth2TokenStorage.token else { return }
         
         if oauth2TokenStorage.token != nil {
             let token = oauth2TokenStorage.token! //  Привести к нормальному значению
             fetchProfile(token)
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

    private func fetchProfile(_ token: String) {
        UIBlockingProgressHUD.show()
        
        profileService.fetchProfile(token) { [weak self] result in
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

