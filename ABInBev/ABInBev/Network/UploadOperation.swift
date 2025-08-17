//
//  UploadOperation.swift
//  ABInBev
//
//  Created by Henry Heleine on 8/14/25.
//

import Combine
import Foundation

class UploadOperation: Operation, @unchecked Sendable {
    var attempts: Int
    var isActive: Bool
    var maxRetries: Int
    var subject: PassthroughSubject<Double, Never>
    var surveyId: String
    var timeoutInterval: TimeInterval
    
    init(attempts: Int = 0,
         isActive: Bool = true,
         maxRetries: Int = 1,
         subject: PassthroughSubject<Double, Never> = PassthroughSubject<Double, Never>(),
         surveyId: String = "",
         timeoutInterval: TimeInterval = 60) {
        self.attempts = attempts
        self.isActive = isActive
        self.maxRetries = maxRetries
        self.subject = subject
        self.surveyId = surveyId
        self.timeoutInterval = timeoutInterval
    }
    
    override func main() {
        isExecuting = true
        Task {
            let request = URLRequest.mock(forSurveyId: surveyId, timeoutInterval: timeoutInterval)
            do {
                let config = URLSessionConfiguration.foregroundConfig()
                let session = URLSession(configuration: config)
                let (bytes, _) = try await session.bytes(for: request)
                var iterator = bytes.makeAsyncIterator()
                var data = Data()
                while isActive, let byte = try await iterator.next() {
                    data.append(byte)
                    if UploadClient.isValidJSON(data) {
                        if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any], let _ = json["progress"] as? Double {
                            // mock slow connection/large file upload
                            for i in 0...25 {
                                try? await Task.sleep(for: .seconds(1))
                                subject.send(Double(i) / 25)
                            }
                        }
                        data = Data()
                    }
                }
                finish()
            } catch (let error) {
                print(error.localizedDescription)
                if attempts < maxRetries {
                    // double timeout and wait 30 seconds before retrying
                    attempts += 1
                    timeoutInterval = timeoutInterval * 2
                    sleep(30)
                    main()
                } else {
                    finish()
                }
            }
        }
    }
    
    func finish() {
        subject.send(completion: .finished)
        isExecuting = false
        isFinished = true
    }
    
    
    // MARK: - Boilerplate code
    override var isAsynchronous: Bool { true }
    private let stateQueue = DispatchQueue(label: "persistent.operation.state", attributes: .concurrent)
    private var _executing: Bool = false
    override var isExecuting: Bool {
        get { stateQueue.sync { _executing } }
        set {
            willChangeValue(forKey: "isExecuting")
            stateQueue.sync(flags: .barrier) { _executing = newValue }
            didChangeValue(forKey: "isExecuting")
        }
    }
    private var _finished: Bool = false
    override var isFinished: Bool {
        get { stateQueue.sync { _finished } }
        set {
            willChangeValue(forKey: "isFinished")
            stateQueue.sync(flags: .barrier) { _finished = newValue }
            didChangeValue(forKey: "isFinished")
        }
    }
}
