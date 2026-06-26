// Author: Jean-Pierre

import SwiftUI

struct WarningMessage: Identifiable {
    let id = UUID()
    let text: String
}

class AppWarningManager: ObservableObject {
    @Published var activeWarning: WarningMessage?
    
    func show(message: String) {
        activeWarning = WarningMessage(text: message)
    }
}

struct WarningPopup: View {
    @Environment(\.dismiss) var dismiss
    let message: String
    
    var body: some View {
        VStack(spacing: 20) {
            
            HStack(spacing: 8) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 28))
                    .symbolRenderingMode(.multicolor)
                
                Text("Warning")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
            }
            .padding(.top, 10)
            
            ScrollView {
                Text(message)
                    .font(.callout)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
        }
        .padding(.horizontal, 24)
        .padding(.top, 24)
        .preferredColorScheme(.dark)
    }
}
