//
//  File.swift
//  NumbersCore
//
//  Created by Stepan Kukharskyi on 5/6/25.
//

import Foundation

enum AppError: String, Error {
    case invalidEntry = "Invalid number entry"
    case noEntry = "Please enter number to display fact"
    case invalidRangeCount = "Range should have min and max numbers"
    case invalidRangeIncremental =  "Range should be incremental"
    case timeoutError = "Your request has timed out."
    case invalidURL = "Invalid URL. Please try again."
    case invalidResponse = "Invalid response from server. Please try again."
    case invalidData = "The data received from server is invalid. Please try again."
    case networkError = "Unable to complete your request. Please check your connection."
}
