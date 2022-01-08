//
//  Request.swift
//  BinanceAPI
//
//  Created by Overcout on 27.11.2021.
//

import Foundation

protocol RequestProtocol {

    var request: URLRequest { get }
}

struct Request: RequestProtocol {

    var request: URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = body
        request.timeoutInterval = timeout
        headers.forEach {
            request.setValue($0.value, forHTTPHeaderField: $0.key)
        }
        return request
    }

    let url: URL
    
    var body: Data?

    var headers: [String: String] = [:]

    var method: Method = .get

    var timeout: TimeInterval = 15
    
    init(url: URL) {
        self.url = url
    }
}

extension Request {

    enum Method: String {

        case get = "GET"
        case post = "POST"
        case put = "PUT"
    }
}

extension Request {

    func headers(_ headers: [String: String]) -> Request {
        var request = self
        request.headers = headers
        return request
    }

    func body<T>(_ value: T?) throws -> Request where T: Encodable {
        guard let value = value else { return self }
        var request = self
        request.body = try JSONEncoder().encode(value)
        return request
    }
    
    func method(_ method: Request.Method) -> Request {
        var request = self
        request.method = method
        return request
    }
    
    func timeout(_ value: TimeInterval) -> Request {
        var request = self
        request.timeout = value
        return request
    }
    
    func run(_ completion: ((_ response: Data?, _ error: Error?) -> Void)?) {
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil, let data = data else {
                completion?(nil, NSError())
                return
            }
            completion?(data, nil)
        }.resume()
    }
}
