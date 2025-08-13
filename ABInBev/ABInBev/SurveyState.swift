//
//  SurveyState.swift
//  ABInBev
//
//  Created by Henry Heleine on 8/12/25.
//

import Combine
import Foundation

struct SurveyState: Equatable, Identifiable {
    let id: UUID
    var imageUploadPercentage: Double
    var notes: String
    var referenceNumber: String
    var serverReponse: String
    var surveyMode: SurveyMode
}
