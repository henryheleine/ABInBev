//
//  URLRequest+Extensions.swift
//  ABInBev
//
//  Created by Henry Heleine on 8/14/25.
//

import Foundation

extension URLRequest {
    static let url = "https://render-4ezx.onrender.com/upload"
    
    static func postUpload(timeoutInterval: TimeInterval = 60) -> URLRequest {
        var request = URLRequest(url: URL(string: url)!, timeoutInterval: timeoutInterval)
        request.httpMethod = "POST"
        return request
    }
    
    static func postStreamUpload() async throws -> URLRequest {
        let request = URLRequest(url: URL(string: url)!)
        let (bytes, _) = try await URLSession.shared.bytes(for: request)
        var iterator = bytes.makeAsyncIterator()
        var data = Data()
        // while isActive, let byte = try await iterator.next() {
        while let byte = try await iterator.next() {
            data.append(byte)
            if UploadClient.isValidJSON(data) {
                if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any], let _ = json["progress"] as? Double {
                    try? await Task.sleep(for: .milliseconds(250))
                    // subject.send(progress)
                }
                data = Data()
            }
        }
        return request
    }
}
