//
//  ABInBevWidgetBundle.swift
//  ABInBevWidget
//
//  Created by Henry Heleine on 1/6/26.
//

import WidgetKit
import SwiftUI

@main
struct ABInBevWidgetBundle: WidgetBundle {
    var body: some Widget {
        ABInBevWidget()
        ABInBevWidgetControl()
        ABInBevWidgetLiveActivity()
    }
}
