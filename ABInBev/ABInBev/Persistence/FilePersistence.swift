//
//  FilePersistence.swift
//  ABInBev
//
//  Created by Henry Heleine on 8/14/25.
//

import Dependencies
import Foundation

struct FilePersistence {
    var fileExists: @Sendable () -> Bool
    var save: @Sendable (_ data: Encodable) throws -> Void
    var load: @Sendable (_ type: Any.Type) throws -> Any
}

extension FilePersistence {
    static let live: FilePersistence = {
        let fileName = "surveys.json"
        let url: URL = {
            FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(fileName)
        }()
        
        return FilePersistence(
            fileExists: {
                return FileManager.default.fileExists(atPath: url.absoluteString)
            },
            save: { data in
                let enc = JSONEncoder()
                enc.outputFormatting = [.prettyPrinted, .sortedKeys]
                let encoded = try enc.encode(AnyEncodable(data))
                try encoded.write(to: url, options: [.atomicWrite])
            },
            load: { type in
                let raw = try Data(contentsOf: url)
                let dec = JSONDecoder()
                return try dec.decode([SurveyState].self, from: raw)
            }
        )
    }()
}

// MARK: - Boilerplate code
private struct AnyEncodable: Encodable {
    let encodable: Encodable
    init(_ encodable: Encodable) {
        self.encodable = encodable
    }
    func encode(to encoder: Encoder) throws {
        try encodable.encode(to: encoder)
    }
}

extension DependencyValues {
    var filePersistence: FilePersistence {
        get { self[FilePersistenceKey.self] }
        set { self[FilePersistenceKey.self] = newValue }
    }
    
    private enum FilePersistenceKey: DependencyKey {
        static let liveValue = FilePersistence.live
    }
}
