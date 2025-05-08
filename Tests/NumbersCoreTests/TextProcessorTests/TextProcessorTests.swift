//
//  TextProcessorTests.swift
//  NumbersCore
//
//  Created by Stepan Kukharskyi on 5/8/25.
//

import Foundation

import XCTest
@testable import NumbersCore

final class TextProcessorTests: XCTestCase {
    // MARK: SUT
    private var processor: TextProcessor?

    // MARK: Setup and Teardown
    override func setUp() {
        super.setUp()
        processor = TextProcessorImpl()
    }

    override func tearDown() {
        super.tearDown()
        processor = nil
    }

    // MARK: Single Number Mask Tests
    func test_SingleNumber_AllDigits() {
        let input = "42"
        let expectedOutput = "42"
        XCTAssertEqual(processor?.applySingleNumberMask(to: input), expectedOutput)
    }

    func test_SingleNumber_AllDigits_OutOfRange() {
        let input = "123456789"
        let expectedOutput = "123456"
        XCTAssertEqual(processor?.applySingleNumberMask(to: input), expectedOutput)
    }

    func test_SingleNumber_AllDigits_OnlyLetters() {
        let input = "abcd"
        let expectedOutput = String.empty
        XCTAssertEqual(processor?.applySingleNumberMask(to: input), expectedOutput)
    }

    func test_SingleNumber_AllDigits_MixLettersNumbers() {
        let input = "a4bc2d"
        let expectedOutput = "42"
        XCTAssertEqual(processor?.applySingleNumberMask(to: input), expectedOutput)
    }

    // MARK: Range Numbers Mask Tests
    func test_RangeNumbers_OneNumber() {
        let input = "10"
        let expectedOutput = "10"
        XCTAssertEqual(processor?.applyRangeNumbersMask(to: input), expectedOutput)
    }

    func test_RangeNumbers_TwoNumbers() {
        let input = "10-20"
        let expectedOutput = "10-20"
        XCTAssertEqual(processor?.applyRangeNumbersMask(to: input), expectedOutput)
    }

    func test_RangeNumbers_Letters() {
        let input = "abcd"
        let expectedOutput = String.empty
        XCTAssertEqual(processor?.applyRangeNumbersMask(to: input), expectedOutput)
    }

    func test_RangeNumbers_SpecialChars() {
        let input = "10-$20"
        let expectedOutput = "10-20"
        XCTAssertEqual(processor?.applyRangeNumbersMask(to: input), expectedOutput)
    }

    // MARK: Multiple Numbers Mask Tests
    func test_MultipleNumbers_SingleNumber() {
        let input = "10"
        let expectedOutput = "10"
        XCTAssertEqual(processor?.applyMultipleNumbersMask(to: input), expectedOutput)
    }

    func test_MultipleNumbers_MultipleNumbers() {
        let input = "10,20,30"
        let expectedOutput = "10,20,30"
        XCTAssertEqual(processor?.applyMultipleNumbersMask(to: input), expectedOutput)
    }

    func test_MultipleNumbers_MultipleNumbers_WithLetters() {
        let input = "10a,20b,30c"
        let expectedOutput = "10,20,30"
        XCTAssertEqual(processor?.applyMultipleNumbersMask(to: input), expectedOutput)
    }

    func test_MultipleNumbers_MultipleNumbers_WithSpecialChars() {
        let input = "10@,20#,30$"
        let expectedOutput = "10,20,30"
        XCTAssertEqual(processor?.applyMultipleNumbersMask(to: input), expectedOutput)
    }
}
