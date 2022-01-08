//
//  DateExtensions.swift
//  BinanceAPI
//
//  Created by Overcout on 27.11.2021.
//

import Foundation

extension Date {
    
    static var timeStampInt64: Int64 {
        return Int64(Date().timeIntervalSince1970 * 1000)
    }
    
    static var timeStampString: String {
        return String(timeStampInt64)
    }
}
