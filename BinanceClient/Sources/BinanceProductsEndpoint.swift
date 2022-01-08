//
//  BinanceProductsEndpoint.swift
//  BinanceAPI
//
//  Created by Overcout on 27.11.2021.
//

import Foundation
import CryptoKit

// MARK: - BinanceCoin
public struct BinanceProduct: Codable {
    
    let code: String
    let message: String?
    let messageDetail: String?
    let data: [Data]
    let success: Bool
}

extension BinanceProduct {

    public struct Data: Codable {

        let s, st, b, q, ba, qa, i, ts, an, qn, o, h, l, c, pm, pn: String
        let tags: [String]
        let etf: Bool
    }
}


public struct BinanceProductsEndpoint: EndpointProtocol {
    
    let api: API

    var endpoint = Endpoint(
        host: "binance.me",
        path: "/bapi/asset/v2/public/asset-service/product/get-products"
    )
    
    public init(api: API) {
        self.api = api
    }
    
    public func run(completion: @escaping (_ entity: BinanceProduct?, _ error: BinanceError?) -> Void) {
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
                if let entity = try? JSONDecoder().decode(BinanceProduct.self, from: data) {
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
