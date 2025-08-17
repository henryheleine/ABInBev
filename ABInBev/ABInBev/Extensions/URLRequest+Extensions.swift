//
//  URLRequest+Extensions.swift
//  ABInBev
//
//  Created by Henry Heleine on 8/14/25.
//

import Foundation

extension URLRequest {
    
    static func mock(forSurveyId surveyId: String, timeoutInterval: TimeInterval = UploadClient.shared.foregroundTimeout) -> URLRequest {
        var request = URLRequest(url: URL(string: "https://render-4ezx.onrender.com/upload/\(surveyId)")!, timeoutInterval: timeoutInterval)
        request.httpMethod = "POST"
        return request
    }
}
