//
//  PriceConverter.swift
//  BinanceAPI
//
//  Created by Overcout on 28.11.2021.
//

import Foundation

struct Product: Equatable {

    let base: String
    
    let quote: String
    
    let price: Double
    
    var viceVersa: Product {
        return Product(base: quote, quote: base, price: 1 / price)
    }
}

final class PriceConverter {

    let products: [Product] = [
        Product(base: "MINA", quote: "USDT", price: Double("8")!),
        Product(base: "ETH", quote: "USDT", price: Double("8")!),
        Product(base: "BTC", quote: "ETH", price: Double("8")!),
        Product(base: "4", quote: "5", price: Double("8")!),
        Product(base: "5", quote: "6", price: Double("8")!),
    ]
    
    func getPrice(of base: String, by quote: String) {
        if let particular = findParticular(base: base, quote: quote) {
            print(particular)
            return
        }
        
    }
    
    // MINA - BTC
    func findParticular(base: String, quote: String) -> Product? {
        products.first { $0.base == base && $0.quote == quote }
    }
    
    // USDT - BTC
    func findAll(chain: [Product], base: String, quote: String) -> [Product]? {
        var chain = chain
        if let first = findParticular(base: base, quote: quote) {
            chain.append(first)
            return chain
        }

        let baseProducts = products.filter { $0.base == base }
        guard !baseProducts.isEmpty else { return nil }
        
        for product in baseProducts {
            if let first = findParticular(base: product.quote, quote: quote) {
                chain.append(contentsOf: [product, first])
                return chain
            }
            if var all = findAll(chain: chain, base: product.quote, quote: quote) {
                all.insert(product, at: 0)
                return all
            }
        }
        
        return nil
    }
}
