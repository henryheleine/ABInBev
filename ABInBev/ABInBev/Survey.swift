//
//  Survey.swift
//  ABInBev
//
//  Created by Henry Heleine on 8/11/25.
//

import Foundation

struct Survey: Equatable, Hashable {
    var id: UUID
    var title: String
    
    init(id: UUID = UUID(), title: String = "") {
        self.id = id
        self.title = title
    }
}
