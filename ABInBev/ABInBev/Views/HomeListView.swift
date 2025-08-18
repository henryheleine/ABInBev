//
//  HomeListView.swift
//  ABInBev
//
//  Created by Henry Heleine on 8/11/25.
//

import ComposableArchitecture
import SwiftUI

struct HomeListView: View {
    @Environment(\.scenePhase) private var scenePhase
    let store: StoreOf<ListReducer>
    
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
                        .onDelete { indexSet in
                            viewStore.send((.deleteSurvey(indexSet)))
                        }
                        .onMove { indexSet, newIndex in
                            viewStore.send(.moveSurvey(indexSet, newIndex))
                        }
                    }
                    Button("Add Survey") {
                        viewStore.send(.addSurvey)
                    }
                    .padding()
                }
                .onChange(of: scenePhase, { oldValue, newValue in
                    // app foregrounding
                    if oldValue == .inactive && newValue == .active {
                        viewStore.send(.loadFromDisk)
                    }
                })
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
