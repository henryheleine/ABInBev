//
//  BackgroundUploadOperation.swift
//  ABInBev
//
//  Created by Henry Heleine on 8/14/25.
//

import Foundation

class BackgroundUploadOperation: UploadOperation, @unchecked Sendable {
    override func main() {
        isExecuting = true
        Task {
            let config = URLSessionConfiguration.background(withIdentifier: "com.henryheleine.ABInBev.backgroundTask")
            let session = URLSession(configuration: config)
            let request = URLRequest.postUpload()
            session.downloadTask(with: request) { url, response, error in
                if error == nil {
                    NSLog("DEBUG: ***** background task complete for response \(response ?? URLResponse())")
                    NSLog("DEBUG: ***** requested run date = \(self.date)")
                    NSLog("DEBUG: ***** now = \(Date())")
                } else {
                    NSLog("DEBUG: ***** \(error?.localizedDescription ?? "noError")")
                    if self.attempts < self.maxRetries {
                        self.attempts += 1
                        self.timeoutInterval = self.timeoutInterval * 2
                        sleep(10)
                        self.main()
                    } else {
                        self.finish()
                    }
                }
            }.resume()
        }
    }
}
