//
//  URLRequest+Extensions.swift
//  ABInBev
//
//  Created by Henry Heleine on 8/14/25.
//

import Foundation

extension URLRequest {
    static let url = "https://render-4ezx.onrender.com/upload"
    
    static func postUploadStream(timeoutInterval: TimeInterval = 60) -> URLRequest {
        var request = URLRequest(url: URL(string: url)!, timeoutInterval: timeoutInterval)
        request.addValue("chunked", forHTTPHeaderField: "Transfer-Encoding")
        request.httpMethod = "POST"
        return request
    }
}
