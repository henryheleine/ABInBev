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
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some Scene {
        WindowGroup {
            HomeListView(store: Store(initialState: ListReducer.State(), reducer: {
                ListReducer()
            }))
        }
        .onChange(of: scenePhase, { oldValue, newValue in
            if case .background = newValue {
                // submitBackgroundTaskRequest()
                // move download queue/tasks to background task
            }
        })
        .backgroundTask(.appRefresh("com.henryheleine.ABInBev.backgroundTask")) {
            let config = URLSessionConfiguration.background(withIdentifier: "com.henryheleine.ABInBev.backgroundTask")
            let session = URLSession(configuration: config)
            let request = URLRequest(url: URL(string: "https://render-4ezx.onrender.com/background")!)
            session.downloadTask(with: request) { url, response, error in
                // print(url)
                // print(response)
                // print(error)
            }.resume()
        }
    }
    
    func submitBackgroundTaskRequest() {
        let request = BGProcessingTaskRequest(
            identifier: "com.henryheleine.ABInBev.backgroundTask"
        )
        request.requiresNetworkConnectivity = true
        request.requiresExternalPower = false
        try? BGTaskScheduler.shared.submit(request)
    }
}
