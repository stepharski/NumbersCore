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
        let fact = FactItem(number: number, type: "trivia", text: text)
        storage?.save(fact)
        let result = storage?.load(for: "\(number)")
        XCTAssertEqual(result?.number, number)
        XCTAssertEqual(result?.text, text)
    }

    // MARK: Batch Fact Tests
    func test_saveLoad_batchFact() {
        let firstFact = FactItem(
            number: 7,
            type: "trivia",
            text: "7 is the maximum number of times a letter-sized paper can be folded in half.")
        let lastFact = FactItem(
            number: 99,
            type: "trivia",
            text: "99 is a common price ending in psychological pricing.")
        let batch = [firstFact, lastFact]
        let keys = batch.map { "\($0.number)" }

        storage?.saveMulti(batch)
        let result = storage?.loadMultiFacts(for: keys)
        XCTAssertEqual(result?.count, batch.count)

        XCTAssertEqual(result?.first?.number, batch.first?.number)
        XCTAssertEqual(result?.last?.number, batch.last?.number)

        XCTAssertEqual(result?.first?.text, firstFact.text)
        XCTAssertEqual(result?.last?.text, lastFact.text)
    }

    // MARK: Missing Keys Tests
    func test_missingKeys() {
        let keys = ["1", "2", "3"]
        let fact = FactItem(
            number: 1,
            type: "trivia",
            text: "Strored")
        storage?.save(fact)
        let result = storage?.missingKeys(from: keys)
        XCTAssertEqual(result?.count, keys.count - 1)
        XCTAssertNotEqual(result?.first, keys.first)
    }

    // MARK: Clear Cahce Tests
    func test_clearCache() {
        let fact = FactItem(
            number: 100,
            type: "trivia",
            text: "Clearing purposes")
        storage?.save(fact)
        storage?.clearCache()
        let result = storage?.load(for: "100")
        XCTAssertNil(result)
    }
}
