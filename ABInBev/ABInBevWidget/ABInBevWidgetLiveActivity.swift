//
//  ABInBevWidgetLiveActivity.swift
//  ABInBevWidget
//
//  Created by Henry Heleine on 1/6/26.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct ABInBevWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct ABInBevWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: ABInBevWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension ABInBevWidgetAttributes {
    fileprivate static var preview: ABInBevWidgetAttributes {
        ABInBevWidgetAttributes(name: "World")
    }
}

extension ABInBevWidgetAttributes.ContentState {
    fileprivate static var smiley: ABInBevWidgetAttributes.ContentState {
        ABInBevWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: ABInBevWidgetAttributes.ContentState {
         ABInBevWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: ABInBevWidgetAttributes.preview) {
   ABInBevWidgetLiveActivity()
} contentStates: {
    ABInBevWidgetAttributes.ContentState.smiley
    ABInBevWidgetAttributes.ContentState.starEyes
}
