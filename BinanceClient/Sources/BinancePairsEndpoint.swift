//
//  BinancePairsEndpoint.swift
//  BinanceAPI
//
//  Created by Overcout on 05.12.2021.
//

import Foundation
import CryptoKit

// MARK: - BinanceCoin
struct BinanceProductsData: Codable {
    
    let code: String
    let message: String?
    let messageDetail: String?
    let data: [BinancePair]
    let success: Bool
}

public struct BinancePair: Codable {

    public let price: String
    public let base: String
    public let quote: String
    public let string: String
    
    enum CodingKeys: String, CodingKey {
        case price = "c"
        case base = "b"
        case quote = "q"
        case string = "s"
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        price = try values.decode(String.self, forKey: .price)
        base = try values.decode(String.self, forKey: .base)
        quote = try values.decode(String.self, forKey: .quote)
        string = try values.decode(String.self, forKey: .string)
    }
}

public struct BinancePairsEndpoint: EndpointProtocol {
    
    let api: API

    var endpoint = Endpoint(
        host: "binance.me",
        path: "/bapi/asset/v2/public/asset-service/product/get-products"
    )
    
    public init(api: API) {
        self.api = api
    }
    
    public func run(completion: @escaping (_ entity: [BinancePair]?, _ error: BinanceError?) -> Void) {
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
                if let entity = try? JSONDecoder().decode(BinanceProductsData.self, from: data) {
                    completion(entity.data, nil)
                    return
                }
                completion(nil, nil)
        }
    }

    private var headers: [String: String] {
        ["Content-Type": "apaplication/json"]
    }
}
