//
//  ImagesListCellDelegate.swift
//  ImageFeed
//
//  Created by Dmitry Batorevich on 04.06.2025.
//

import Foundation

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}
