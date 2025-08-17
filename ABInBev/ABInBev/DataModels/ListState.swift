//
//  ListState.swift
//  ABInBev
//
//  Created by Henry Heleine on 8/12/25.
//

import ComposableArchitecture
import Foundation

struct ListState: Equatable {
    var surveys: IdentifiedArrayOf<SurveyState> = []
}
