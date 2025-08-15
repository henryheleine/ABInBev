//
//  HomeListView.swift
//  ABInBev
//
//  Created by Henry Heleine on 8/11/25.
//

import BackgroundTasks
import ComposableArchitecture
import SwiftUI

struct HomeListView: View {
    var store: StoreOf<ListReducer>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            NavigationView {
                VStack {
                    List {
                        ForEachStore(
                            self.store.scope(
                                state: \.surveys,
                                action: ListAction.survey(id:action:)
                            ),
                            content: SurveyView.init
                        )
                    }
                    Button("Add Survey") {
                        viewStore.send(.addSurvey)
                    }
                    .padding()
                }
                .onAppear {
                    URLSession.shared.dataTask(with: URLRequest(url: URL(string: "https://render-4ezx.onrender.com/")!)) // spin up free service node js app
                    viewStore.send(.loadFromDisk)
                }
                .navigationTitle("Surveys")
            }
        }
    }
}

#Preview {
    HomeListView(store: Store(initialState: ListReducer.State(), reducer: {
        ListReducer()
    }))
}
