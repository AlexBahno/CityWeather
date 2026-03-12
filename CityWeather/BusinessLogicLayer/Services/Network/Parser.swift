//
//  Parser.swift
//  CityWeather
//
//  Created by Alexandr Bahno on 12.03.2026.
//

import Foundation

class Parser<Model: Decodable> {

    private let decoder: JSONDecoder = JSONDecoder()

    func parse(result: Any) -> Result<Model, NetworkError> {
        if let data: Data = try? JSONSerialization.data(withJSONObject: result, options: []),
           let model: Model = try? decoder.decode(Model.self, from: data) {
            return .success(model)
        }
        return .failure(.parser)
    }
}
