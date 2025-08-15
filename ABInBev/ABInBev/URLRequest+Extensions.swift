//
//  URLRequest+Extensions.swift
//  ABInBev
//
//  Created by Henry Heleine on 8/14/25.
//

import Foundation

extension URLRequest {
    
    static func postUpload(timeoutInterval: TimeInterval = 60) -> URLRequest {
        var request = URLRequest(url: URL(string: "https://render-4ezx.onrender.com/upload")!, timeoutInterval: timeoutInterval)
        request.httpMethod = "POST"
        return request
    }
}
