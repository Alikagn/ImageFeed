//
//  AuthHelperProtocol.swift
//  ImageFeed
//
//  Created by Dmitry Batorevich on 14.06.2025.
//

import Foundation

protocol AuthHelperProtocol {
    func authRequest() -> URLRequest?
    func code(from url: URL) -> String?
}
