//
//  ABInBevWidgetLiveActivity.swift
//  ABInBevWidget
//
//  Created by Henry Heleine on 1/6/26.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct ABInBevWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: WidgetAttributes.self) { context in
            VStack {
                Text("Uploading... \(context.state.progress.percent())")
                ProgressViewCircular(progress: context.state.progress)
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    Text("Uploading...")
                        .padding()
                }
                DynamicIslandExpandedRegion(.trailing) {
                    ProgressViewCircular(progress: context.state.progress)
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Progress \(context.state.progress.percent())")
                }
            } compactLeading: {
                Text("⬆️")
            } compactTrailing: {
                ProgressViewCircular(progress: context.state.progress)
            } minimal: {
                Text("P \(context.state.progress)")
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension WidgetAttributes {
    fileprivate static var preview: WidgetAttributes {
        WidgetAttributes(name: "World")
    }
}

extension WidgetAttributes.ContentState {
    fileprivate static var smiley: WidgetAttributes.ContentState {
        WidgetAttributes.ContentState(progress: 0.5)
     }
     
     fileprivate static var starEyes: WidgetAttributes.ContentState {
         WidgetAttributes.ContentState(progress: 0.5)
     }
}

#Preview("Notification", as: .content, using: WidgetAttributes.preview) {
   ABInBevWidgetLiveActivity()
} contentStates: {
    WidgetAttributes.ContentState.smiley
    WidgetAttributes.ContentState.starEyes
}
