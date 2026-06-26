// Author: Jean-Pierre

import SwiftUI

struct StreamView: View {
    
    @State private var isActive = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 25) {
                        if isActive {
                            // FRONT CAMERA
                            cameraSection(title: "FRONT CAMERA", url: Config.frontCamURL)
                            
                            // REAR CAMERA
                            cameraSection(title: "REAR CAMERA", url: Config.rearCamURL)
                        } else {
                            Color.black.frame(height: 400)
                        }
                        Spacer(minLength: 50)
                    }
                    .padding(.top, 10)
                }
            }
            .navigationTitle("Live Streams")
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(Color.black, for: .navigationBar)
            .onAppear {
                isActive = true
            }
            .onDisappear {
                isActive = false
            }
        }
    }
    
    @ViewBuilder
    func cameraSection(title: String, url: URL) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 14, weight: .bold, design: .monospaced))
                .foregroundColor(.cyan)
                .padding(.leading, 20)
            
            DashcamWebView(url: url)
                .frame(maxWidth: .infinity)
                .aspectRatio(16/9, contentMode: .fit)
                .padding(.horizontal)
        }
    }
}
