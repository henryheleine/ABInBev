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
            // TODO: save completed operations to disk/file persist
            // TODO: get each operation in the queue and move them onto background operation
            let uploadClient = UploadClient.shared
            let backgroundOperation = BackgroundUploadOperation()
            uploadClient.operationQueue.addOperation(backgroundOperation)
        }
    }
}
