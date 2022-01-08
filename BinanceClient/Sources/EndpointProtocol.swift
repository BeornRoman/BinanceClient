//
//  EndpointProtocol.swift
//  BinanceAPI
//
//  Created by Overcout on 27.11.2021.
//

public protocol EndpointProtocol {
    
    associatedtype Enitity

    init(api: API)
    
    func run(completion: @escaping (_ entity: Enitity?, _ error: BinanceError?) -> Void)
}
