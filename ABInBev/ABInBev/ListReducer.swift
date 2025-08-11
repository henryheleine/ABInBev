//
//  ListReducer.swift
//  ABInBev
//
//  Created by Henry Heleine on 8/11/25.
//

import ComposableArchitecture
import Foundation

struct ListReducer: Reducer {
    
    struct State: Equatable {
        var listings: [Survey] = []
    }
    
    enum Action {
        case addSurvey
        case survery(id: UUID)
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .addSurvey:
                state.listings.append(Survey(title: "\(Date.now)"))
                return .none
            case .survery(id: _):
                return .none
            }
        }
    }
}
