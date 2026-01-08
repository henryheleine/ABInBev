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
                ProgressView("Survey #\(context.state.surveyId) Progress", value: context.state.progress, total: 1)
            }
            .padding()

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
    fileprivate static var mock: WidgetAttributes.ContentState {
        WidgetAttributes.ContentState(progress: 0, surveyId: 0)
     }
}

#Preview("Notification", as: .content, using: WidgetAttributes.preview) {
   ABInBevWidgetLiveActivity()
} contentStates: {
    WidgetAttributes.ContentState.mock
}
