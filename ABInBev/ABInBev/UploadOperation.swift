//
//  UploadOperation.swift
//  ABInBev
//
//  Created by Henry Heleine on 8/14/25.
//

import Combine
import Foundation

class UploadOperation: Operation, @unchecked Sendable {
    var isActive: Bool
    var subject: PassthroughSubject<Double, Never>
    
    init(isActive: Bool = true, subject: PassthroughSubject<Double, Never>) {
        self.subject = subject
        self.isActive = isActive
    }
    
    override func main() {
        isExecuting = true
        Task {
            var request = URLRequest(url: URL(string: "https://render-4ezx.onrender.com/upload")!)
            request.httpMethod = "POST"
            request.addValue("chunked", forHTTPHeaderField: "Transfer-Encoding")
            let (bytes, _) = try await URLSession.shared.bytes(for: request)
            var iterator = bytes.makeAsyncIterator()
            var data = Data()
            while isActive, let byte = try await iterator.next() {
                data.append(byte)
                if UploadClient.isValidJSON(data) {
                    if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any], let progress = json["progress"] as? Double {
                        try? await Task.sleep(for: .milliseconds(250))
                        subject.send(progress)
                    }
                    data = Data()
                }
            }
            // TODO: save data to file for resume data (background download)
            subject.send(completion: .finished)
            isExecuting = false
            isFinished = true
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
