//
//  LiveActivities.swift
//  ABInBev
//
//  Created by Henry Heleine on 1/7/26.
//

import ActivityKit
import Foundation

struct LiveActivities {
    
    public static func create(progress: Double, surveyId: Int) {
        let attributes = WidgetAttributes(name: "MyFirstLiveActivity")
        let initialContentState = WidgetAttributes.ContentState(progress: progress, surveyId: surveyId)
        let content = ActivityContent(state: initialContentState, staleDate: nil, relevanceScore: 1.0)
        do {
            let _ = try Activity<WidgetAttributes>.request(
                attributes: attributes,
                content: content,
                pushType: nil
            )
        } catch {
            print("Error starting Live Activity: \(error.localizedDescription)")
        }
    }
    
    public static func update(progress: Double, surveyId: Int) {
        Task {
            for activity in Activity<WidgetAttributes>.activities {
                let content = WidgetAttributes.ContentState(progress: progress, surveyId: surveyId)
                await activity.update(using: content)
            }
        }
    }
    
    public static func stop() {
        Task {
            for activity in Activity<WidgetAttributes>.activities {
                await activity.end(activity.content, dismissalPolicy: .immediate)
            }
            print("Live Activities stopped.")
        }
    }
}
