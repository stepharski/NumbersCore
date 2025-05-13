//
//  ApiPath.swift
//  NumbersCore
//
//  Created by Stepan Kukharskyi on 5/6/25.
//

import Foundation

// MARK: - HTTPMethod
enum HTTPMethod: String {
    case get
}

// MARK: - ApiPath
enum ApiPath {
    // MARK: Cases
    case singleFact(number: Int)
    case randomFact
    case rangeFacts(min: Int, max: Int)
    case multipleFacts(numbers: [Int])

    // MARK: Properties
    var method: HTTPMethod {
        return .get
    }

    var baseURL: String {
        return NetworkConstants.numbersBaseURL
    }

    var path: String {
        switch self {
        case .singleFact(let number):
            return "\(number)"
        case .randomFact:
            return "random"
        case .rangeFacts(let min, let max):
            return "\(min)..\(max)"
        case .multipleFacts(let numbers):
            return numbers.map { String($0) }.joined(separator: .comma)
        }
    }

    var parameters: [String: String] {
        return ["json": "true"]
    }

    var responseModel: Codable.Type {
        switch self {
        case .singleFact, .randomFact:
            return FactResponse.self
        case .rangeFacts, .multipleFacts:
            return BatchFactsResponse.self
        }
    }
}
