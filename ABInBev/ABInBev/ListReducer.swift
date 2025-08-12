//
//  ListReducer.swift
//  ABInBev
//
//  Created by Henry Heleine on 8/11/25.
//

import ComposableArchitecture
import Foundation

struct ListReducer: Reducer {
    typealias State = ListState
    typealias Action = ListAction
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .addSurvey:
                state.surveys.append(.init(id: UUID(), imageUploadPercentage: 0, notes: "...", referenceNumber: "\(Int.random(in: 0...100))", surveyMode: .paused))
                return .none
            case .survey:
                return .none
            }
        }
        .forEach(\.surveys, action: /ListAction.survey(id:action:)) {
            SurveyReducer()
        }
    }
}
