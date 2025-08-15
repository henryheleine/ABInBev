//
//  SurveyReducer.swift
//  ABInBev
//
//  Created by Henry Heleine on 8/12/25.
//

import BackgroundTasks
import Combine
import ComposableArchitecture
import Foundation

struct SurveyReducer: Reducer {
    typealias State = SurveyState
    typealias Action = SurveyAction
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .background:
                state.uploadClient.operationQueue.cancelAllOperations()
                let request = BGProcessingTaskRequest(
                    identifier: "com.henryheleine.ABInBev.backgroundTask"
                )
                request.requiresNetworkConnectivity = true
                request.requiresExternalPower = false
                request.earliestBeginDate = Date().addingTimeInterval(10)
                try? BGTaskScheduler.shared.submit(request)
                return .none
            case .complete:
                state.surveyMode = .complete
                return .none
            case .updateProgress(let progress):
                state.imageUploadPercentage = progress
                return .none
            case .upload:
                state.surveyMode = .uploading
                state.imageUploadPercentage = 0
                return .publisher {
                    state.uploadClient
                        .publisher(surveyId: state.referenceNumber)
                        .map(SurveyAction.updateProgress)
                        .append(Just(.complete))
                        .eraseToAnyPublisher()
                }
            }
        }
    }
}
