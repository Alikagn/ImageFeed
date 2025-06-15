//
//  WebViewViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Dmitry Batorevich on 08.06.2025.
//
@testable import ImageFeed
import Foundation

final class WebViewViewControllerSpy: WebViewViewControllerProtocol {
    var loadCalled: Bool = false
    var presenter: WebViewPresenterProtocol?
    
    func load(request: URLRequest) {
        loadCalled = true
    }
    
    func setProgressValue(_ newValue: Float) {
        
    }
    
    func setProgressHidden(_ isHidden: Bool) {
        
    }
}
