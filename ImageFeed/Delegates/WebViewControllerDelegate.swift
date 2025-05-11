//
//  WebViewControllerDelegate.swift
//  ImageFeed
//
//  Created by Dmitry Batorevich on 04.05.2025.
//

import Foundation
protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}
