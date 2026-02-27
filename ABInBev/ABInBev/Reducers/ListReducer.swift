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
            case .deleteSurvey(let indexSet):
                let survey = state.surveys[indexSet.first!]
                survey.uploadClient.deleteOperation(forSurveyId: survey.referenceNumber)
                state.surveys.remove(survey)
                return .none
            case .startLiveUpdates:
                let survey = state.surveys.first
                LiveActivities.create(progress: survey?.imageUploadPercentage ?? 0, surveyId: Int(survey?.referenceNumber ?? "0") ?? 0)
                return .none
            case .stopLiveUpdates:
                LiveActivities.stop()
                return .none
            case .loadFromDisk:
                return .run { send in
                    await send(.loadResponse(Result { try persistence.load([SurveyState].self) as! [SurveyState] }))
                }
            case let .loadResponse(.success(loaded)):
                state.surveys = IdentifiedArray(uniqueElements: loaded)
                return .none
            case let .loadResponse(.failure(error)):
                print(error.localizedDescription)
                return .none
            case .moveSurvey(let indexSet, let newIndex):
                guard let sourceIndex = indexSet.first else { return .none }
                let survey = state.surveys[sourceIndex]
                if newIndex < sourceIndex {
                    // move item up
                    survey.uploadClient.changePriorityOfSurvey(surveyId: survey.referenceNumber, priority: .high)
                } else if newIndex > sourceIndex {
                    // move item down
                    survey.uploadClient.changePriorityOfSurvey(surveyId: survey.referenceNumber, priority: .low)
                }
                state.surveys.move(fromOffsets: indexSet, toOffset: newIndex)
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
