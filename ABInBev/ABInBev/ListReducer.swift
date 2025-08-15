//
//  ListReducer.swift
//  ABInBev
//
//  Created by Henry Heleine on 8/11/25.
//

import ComposableArchitecture
import Foundation

struct ListReducer: Reducer {
    @Dependency(\.filePersistence) var persistence
    typealias State = ListState
    typealias Action = ListAction
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .addSurvey:
                state.surveys.append(SurveyState())
                return .send(.saveToDisk)
            case .loadFromDisk:
                if persistence.fileExists() {
                    return .run { send in
                        await send(.loadResponse(Result { try persistence.load([SurveyState].self) as! [SurveyState] }))
                    }
                } else {
                    return .none
                }
            case let .loadResponse(.success(loaded)):
                state.surveys = IdentifiedArray(uniqueElements: loaded)
                return .none
            case let .loadResponse(.failure(error)):
                print(error.localizedDescription)
                return .none
            case .saveToDisk:
                let surveys = state.surveys
                return .run { send in
                    await send(.saveCompleted(Result {
                        try persistence.save(surveys)
                        return true
                    }))
                }
            case let .saveCompleted(.failure(error)):
                print(error.localizedDescription)
                return .none
            case .saveCompleted(.success):
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
