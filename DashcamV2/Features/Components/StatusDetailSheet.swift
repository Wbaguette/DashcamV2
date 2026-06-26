// Author: Jean-Pierre

import SwiftUI

struct StatusDetailSheet: View {
    @EnvironmentObject var monitor: DashcamMonitor
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Connection Status")
                .font(.headline)
            
            List {
                LabeledContent("Interface", value: monitor.status.description)
                LabeledContent("Dashcam Reachable", value: monitor.status == .connectedToDashcam ? "Yes" : "No")
            }
            .listStyle(.plain)
            
        }
        .padding()
        .preferredColorScheme(.dark)
    }
}
