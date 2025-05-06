//
//  FactResponse.swift
//  NumbersCore
//
//  Created by Stepan Kukharskyi on 5/6/25.
//

import Foundation

// MARK: - FactResponse
struct FactResponse: Codable {
    let text: String
    let number: Int
    let found: Bool
    let type: String
}
