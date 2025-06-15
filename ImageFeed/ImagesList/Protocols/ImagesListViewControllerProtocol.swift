//
//  ImagesListViewControllerProtocol.swift
//  ImageFeed
//
//  Created by Dmitry Batorevich on 11.06.2025.
//

import Foundation

protocol ImagesListViewControllerProtocol: AnyObject {
    func updateTableViewAnimated()
    func performBatchUpdates(oldCount: Int, newCount: Int)
    func showLikeAlert(_ error: Error)
    func showImageAlert()
}
