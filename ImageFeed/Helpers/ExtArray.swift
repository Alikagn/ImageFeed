//
//  ExtArray.swift
//  ImageFeed
//
//  Created by Dmitry Batorevich on 07.06.2025.
//

import Foundation

extension Array {
    func withReplaced(itemAt index: Int, newValue: Element) -> [Element] {
        var newArray = self
        guard index >= 0 && index < newArray.count else { return newArray }
        newArray[index] = newValue
        return newArray
    }
}
