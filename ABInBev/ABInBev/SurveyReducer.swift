//
//  SurveyReducer.swift
//  ABInBev
//
//  Created by Henry Heleine on 8/12/25.
//

import ComposableArchitecture
import Foundation

struct SurveyReducer: Reducer {
    @Dependency(\.continuousClock) var clock
    typealias State = SurveyState
    typealias Action = SurveyAction
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .pause:
                state.surveyMode = .paused
                return .cancel(id: state.id)
            case .tick:
                if state.imageUploadPercentage < 100 {
                    state.imageUploadPercentage += 1
                    return .none
                } else {
                    state.surveyMode = .complete
                    return .cancel(id: state.id)
                }
            case .resume, .upload:
                state.surveyMode = .uploading
                return .run { send in
                    while true {
                        try await clock.sleep(for: .seconds(0.1))
                        await send(.tick)
                    }
                }
                .cancellable(id: state.id, cancelInFlight: true)
            }
        }
    }
}
