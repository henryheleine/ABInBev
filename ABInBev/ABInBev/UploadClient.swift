//
//  UploadClient.swift
//  ABInBev
//
//  Created by Henry Heleine on 8/12/25.
//

import Combine
import ComposableArchitecture
import Foundation

struct UploadClient: Equatable {
    public static let shared = UploadClient()
    var id: UUID
    var isActive: Bool
    var operationQueue: OperationQueue
    
    init(id: UUID = UUID(), isActive: Bool = true, operationQueue: OperationQueue = OperationQueue()) {
        self.id = id
        self.isActive = isActive
        self.operationQueue = operationQueue
        self.operationQueue.name = "com.henryheleine.ABInBev.UploadClientOperationQueue"
        self.operationQueue.maxConcurrentOperationCount = 2
    }
    
    func publisher() -> AnyPublisher<Double, Never> {
        let subject = PassthroughSubject<Double, Never>()
        let uploadOperation = UploadOperation(subject: subject)
        // TODO: could add UI element to mark upload as higher priority (possible edit list) currently in time order
        uploadOperation.queuePriority = .high
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
    
    // MARK: Equatable
    static func == (lhs: UploadClient, rhs: UploadClient) -> Bool {
        return lhs.id == rhs.id
    }
}
