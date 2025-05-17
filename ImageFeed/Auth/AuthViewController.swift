//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Dmitry Batorevich on 23.04.2025.
//

import UIKit

final class AuthViewController: UIViewController {
    
    private let showWebViewSegueIdentifier = "ShowWebView"
    private let oauth2Service = OAuth2Service.shared
    weak var delegate: AuthViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackButton()
    }
    
    private func configureBackButton() {
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "nav_back_button")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "nav_back_button")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .ypBlack
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showWebViewSegueIdentifier {
            guard
                let webViewViewController = segue.destination as? WebViewViewController
            else {
                assertionFailure("Failed to prepare for \(showWebViewSegueIdentifier)")
                return
            }
                webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        OAuth2Service.shared.fetchOAuthToken(code) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let token):
                OAuth2TokenStorage.shared.token = token
                print("Токен получен и сохранен: \(token)")
                
                DispatchQueue.main.async {
                    self.delegate?.authViewController(self, didAuthenticateWithCode: code)
                    self.dismiss(animated: true)
                }
                
            case .failure(let error):
                print("Ошибка: токен не получен: \(error)")
            }
        }
    }
    
   func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
      dismiss(animated: true)
   }
}
