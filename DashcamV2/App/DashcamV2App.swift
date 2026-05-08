// Author: Jean-Pierre

import SwiftUI

@main
struct DashcamV2App: App {
    
    @StateObject private var monitor = DashcamMonitor()
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(monitor)
                .preferredColorScheme(.dark)
        }
    }
}
