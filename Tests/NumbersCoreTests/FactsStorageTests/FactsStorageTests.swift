//
//  File.swift
//  NumbersCore
//
//  Created by Stepan Kukharskyi on 5/8/25.
//

import XCTest
import Foundation
@testable import NumbersCore

final class FactsStorageTests: XCTestCase {
    // MARK: SUT
    private var storage: FactsStorage?

    // MARK: Setup and Teardown
    override func setUp() {
        super.setUp()
        storage = FactsStorage()
    }

    override func tearDown() {
        super.tearDown()
        storage = nil
    }

    // MARK: Single Fact Tests
    func test_saveLoad_singleFact() {
        let number = 42
        let text = "42 is the answer"
        let fact = FactResponse(
            text: text,
            number: number,
            found: true,
            type: "trivia")
        storage?.save(fact)
        let result = storage?.load(for: "\(number)")
        XCTAssertEqual(result?.number, number)
        XCTAssertEqual(result?.found, true)
        XCTAssertEqual(result?.text, text)
    }

    // MARK: Batch Fact Tests
    func test_saveLoad_batchFact() {
        let numbers = [7,99]
        let firstFact = "7 is the maximum number of times a letter-sized paper can be folded in half."
        let lastFact = "99 is a common price ending in psychological pricing."
        let batch = BatchFactsResponse(facts: [
            "\(numbers.first ?? 7)": firstFact,
            "\(numbers.last ?? 99)": lastFact
        ])
        storage?.saveBatch(batch)
        let result = storage?.loadSortedFacts(for: batch.sortedKeys)
        XCTAssertEqual(result?.count, numbers.count)
        XCTAssertEqual(result?.first?.key, "\(numbers.first ?? 7)")
        XCTAssertEqual(result?.last?.key, "\(numbers.last ?? 99)")
        XCTAssertEqual(result?.first?.value.text, firstFact)
        XCTAssertEqual(result?.last?.value.text, lastFact)
    }

    // MARK: Missing Keys Tests
    func test_missingKeys() {
        let keys = ["1", "2", "3"]
        let fact = FactResponse(
            text: "Stored",
            number: 1,
            found: true,
            type: "trivia")
        storage?.save(fact)
        let result = storage?.missingKeys(from: keys)
        XCTAssertEqual(result?.count, keys.count - 1)
        XCTAssertNotEqual(result?.first, keys.first)
    }

    // MARK: Clear Cahce Tests
    func test_clearCache() {
        let fact = FactResponse(
            text: "Clearing purposes",
            number: 100,
            found: true,
            type: "trivia")
        storage?.save(fact)
        storage?.clearCache()
        let result = storage?.load(for: "100")
        XCTAssertNil(result)
    }
}
