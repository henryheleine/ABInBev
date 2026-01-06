//
//  AppIntent.swift
//  ABInBevWidget
//
//  Created by Henry Heleine on 1/6/26.
//

import WidgetKit
import AppIntents

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource { "Configuration" }
    static var description: IntentDescription { "This is an example widget." }

    @Parameter(title: "Progress", default: 0.5)
    var progress: Double
}
