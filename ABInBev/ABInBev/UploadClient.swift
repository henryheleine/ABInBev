//
//  UploadClient.swift
//  ABInBev
//
//  Created by Henry Heleine on 8/12/25.
//

import Combine
import ComposableArchitecture
import Foundation

struct UploadClient {
    var upload: () -> AnyPublisher<Double, Never>
}

extension DependencyValues {
    var uploadClient: UploadClient {
        get { self[UploadClient.self] }
        set { self[UploadClient.self] = newValue }
    }
}

extension UploadClient: DependencyKey {
    static let liveValue = UploadClient {
        let subject = PassthroughSubject<Double, Never>()
        Task {
            var request = URLRequest(url: URL(string: "https://render-4ezx.onrender.com/upload")!)
            request.httpMethod = "POST"
            request.addValue("chunked", forHTTPHeaderField: "Transfer-Encoding")
            let (bytes, response) = try await URLSession.shared.bytes(for: request)
            var iterator = bytes.makeAsyncIterator()
            var data = Data()
            while let byte = try await iterator.next() {
                data.append(byte)
                let chunk = String(data: data, encoding: .utf8) ?? ""
                if isValidJSON(data) {
                    if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any], let progress = json["progress"] as? Double {
                        sleep(1)
                        subject.send(progress)
                    }
                    data = Data()
                }
            }
            subject.send(completion: .finished)
        }
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
}
