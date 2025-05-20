//
//  AuthViewControllerDelegate.swift
//  ImageFeed
//
//  Created by Dmitry Batorevich on 04.05.2025.
//

import UIKit

protocol AuthViewControllerDelegate: AnyObject {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String)
}
