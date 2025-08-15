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
    var body: some Scene {
        WindowGroup {
            HomeListView(store: Store(initialState: ListReducer.State(), reducer: {
                ListReducer()
            }))
        }
        .backgroundTask(.appRefresh("com.henryheleine.ABInBev.backgroundTask")) {
            let config = URLSessionConfiguration.background(withIdentifier: "com.henryheleine.ABInBev.backgroundTask")
            let session = URLSession(configuration: config)
            let request = URLRequest.postUpload()
            session.downloadTask(with: request) { url, response, error in
                NSLog("HH DEBUG ***** response = \(response ?? URLResponse()) *****")
            }.resume()
        }
    }
}
