//
//  ABInBevApp.swift
//  ABInBev
//
//  Created by Henry Heleine on 8/11/25.
//

import ComposableArchitecture
import SwiftUI

@main
struct ABInBevApp: App {
    var body: some Scene {
        WindowGroup {
            ListView(store: Store(initialState: ListReducer.State(), reducer: {
                ListReducer()
            }))
        }
    }
}
