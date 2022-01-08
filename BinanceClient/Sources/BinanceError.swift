//
//  BinanceError.swift
//  BinanceAPI
//
//  Created by Overcout on 27.11.2021.
//

public struct BinanceError: Codable {

    public let code: Int
    
    public let msg: String
    
    public init(code: Int, msg: String) {
        self.code = code
        self.msg = msg
    }
}
