//
//  ListAction.swift
//  ABInBev
//
//  Created by Henry Heleine on 8/12/25.
//

import ComposableArchitecture
import Foundation

// @CasePathable
enum ListAction: Equatable {
    case addSurvey
    case survey(id: UUID, action: SurveyAction)
}
