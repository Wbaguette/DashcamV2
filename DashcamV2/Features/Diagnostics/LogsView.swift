// Author: Jean-Pierre

import SwiftUI

struct LogsView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    Text("[14:02:01] Camera Initialized")
                    Text("[14:02:05] AP Connection Stable").foregroundColor(.green)
                    Text("[14:05:12] Warning: Low Signal").foregroundColor(.yellow)
                }
                .font(.system(.caption, design: .monospaced))
                .padding()
            }
            .navigationTitle("System Logs")
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(Color.black, for: .navigationBar)
        }
    }
}
