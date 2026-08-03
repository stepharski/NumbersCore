//
//  File.swift
//  NumbersCore
//
//  Created by Stepan Kukharskyi on 8/3/26.
//

import Foundation

public struct FactItem {
    public let number: Int
    public let type: String
    public let text: String

    public init(number: Int, type: String, text: String) {
        self.number = number
        self.type = type
        self.text = text
    }
}
