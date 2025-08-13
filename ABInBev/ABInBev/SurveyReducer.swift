//
//  SurveyReducer.swift
//  ABInBev
//
//  Created by Henry Heleine on 8/12/25.
//

import Combine
import ComposableArchitecture
import Foundation

struct SurveyReducer: Reducer {
    @Dependency(\.continuousClock) var clock
    @Dependency(\.uploadClient) var uploadClient
    typealias State = SurveyState
    typealias Action = SurveyAction
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .complete:
                print("complete")
                state.surveyMode = .complete
                return .none
            case .pause:
                state.surveyMode = .paused
                return .cancel(id: state.id)
            case .resume:
                print("uploading #\(state.referenceNumber)")
                state.surveyMode = .uploading
                return .none
            case .updateProgress(let progress):
                state.imageUploadPercentage = progress
                return .none
            case .upload:
                state.imageUploadPercentage = 0
                return .publisher {
                    uploadClient
                        .upload()
                        .map(SurveyAction.updateProgress)
                        .append(Just(.complete))
                        .eraseToAnyPublisher()
                }
            }
        }
    }
}
