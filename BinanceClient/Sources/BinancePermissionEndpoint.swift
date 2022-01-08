//
//  BinanceAPIPermission.swift
//  BinanceAPI
//
//  Created by Overcout on 27.11.2021.
//

import Foundation
import CryptoKit

public struct BinancePermissionEntity: Codable {

    let ipRestrict: Bool
    let createTime: UInt64
    let enableSpotAndMarginTrading: Bool
    let enableReading: Bool
    let enableWithdrawals: Bool
    let enableInternalTransfer: Bool
    let enableMargin: Bool
    let enableFutures: Bool
    let permitsUniversalTransfer: Bool
    let enableVanillaOptions: Bool
}

public struct BinancePermissionEndpoint: EndpointProtocol {
    
    let api: API

    var endpoint = Endpoint(
        host: "api.binance.com",
        path: "/sapi/v1/account/apiRestrictions"
    )
    
    public init(api: API) {
        self.api = api
    }
    
    public func run(completion: @escaping (_ entity: BinancePermissionEntity?, _ error: BinanceError?) -> Void) {
        var endpoint = endpoint
        guard let queryParams = queryParams else {
            completion(nil, nil)
            return
        }
        endpoint.queryParams += queryParams
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
                if let entity = try? JSONDecoder().decode(BinancePermissionEntity.self, from: data) {
                    completion(entity, nil)
                    return
                }
                completion(nil, nil)
        }
    }
    
    private var queryParams: [(String, String)]? {
        let timestamp = Date.timeStampString
        print(timestamp)
        let queryString = "timestamp=\(timestamp)"
        let secret = api.secret
        guard let data = secret.data(using: .utf8), let code = queryString.data(using: .utf8) else { return nil }
        let key = SymmetricKey(data: data)
        let hmac = HMAC<SHA256>.authenticationCode(for: code, using: key)
        let signature = Data(hmac).map { String(format: "%02hhx", $0) }.joined()
        print(signature)
        return [("timestamp", timestamp), ("signature", signature)]
    }
    
    private var headers: [String: String] {
        ["Content-Type": "apaplication/json", "X-MBX-APIKEY": api.api]
    }
}
