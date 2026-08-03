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
        case .rangeFacts:
            return "range"
        case .multipleFacts:
            return "multi"
        }
    }

    var parameters: [String: String] {
        var params: [String: String] = ["json": "true"]
        switch self {
        case .rangeFacts(let min, let max):
            params["start"] = "\(min)"
            params["end"] = "\(max)"
        case .multipleFacts(let numbers):
            params["numbers"] = numbers.map { String($0) }.joined(separator: .comma)
        default:
            break
        }
        return params
    }

    var responseModel: Codable.Type {
        switch self {
        case .singleFact, .randomFact:
            return FactResponse.self
        case .rangeFacts, .multipleFacts:
            return [MultiFactResponse].self
        }
    }
}
