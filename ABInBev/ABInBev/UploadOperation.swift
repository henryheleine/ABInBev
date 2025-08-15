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
    var timeoutInterval: TimeInterval
    
    init(attempts: Int = 0,
         isActive: Bool = true,
         maxRetries: Int = 1,
         subject: PassthroughSubject<Double, Never> = PassthroughSubject<Double, Never>(),
         timeoutInterval: TimeInterval = 60) {
        self.attempts = attempts
        self.isActive = isActive
        self.maxRetries = maxRetries
        self.subject = subject
        self.timeoutInterval = timeoutInterval
    }
    
    override func main() {
        isExecuting = true
        Task {
            let request = URLRequest.postUpload(timeoutInterval: timeoutInterval)
            URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
                guard let self = self else { return }
                if error == nil {
                    // mock slow connection/large upload size
                    for i in 0...25 {
                        sleep(1)
                        self.subject.send(Double(i) / 25)
                    }
                    self.subject.send(completion: .finished)
                    self.isExecuting = false
                    self.isFinished = true
                    // TODO: save data to file for resume data (background download)
                } else {
                    if self.attempts < self.maxRetries {
                        sleep(15)
                        self.timeoutInterval = self.timeoutInterval * 2
                        self.attempts += 1
                        self.main()
                    }
                }
            }.resume()
        }
    }
    
    
    // MARK: Operation boilerplater code
    override var isAsynchronous: Bool { true }
    private let stateQueue = DispatchQueue(label: "persistent.operation.state", attributes: .concurrent)
    private var _executing: Bool = false
    override private(set) var isExecuting: Bool {
        get { stateQueue.sync { _executing } }
        set {
            willChangeValue(forKey: "isExecuting")
            stateQueue.sync(flags: .barrier) { _executing = newValue }
            didChangeValue(forKey: "isExecuting")
        }
    }
    private var _finished: Bool = false
    override private(set) var isFinished: Bool {
        get { stateQueue.sync { _finished } }
        set {
            willChangeValue(forKey: "isFinished")
            stateQueue.sync(flags: .barrier) { _finished = newValue }
            didChangeValue(forKey: "isFinished")
        }
    }
}
