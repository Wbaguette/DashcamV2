// Author: Jean-Pierre

import SwiftUI

struct RecordingsView: View {
    var body: some View {
        NavigationStack {
            List(0..<5) { item in
                HStack {
                    Image(systemName: "video.circle")
                    Text("Recording_\(item).mp4")
                    Spacer()
                    Image(systemName: "icloud.and.arrow.down")
                }
            }
            .navigationTitle("Recordings")
        }
    }
}
