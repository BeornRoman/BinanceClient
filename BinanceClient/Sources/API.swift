//
//  API.swift
//  BinanceAPI
//
//  Created by Overcout on 27.11.2021.
//

import Foundation

public struct API {

    public let secret: String

    public let api: String
    
    public init(secret: String, api: String) {
        self.secret = secret
        self.api = api
    }
}
