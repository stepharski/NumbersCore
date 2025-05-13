//
//  NetworkService.swift
//  NumbersCore
//
//  Created by Stepan Kukharskyi on 5/6/25.
//

import Foundation

// MARK: - NetworkServiceProtocol
protocol NetworkServiceProtocol {
    func request<T: Codable>(_ route: ApiPath) async throws -> T
}

// MARK: - NetworkService
class NetworkService: NetworkServiceProtocol {
    // MARK: Properties
    private let decoder = JSONDecoder()

    // MARK: Generic request
    public func request<T>(_ route: ApiPath) async throws -> T where T: Codable {
        var urlComp = URLComponents(string: route.baseURL + route.path)
        urlComp?.queryItems = route.parameters.map {
            URLQueryItem(name: $0.key, value: $0.value)
        }
        guard let url = urlComp?.url else {
            throw AppError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = route.method.rawValue
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let response = response as? HTTPURLResponse,
                  (200...299).contains(response.statusCode) else {
                throw AppError.invalidResponse
            }
            guard
                let responseModel = route.responseModel as? T.Type,
                let decodedResponse = try? self.decoder.decode(
                    responseModel,
                    from: data)
            else { throw AppError.invalidData }
            return decodedResponse
        } catch {
            throw AppError.invalidResponse
        }
    }
}
