//
//  WidgetAttributes.swift
//  ABInBev
//
//  Created by Henry Heleine on 1/6/26.
//

import ActivityKit

struct WidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var progress: Double
        var surveyId: Int
    }

    var name: String
}
