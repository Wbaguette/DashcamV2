// Author: Jean-Pierre

import SwiftUI

struct ConnectionStatusPill: View {
    @EnvironmentObject var monitor: DashcamMonitor
    @State private var showDetails = false

    var body: some View {
        Button(action: { showDetails = true }) {
            HStack(spacing: 6) {
                Circle()
                    .fill(statusColor)
                    .frame(width: 8, height: 8)
                
                Text(statusText)
                    .font(.system(size: 12, weight: .bold, design: .rounded))
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color(.systemGray6))
            .cornerRadius(20)
        }
        .sheet(isPresented: $showDetails) {
            StatusDetailSheet()
                .presentationDetents([.height(250)]) // Small bottom sheet
        }
    }

    private var statusColor: Color {
        switch monitor.status {
        case .connectedToDashcam: return .green
        case .searching: return .yellow
        case .cellular, .otherWiFi: return .orange
        case .disconnected: return .red
        }
    }

    private var statusText: String {
        switch monitor.status {
        case .connectedToDashcam: return "DASHCAM CONNECTED"
        case .searching: return "SEARCHING..."
        default: return "NOT CONNECTED"
        }
    }
}
