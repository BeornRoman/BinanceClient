//
//  Endpoint.swift
//  BinanceAPI
//
//  Created by Overcout on 27.11.2021.
//

import Foundation

struct Endpoint {

    var scheme: String

    var host: String
    
    var port: Int
    
    var path: String

    var queryParams: [(String, String)] = []

    init(scheme: @autoclosure () -> String = "https",
         host: @autoclosure () -> String,
         port: @autoclosure () -> Int = 443,
         path: @autoclosure () -> String = "",
         queryParams: @autoclosure () -> [(String, String)] = []) {
        self.scheme = scheme()
        self.host = host()
        self.port = port()
        self.path = path()
        self.queryParams = queryParams()
    }
    
    var url: URL? {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.port = [80, 443].contains(port) ? nil : port
        components.path = path
        let items = queryParams.compactMap { URLQueryItem(name: $0.0, value: $0.1) }
        components.queryItems = items.isEmpty ? nil : items
        return components.url
    }
}
