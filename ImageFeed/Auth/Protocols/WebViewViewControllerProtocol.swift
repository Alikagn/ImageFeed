//
//  WebViewViewControllerProtocol.swift
//  ImageFeed
//
//  Created by Dmitry Batorevich on 14.06.2025.
//

import Foundation

public protocol WebViewViewControllerProtocol: AnyObject {
    var presenter: WebViewPresenterProtocol? { get set }
    func load(request: URLRequest)
    func setProgressValue(_ newValue: Float)
    func setProgressHidden(_ isHidden: Bool)
}
