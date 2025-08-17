//
//  UploadClient.swift
//  ABInBev
//
//  Created by Henry Heleine on 8/12/25.
//

import BackgroundTasks
import Combine
import ComposableArchitecture
import Foundation

class UploadClient: NSObject, URLSessionDownloadDelegate, URLSessionDelegate {
    @Dependency(\.filePersistence) var persistence
    public static let shared = UploadClient()
    let backgroundTimeout = Double(24 * 60 * 60)
    let foregroundTimeout = Double(60)
    var attempts: Int
    var id: UUID
    var maxRetries: Int
    var operationQueue: OperationQueue
    
    init(attempts: Int = 0, id: UUID = UUID(), operationQueue: OperationQueue = OperationQueue(), maxRetries: Int = 1) {
        self.attempts = attempts
        self.id = id
        self.maxRetries = maxRetries
        self.operationQueue = operationQueue
        self.operationQueue.name = "com.henryheleine.ABInBev.UploadClientOperationQueue"
        self.operationQueue.maxConcurrentOperationCount = 2 // for slow connections start low but optionally config to optimized value over time
    }
    
    func publisher(surveyId: String) -> AnyPublisher<Double, Never> {
        let subject = PassthroughSubject<Double, Never>()
        let uploadOperation = UploadOperation(subject: subject, surveyId: surveyId)
        print(uploadOperation.queuePriority)
        operationQueue.addOperation(uploadOperation)
        return subject
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func increasePriorityOfSurvey(surveyId: String) {
        operationQueue.operations.forEach { operation in
            if let operation = operation as? UploadOperation, operation.surveyId == surveyId {
                operation.queuePriority = .high
            }
        }
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
        if let url = downloadTask.originalRequest?.url?.lastPathComponent {
            var surveys = try? (persistence.load([SurveyState].self) as! [SurveyState])
            for i in 0..<(surveys?.count ?? 0) {
                if let survey = surveys?[i] {
                    if survey.referenceNumber == url {
                        surveys?[i] = SurveyState(id: survey.id,
                                                  imageUploadPercentage: 1,
                                                  notes: survey.notes,
                                                  referenceNumber: survey.referenceNumber,
                                                  surveyMode: .complete)
                    }
                }
            }
            try? self.persistence.save(surveys)
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        print("didWriteData: bytesWritten = \(bytesWritten) totalBytesWritten = \(totalBytesWritten) totalBytesExpectedToWrite = \(totalBytesExpectedToWrite)")
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
        print("didResumeAtOffset: fileOffset = \(fileOffset) expectedTotalBytes = \(expectedTotalBytes)")
    }
    
    // MARK: - URLSessionDelegate
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: (any Error)?) {
        if attempts < maxRetries, let _ = error {
            // wait 30 seconds before retrying background task again
            attempts += 1
            sleep(30)
            BGTaskScheduler.schedule()
        }
    }
}
