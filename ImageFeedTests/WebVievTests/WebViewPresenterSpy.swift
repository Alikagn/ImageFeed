//
//  WebViewPresenterSpy.swift
//  ImageFeedTests
//
//  Created by Dmitry Batorevich on 08.06.2025.
//

@testable import ImageFeed
import Foundation
import ImageFeed

final class WebViewPresenterSpy: WebViewPresenterProtocol {
    var viewDidLoadCalled: Bool = false
    var view: WebViewViewControllerProtocol?
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
        
    }
    
    func code(from url: URL) -> String? {
        return nil
    }
}
