//
//  Double+Extensions.swift
//  ABInBev
//
//  Created by Henry Heleine on 1/6/26.
//

import Foundation

extension Double {
    
    func twoDecimals() -> String {
        return String(format: "%.2f", self)
    }
    
    func percent() -> String {
        return String(format: "%.2f", self*100) + "%"
    }
}
