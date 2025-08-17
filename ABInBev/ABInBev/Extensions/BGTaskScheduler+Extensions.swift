//
//  BGTaskScheduler+Extensions.swift
//  ABInBev
//
//  Created by Henry Heleine on 8/15/25.
//

import BackgroundTasks
import Foundation

extension BGTaskScheduler {
    
    public static func schedule() {
        let request = BGProcessingTaskRequest(
            identifier: "com.henryheleine.ABInBev.backgroundTask"
        )
        request.requiresNetworkConnectivity = true
        request.requiresExternalPower = false
        try? BGTaskScheduler.shared.submit(request)
    }
}
