//
//  MultiFactResponse.swift
//  NumbersCore
//
//  Created by Stepan Kukharskyi on 8/3/26.
//

import Foundation

struct MultiFactResponse: Codable {
    let number: Int
    let type: String
    let text: String
}

extension MultiFactResponse {
    func toFactItem() -> FactItem {
        return FactItem(number: number, type: type, text: text)
    }
}
