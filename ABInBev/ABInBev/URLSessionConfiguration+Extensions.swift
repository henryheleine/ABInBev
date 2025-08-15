//
//  URLSessionConfiguration+Extensions.swift
//  ABInBev
//
//  Created by Henry Heleine on 8/15/25.
//

import Foundation

extension URLSessionConfiguration {
    
    static func backgroundConfig() -> URLSessionConfiguration {
        let config = URLSessionConfiguration.background(withIdentifier: "com.henryheleine.ABInBev.backgroundTask")
        config.timeoutIntervalForRequest = UploadClient.shared.backgroundTimeout
        config.timeoutIntervalForResource = UploadClient.shared.backgroundTimeout
        config.waitsForConnectivity = true // don't fail immediately and wait for possible connection
        config.httpMaximumConnectionsPerHost = UploadClient.shared.operationQueue.maxConcurrentOperationCount
        return config
    }
}
