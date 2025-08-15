//
//  SurveyView.swift
//  ABInBev
//
//  Created by Henry Heleine on 8/12/25.
//

import ComposableArchitecture
import Foundation
import SwiftUI

struct SurveyView: View {
    @Environment(\.scenePhase) private var scenePhase
    let store: StoreOf<SurveyReducer>

    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            Group {
                HStack {
                    VStack {
                        let text = """
                            # \(viewStore.state.referenceNumber)
                            Notes:
                            \(viewStore.state.notes)
                            Image (Uploaded: \(String(format: "%.2f", viewStore.state.imageUploadPercentage * 100))%)
                            🍺
                            """
                        Text(text)
                    }
                    Spacer()
                    switch viewStore.state.surveyMode {
                    case .complete:
                        Text("Complete")
                    case .paused:
                        Button("Upload") {
                            viewStore.send(.upload)
                        }
                    case .uploading:
                        Text("Uploading...")
                    }
                }
                .padding(.vertical, 8)
            }
            .onChange(of: scenePhase) { oldValue, newValue in
                if case .background = newValue {
                    viewStore.send(.background)
                } else if case .active = newValue  {
                    viewStore.send(.foreground)
                }
            }
        }
    }
}
