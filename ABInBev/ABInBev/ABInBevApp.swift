//
//  ABInBevApp.swift
//  ABInBev
//
//  Created by Henry Heleine on 8/11/25.
//

import BackgroundTasks
import ComposableArchitecture
import SwiftUI

@main
struct ABInBevApp: App {
    @Dependency(\.filePersistence) var persistence
    
    var body: some Scene {
        WindowGroup {
            HomeListView(store: Store(initialState: ListReducer.State(), reducer: {
                ListReducer()
            }))
        }
        .backgroundTask(.appRefresh("com.henryheleine.ABInBev.backgroundTask")) {
            Task {
                let config = URLSessionConfiguration.backgroundConfig()
                let session = URLSession(configuration: config, delegate: UploadClient.shared, delegateQueue: UploadClient.shared.operationQueue)
                let surveys = try await persistence.load([SurveyState].self) as! [SurveyState]
                surveys.forEach { survey in
                    if survey.surveyMode != .complete {
                        let request = URLRequest.mock(forSurveyId: survey.referenceNumber)
                        session.downloadTask(with: request).resume()
                    }
                }
            }
        }
    }
}
