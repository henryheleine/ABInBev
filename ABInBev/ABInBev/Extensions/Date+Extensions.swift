//
//  Date+Extensions.swift
//  ABInBev
//
//  Created by Henry Heleine on 8/16/25.
//

import Foundation

extension Date {
    
    func format() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: self)
    }
}
