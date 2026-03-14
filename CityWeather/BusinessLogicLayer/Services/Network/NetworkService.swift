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
    
    func executeWithCodable<Model>(
        request: IRequest,
        parser: Parser<Model>,
        completion: @escaping ((Result<Model, NetworkError>) -> Void)
    ) where Model: Codable
}

final class NetworkService: NetworkProtocol {
    
    func executeWithCodable<Model>(
        request: IRequest,
        parser: Parser<Model>,
        completion: @escaping (Result<Model, NetworkError>) -> Void
    ) {
        
        let url = URL(string: NetworkConstants.baseURL + request.path)!
        let method: HTTPMethod = request.method
        let parameters: [String: Any] = request.parameters
        let headers: HTTPHeaders = HTTPHeaders(request.headers)
        
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
                completion(parsingResult)
            case .failure(let error):
                let error: NetworkError = self.handleError(from: error, data: response.data, statusCode: response.response?.statusCode)
                completion(.failure(error))
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
