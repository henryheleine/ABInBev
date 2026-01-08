//
//  ProgressViewCircular.swift
//  ABInBev
//
//  Created by Henry Heleine on 1/6/26.
//

import SwiftUI

struct ProgressViewCircular: View {
    let progress: Double
    
    var body: some View {
        ProgressView(value: progress, total: 1) {
            Text("\(Int(progress*100))%")
                .font(Font.system(size: 6))
        }
        .progressViewStyle(.circular)
        .tint(.green)
    }
}
