//
//  URLSessionConfiguration+Extensions.swift
//  ABInBev
//
//  Created by Henry Heleine on 8/15/25.
//

import Foundation

extension URLSessionConfiguration {
    
    static func foregroundConfig() -> URLSessionConfiguration {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 60
        config.timeoutIntervalForResource = 60
        config.waitsForConnectivity = true
        config.httpMaximumConnectionsPerHost = UploadClient.shared.operationQueue.maxConcurrentOperationCount
        return config
    }
    
    static func backgroundConfig() -> URLSessionConfiguration {
        let config = URLSessionConfiguration.background(withIdentifier: "com.henryheleine.ABInBev.backgroundTask")
        config.timeoutIntervalForRequest = UploadClient.shared.backgroundTimeout
        config.timeoutIntervalForResource = UploadClient.shared.backgroundTimeout
        config.waitsForConnectivity = true // don't fail immediately and wait re-connect
        config.httpMaximumConnectionsPerHost = UploadClient.shared.operationQueue.maxConcurrentOperationCount
        return config
    }
}
