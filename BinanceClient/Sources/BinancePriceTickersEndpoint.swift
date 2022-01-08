//
//  BinancePriceTickersEndpoint.swift
//  BinanceAPI
//
//  Created by Overcout on 27.11.2021.
//

import Foundation
import CryptoKit

// MARK: - BinanceCoin
public struct PriceTicker: Codable {
    
    let symbol: String
    let price: String
}

public struct BinancePriceTickersEndpoint: EndpointProtocol {
    
    let api: API

    var endpoint = Endpoint(
        host: "binance.me",
        path: "/api/v3/ticker/price"
    )
    
    public init(api: API) {
        self.api = api
    }
    
    public func run(completion: @escaping (_ entity: [PriceTicker]?, _ error: BinanceError?) -> Void) {
        guard let url = endpoint.url else {
            completion(nil, nil)
            return
        }
        Request(url: url)
            .method(.get)
            .headers(headers)
            .timeout(5.0)
            .run { data, error in
                guard error == nil, let data = data else {
                    completion(nil, nil)
                    return
                }
                if let entity = try? JSONDecoder().decode(BinanceError.self, from: data) {
                    completion(nil, entity)
                    return
                }
                if let entity = try? JSONDecoder().decode([PriceTicker].self, from: data) {
                    completion(entity, nil)
                    return
                }
                completion(nil, nil)
        }
    }

    private var headers: [String: String] {
        ["Content-Type": "apaplication/json"]
    }
}
