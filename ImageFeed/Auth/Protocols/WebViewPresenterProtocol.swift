//
//  WebViewPresenterProtocol.swift
//  ImageFeed
//
//  Created by Dmitry Batorevich on 14.06.2025.
//

import Foundation

public protocol WebViewPresenterProtocol {
    var view: WebViewViewControllerProtocol? { get set }
    func viewDidLoad()
    func didUpdateProgressValue(_ newValue: Double)
    func code(from url: URL) -> String?
}
