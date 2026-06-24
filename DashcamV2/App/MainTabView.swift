// Author: Jean-Pierre

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject  var monitor: DashcamMonitor
    @State private var selectedTab = 0
    @StateObject private var warningManager = AppWarningManager()

    var body: some View {
        TabView(selection: $selectedTab) {
            StreamView()
                .tabItem {
                    Label("Live", systemImage: "dot.radiowaves.left.and.right")
                }
                .tag(0)
            
            RecordingsView()
                .tabItem {
                    Label("Recordings", systemImage: "video.fill")
                }
                .tag(1)
            
            LogsView()
                .tabItem {
                    Label("Logs", systemImage: "terminal.fill")
                }
                .tag(2)
        }
        .environmentObject(warningManager)
        .safeAreaInset(edge: .top) {
            HStack {
                Spacer()
                ConnectionStatusPill().padding(.trailing)
            }.background(Color.black.opacity(0.8))
        }
        .preferredColorScheme(.dark)
        .accentColor(.cyan)
        .sheet(item: $warningManager.activeWarning) { warning in
            WarningPopup(message: warning.text)
                .presentationDetents([.height(300), .medium])
                .presentationDragIndicator(.visible)
        }
    }
    
    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.black
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}
