//
//  ListAction.swift
//  ABInBev
//
//  Created by Henry Heleine on 8/12/25.
//

import Foundation

enum ListAction {
    case addSurvey, loadFromDisk, startLiveUpdates, saveToDisk, stopLiveUpdates
    case deleteSurvey(IndexSet)
    case loadResponse(Result<[SurveyState], Error>)
    case moveSurvey(IndexSet, Int)
    case saveCompleted(Result<Bool, Error>)
    case survey(id: UUID, action: SurveyAction)
}
