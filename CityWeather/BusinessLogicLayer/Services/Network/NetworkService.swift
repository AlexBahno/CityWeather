//
//  NetworkService.swift
//  CityWeather
//
//  Created by Alexandr Bahno on 12.03.2026.
//

import UIKit
import Alamofire

// MARK: - NetworkProtocol
protocol NetworkProtocol {
    
    func executeWithCodable<Model: Codable>(
        request: IRequest,
        parser: Parser<Model>
    ) async throws -> Model
}

final class NetworkService: NetworkProtocol {
    
    func executeWithCodable<Model: Codable>(
        request: IRequest,
        parser: Parser<Model>
    ) async throws -> Model {
        
        let url = URL(string: NetworkConstants.baseURL + request.path)!
        let method: HTTPMethod = request.method
        let parameters: [String: Any] = request.parameters
        let headers: HTTPHeaders = HTTPHeaders(request.headers)
        
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(
                url,
                method: method,
                parameters: parameters,
                headers: headers
            )
            .validate(statusCode: 200...299)
            .responseJSON { response in
                switch response.result {
                case .success(let result):
                    let parsingResult: Result<Model, NetworkError> = parser.parse(result: result)
                    
                    switch parsingResult {
                    case .success(let model):
                        continuation.resume(returning: model)
                    case .failure(let parserError):
                        continuation.resume(throwing: parserError)
                    }
                    
                case .failure(let error):
                    let networkError: NetworkError = self.handleError(from: error, data: response.data, statusCode: response.response?.statusCode)
                    continuation.resume(throwing: networkError)
                }
            }
        }
    }
    
    private func handleError(
        from error: Error,
        data: Data?,
        statusCode: Int?
    ) -> NetworkError {
        if let data: Data = data,
           let errorDescription: String = String(data: data, encoding: String.Encoding.utf8) {
            return .server(.init(errorDescription: errorDescription, statusCode: statusCode))
        } else {
            return .network((error as? AFError) ?? AFError.sessionInvalidated(error: error))
        }
    }
}
