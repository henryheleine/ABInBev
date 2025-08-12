//
//  Survey.swift
//  ABInBev
//
//  Created by Henry Heleine on 8/11/25.
//

import Foundation

struct Survey: Equatable, Hashable {
    var id: UUID
    var imageUploadPercentage: Int
    var notes: String
    var referenceNumber: String
    
    init(id: UUID = UUID(), imageUploadPercentage: Int = 0, notes: String = "", referenceNumber: String = "\(Int.random(in: 0...100))") {
        self.id = id
        self.imageUploadPercentage = imageUploadPercentage
        self.notes = notes
        self.referenceNumber = referenceNumber
    }
}
