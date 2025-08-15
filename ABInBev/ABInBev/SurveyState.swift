//
//  SurveyState.swift
//  ABInBev
//
//  Created by Henry Heleine on 8/12/25.
//

import Combine
import Foundation

struct SurveyState: Codable, Equatable, Identifiable {
    var id: UUID
    var imageUploadPercentage: Double
    var notes: String
    var referenceNumber: String
    var session = URLSession.shared
    var surveyMode: SurveyMode
    var uploadClient: UploadClient
    
    init(id: UUID = UUID(),
         imageUploadPercentage: Double = 0,
         notes: String = "...",
         referenceNumber: String = "\(Int.random(in: 0...100))",
         surveyMode: SurveyMode = .paused,
         uploadClient: UploadClient = UploadClient.shared) {
        self.id = id
        self.imageUploadPercentage = imageUploadPercentage
        self.notes = notes
        self.referenceNumber = referenceNumber
        self.surveyMode = surveyMode
        self.uploadClient = uploadClient
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        imageUploadPercentage = try container.decode(Double.self, forKey: .imageUploadPercentage)
        notes = try container.decode(String.self, forKey: .notes)
        referenceNumber = try container.decode(String.self, forKey: .referenceNumber)
        session = URLSession.shared
        surveyMode = try container.decode(SurveyMode.self, forKey: .surveyMode)
        uploadClient = UploadClient()
    }
        
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(imageUploadPercentage, forKey: .imageUploadPercentage)
        try container.encode(notes, forKey: .notes)
        try container.encode(referenceNumber, forKey: .referenceNumber)
        try container.encode(surveyMode, forKey: .surveyMode)
    }
    
    enum CodingKeys: String, CodingKey {
        case id, imageUploadPercentage, notes, referenceNumber, surveyMode
    }
}
