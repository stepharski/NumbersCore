//
//  File.swift
//  NumbersCore
//
//  Created by Stepan Kukharskyi on 5/8/25.
//

import XCTest
@testable import NumbersCore

final class FactsServiceTests: XCTestCase {
    // MARK: SUT
    private var mockNetworkService: MockNetworkService?

    // MARK: Setup and Teardown
    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
    }

    override func tearDown() {
        super.tearDown()
        mockNetworkService = nil
    }

    // MARK: Single Number Tests
    func test_singleNumber_validReponse() async throws {
        let number = 42
        let text = "42 is the number of museums in Amsterdam (Netherlands has the highest concentration of museums in the world)."
        mockNetworkService?.responseType = .valid
        do {
            let fact = try await mockNetworkService?.fetchSingleFact(number: number)
            XCTAssertEqual(fact?.number, number)
            XCTAssertEqual(fact?.text, text)
        } catch let error {
            XCTFail("Result failure with error: \(error)")
        }
    }

    func test_singleNumber_invalidReponse() async throws {
        let number = 420000000
        let text = "420000000 is a boring number."
        mockNetworkService?.responseType = .invalid
        do {
            let fact = try await mockNetworkService?.fetchSingleFact(number: number)
            XCTAssertEqual(fact?.number, number)
            XCTAssertEqual(fact?.text, text)
        } catch let error {
            XCTFail("Result failure with error: \(error)")
        }
    }

    // MARK: Range Numbers Tests
    func test_rangeNumbers_validReponse() async throws {
        let min = 10
        let max = 20
        let minText = "10 is the number of years in a decade."
        let maxText = "20 is the number of baby teeth in the deciduous dentition."
        mockNetworkService?.responseType = .valid
        do {
            let facts = try await mockNetworkService?.fetchRangeFacts(min: min,
                                                                    max: max)
            XCTAssertEqual(facts?.count, max - min + 1)
            XCTAssertEqual(facts?.first?.number, min)
            XCTAssertEqual(facts?.last?.number, max)
            XCTAssertEqual(facts?.first?.text, minText)
            XCTAssertEqual(facts?.last?.text, maxText)
        } catch let error {
            XCTFail("Result failure with error: \(error)")
        }
    }

    func test_rangeNumbers_invalidReponse() async throws {
        let min = 20
        let max = 10
        mockNetworkService?.responseType = .invalid
        do {
            let facts = try await mockNetworkService?
                .fetchRangeFacts(min: min, max: max)
            XCTAssertEqual(facts?.count, 0)
        } catch let error {
            XCTFail("Result failure with error: \(error)")
        }
    }

    // MARK: Multiple Numbers Tests
    func test_multipleNumbers_validReponse() async throws {
        let numbers = [7,15,99]
        let firstText = "7 is the maximum number of times a letter-sized paper can be folded in half."
        let lastText = "99 is a common price ending in psychological pricing."
        mockNetworkService?.responseType = .valid
        do {
            let facts = try await mockNetworkService?.fetchMultipleFacts(numbers: numbers)
            XCTAssertEqual(facts?.count, numbers.count)
            XCTAssertEqual(facts?.first?.number, numbers.first)
            XCTAssertEqual(facts?.last?.number, numbers.last)
            XCTAssertEqual(facts?.first?.text, firstText)
            XCTAssertEqual(facts?.last?.text, lastText)
        } catch let error {
            XCTFail("Result failure with error: \(error)")
        }
    }

    func test_multipleNumbers_invalidReponse() async throws {
        let numbers: [Int] = []
        mockNetworkService?.responseType = .invalid
        do {
            let facts = try await mockNetworkService?.fetchMultipleFacts(numbers: numbers)
            XCTAssertEqual(facts?.count, numbers.count)
        } catch let error {
            XCTFail("Result failure with error: \(error)")
        }
    }
}

