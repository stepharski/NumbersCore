//
//  File.swift
//  NumbersCore
//
//  Created by Stepan Kukharskyi on 5/8/25.
//

import Foundation

// MARK: - FactsJSONResponse
enum FactsJSONResponse: String {
    case singleFactValid = "SingleFactValidResponse"
    case singleFactInvalid = "SingleFactInvalidResponse"
    case rangeFactsValid = "RangeFactsValidResponse"
    case rangeFactsInvalid = "RangeFactsInvalidResponse"
    case multipleFactsValid = "MultipleFactsValidResponse"
    case multipleFactsInvalid = "MultipleFactsInvalidResponse"

    var url: URL? {
        return Bundle.module.url(
            forResource: self.rawValue,
            withExtension: "json",
            subdirectory: "MockJSONResponses")
    }
}

