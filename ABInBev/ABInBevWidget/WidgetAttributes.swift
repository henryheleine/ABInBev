//
//  WidgetAttributes.swift
//  ABInBev
//
//  Created by Henry Heleine on 1/6/26.
//

import ActivityKit

struct WidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}
