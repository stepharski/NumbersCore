//
//  TextProcessor.swift
//  NumbersCore
//
//  Created by Stepan Kukharskyi on 5/6/25.
//

import Foundation

// MARK: - TextProcessor
public protocol TextProcessor {
    var maxDigitsCount: Int { get }
    var maxRangeCount: Int { get }
    func applySingleNumberMask(to text: String) -> String
    func applyRangeNumbersMask(to text: String) -> String
    func applyMultipleNumbersMask(to text: String) -> String
}

// MARK: - TextProcessorImpl
public final class TextProcessorImpl: TextProcessor {
    // MARK: Variables
    public var maxDigitsCount: Int = 6
    public var maxRangeCount: Int = 100

    // MARK: Masks
    public func applySingleNumberMask(to text: String) -> String {
        let number = text.filter { $0.isNumber }
        let maxCount = number.first == "0" ? 1 : maxDigitsCount
        return String(number.prefix(maxCount))
    }

    public func applyRangeNumbersMask(to text: String) -> String {
        guard !text.hasPrefix(.hyphen) else { return .empty }
        let components = text.components(separatedBy: String.hyphen)
        if components.count < 2 {
            let firstNumber = components.first?.filter { $0.isNumber } ?? .empty
            let maxCount = firstNumber.first == .zero ? 1 : maxDigitsCount
            return String(firstNumber.prefix(maxCount))
        } else if let firstComp = components.first,
                  let secondComp = components[safe: 1] {
            let firstNumber = firstComp.filter { $0.isNumber }
            let firstMaxCount = firstNumber.first == .zero ? 1 : maxDigitsCount
            let firstNumberTrimmed = firstNumber.prefix(firstMaxCount)
            let secondNumber = secondComp.filter { $0.isNumber }
            let secondNumberCount = secondNumber.first == .zero ? 1 : maxDigitsCount
            let secondNumberTrimmed = secondNumber.prefix(secondNumberCount)
            return "\(firstNumberTrimmed)\(String.hyphen)\(secondNumberTrimmed)"
        }
        return .empty
    }

    public func applyMultipleNumbersMask(to text: String) -> String {
        guard !text.hasPrefix(String.comma) else { return .empty }
        if text.hasSuffix(String.comma) { return text }
        let components = text.components(separatedBy: String.comma)
        let trimmedComps = components.map { comp in
            let number = comp.filter { $0.isNumber }
            let maxCount = number.first == .zero ? 1 : maxDigitsCount
            return String(number.prefix(maxCount))
        }
        return trimmedComps
            .filter { !$0.isEmpty }
            .joined(separator: String.comma)
    }

    // MARK: Numbers Extraction
    public func getRangeNumbers(in text: String) throws -> (min: Int, max: Int) {
        let components = text.components(separatedBy: String.hyphen)
        guard
            components.count == 2,
            let firstComp = components.first,
            let lastComp = components.last,
            let min = Int(firstComp),
            let max = Int(lastComp)
        else { throw AppError.invalidRangeCount }
        guard min < max else { throw AppError.invalidRangeIncremental }
        return (min: min, max: max)
    }

    public func getMultipleNumbers(in text: String) throws -> [Int] {
        let components = text.components(separatedBy: String.comma)
        guard components.count > 0 else { throw AppError.noEntry }
        let numbers = try components.map { comp in
            guard let number = Int(comp) else { throw AppError.invalidEntry }
            return number
        }
        return numbers
    }
}
