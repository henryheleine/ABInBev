//
//  UploadClient.swift
//  ABInBev
//
//  Created by Henry Heleine on 8/12/25.
//

import Combine
import ComposableArchitecture
import Foundation

class UploadClient: NSObject, URLSessionDownloadDelegate {
    public static let shared = UploadClient()
    let backgroundTimeout = Double(24 * 60 * 60) // 24 hours
    var id: UUID
    var operationQueue: OperationQueue
    
    init(id: UUID = UUID(), operationQueue: OperationQueue = OperationQueue()) {
        self.id = id
        self.operationQueue = operationQueue
        self.operationQueue.name = "com.henryheleine.ABInBev.UploadClientOperationQueue"
        self.operationQueue.maxConcurrentOperationCount = 2
    }
    
    func publisher(surveyId: String) -> AnyPublisher<Double, Never> {
        let subject = PassthroughSubject<Double, Never>()
        let uploadOperation = UploadOperation(subject: subject, surveyId: surveyId)
        operationQueue.addOperation(uploadOperation)
        return subject
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    static func isValidJSON(_ data: Data) -> Bool {
        do {
            _ = try JSONSerialization.jsonObject(with: data, options: [])
            return true
        } catch {
            return false
        }
    }
    
    // MARK: - URLSessionDownloadDelegate
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("downloadTask = \(downloadTask)")
        print("location = \(location)")
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        print("didWriteData")
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
        print("didResumeAtOffset")
    }
}
