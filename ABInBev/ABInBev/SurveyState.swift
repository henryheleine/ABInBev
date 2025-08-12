//
//  SurveyState.swift
//  ABInBev
//
//  Created by Henry Heleine on 8/12/25.
//

import Foundation

struct SurveyState: Equatable, Identifiable {
    let id: UUID
    var imageUploadPercentage: Int
    var notes: String
    var referenceNumber: String
    var surveyMode: SurveyMode
}
