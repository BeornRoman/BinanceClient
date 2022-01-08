//
//  BinanceAllCoinsEndpoint.swift
//  BinanceAPI
//
//  Created by Overcout on 27.11.2021.
//

import Foundation
import CryptoKit

// MARK: - BinanceCoin
public struct BinanceCoin: Codable {

    public let coin: String
    public let depositAllEnable: Bool
    public let free, freeze, ipoable, ipoing: String
    public let isLegalMoney: Bool
    public let networkList: [Network]
    public let locked, name, storage: String
    public let trading, withdrawAllEnable: Bool
    public let withdrawing: String
}

extension BinanceCoin {

    public struct Network: Codable {

        public let addressRegex, coin, depositDesc: String
        public let depositEnable, isDefault: Bool
        public let memoRegex: String
        public let minConfirm: Int
        public let name, network: String
        public let resetAddressStatus: Bool
        public let specialTips: String?
        public let unLockConfirm: Int
        public let withdrawDesc: String
        public let withdrawEnable: Bool
        public let withdrawFee, withdrawIntegerMultiple, withdrawMax, withdrawMin: String
        public let sameAddress: Bool
    }
}


public struct BinanceAllCoinsEndpoint: EndpointProtocol {
    
    let api: API

    var endpoint = Endpoint(
        host: "api.binance.com",
        path: "/sapi/v1/capital/config/getall"
    )
    
    public init(api: API) {
        self.api = api
    }
    
    public func run(completion: @escaping (_ entity: [BinanceCoin]?, _ error: BinanceError?) -> Void) {
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
                if let entity = try? JSONDecoder().decode([BinanceCoin].self, from: data) {
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
