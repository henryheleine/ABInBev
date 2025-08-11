//
//  ListView.swift
//  ABInBev
//
//  Created by Henry Heleine on 8/11/25.
//

import ComposableArchitecture
import SwiftUI

struct ListView: View {
    var store: StoreOf<ListReducer>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            NavigationView {
                VStack {
                    List {
                        ForEach(viewStore.listings, id: \.self) {
                            Text("Survey = \($0)")
                        }
                    }
                    Button("Add Survey") {
                        viewStore.send(.addSurvey)
                    }
                    .padding()
                }
                .navigationTitle("Surveys")
            }
        }
    }
}

#Preview {
    ListView(store: Store(initialState: ListReducer.State(), reducer: {
        ListReducer()
    }))
}
