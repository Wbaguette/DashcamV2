// Author: Jean-Pierre

import SwiftUI

enum CameraType: String, CaseIterable {
    case front = "Front Camera"
    case rear = "Rear Camera"
}

struct RecordingsView: View {
    @State private var selectedDate = Date.now
    @State private var selectedCamera: CameraType = .front
    
    private var playbackClient = PlaybackClient()
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.timeZone = .current
        return formatter
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 10) {
                    HStack(spacing: 12) {
                        Text(dateFormatter.string(from: selectedDate))
                            .font(.body)
                            .fontWeight(.medium)
                            .foregroundColor(.primary)
                            .frame(width: 150, height: 35)
                            .background(Color(.tertiarySystemFill))
                            .clipShape(Capsule())
                            .overlay {
                                DatePicker("", selection: $selectedDate, in: ...Date.now, displayedComponents: .date)
                                    .datePickerStyle(.compact)
                                    .labelsHidden()
                                    .blendMode(.destinationOver)
                            }
                                                
                        Menu {
                            ForEach(CameraType.allCases, id: \.self) { camera in
                                Button(camera.rawValue) {
                                    selectedCamera = camera
                                }
                            }
                        } label: {
                            Text(selectedCamera.rawValue)
                                .font(.body)
                                .fontWeight(.medium)
                                .foregroundColor(.primary)
                                .frame(width: 140, height: 35)
                                .background(Color(.tertiarySystemFill))
                                .clipShape(Capsule())
                        }
                        .frame(width: 140, height: 35)
                        .contentShape(Rectangle())
                        
                        Button {
                            playbackClient.listRecordings(date: selectedDate, camera: selectedCamera)
                        } label: {
                            Image(systemName: "magnifyingglass")
                                .font(.body)
                                .fontWeight(.medium)
                                .foregroundColor(.primary)
                                .frame(width: 35, height: 35)
                                .background(Color(.tertiarySystemFill))
                                .clipShape(Circle())
                        }
                        
                        Spacer()
                    }
                    .padding(.top, 10)
                    .padding(.leading)
                    
                    Spacer()
                }
                    
                HStack {
                    Text("Recorded Timespans")
                        .font(.system(size: 20, weight: .bold, design: .monospaced))
                        .foregroundColor(.cyan)
                    Spacer()
                }
                .padding(.leading)
                
                
                
                
                Spacer()
            }
            .navigationTitle("Recordings")
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(Color.black, for: .navigationBar)
        }
    }
}
