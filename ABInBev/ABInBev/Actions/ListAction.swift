//
//  ListAction.swift
//  ABInBev
//
//  Created by Henry Heleine on 8/12/25.
//

import Foundation

enum ListAction {
    case addSurvey, loadFromDisk, saveToDisk
    case loadResponse(Result<[SurveyState], Error>)
    case moveSurvey(IndexSet, Int)
    case saveCompleted(Result<Bool, Error>)
    case survey(id: UUID, action: SurveyAction)
}
