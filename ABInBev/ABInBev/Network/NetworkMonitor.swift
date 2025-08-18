//
//  NetworkMonitor.swift
//  ABInBev
//
//  Created by Henry Heleine on 8/17/25.
//

import Foundation
import Network

class NetworkMonitor {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "com.henryheleine.ABInBev.NetworkQueue")
    public var isConnected: Bool = true
    
    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isConnected = path.status == .satisfied
                UploadClient.shared.isActive = self.isConnected
            }
        }
        monitor.start(queue: queue)
    }
}
