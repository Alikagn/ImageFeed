//
//  WebViewPresenter.swift
//  ImageFeed
//
//  Created by Dmitry Batorevich on 07.06.2025.
//

import Foundation

final class WebViewPresenter: WebViewPresenterProtocol {
    var authHelper: AuthHelperProtocol
        
        init(authHelper: AuthHelperProtocol) {
            self.authHelper = authHelper
        }
    
    weak var view: WebViewViewControllerProtocol?
    
    func viewDidLoad() {
        guard let request = authHelper.authRequest() else { return }
        didUpdateProgressValue(0)
        view?.load(request: request)
      }
    
    func code(from url: URL) -> String? {
        authHelper.code(from: url)
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
        let newProgressValue = Float(newValue)
        view?.setProgressValue(newProgressValue)
        
        let shouldHideProgress = shouldHideProgress(for: newProgressValue)
        view?.setProgressHidden(shouldHideProgress)
    }
    
    func shouldHideProgress(for value: Float) -> Bool {
        abs(value - 1.0) <= 0.0001
    }
    
}
