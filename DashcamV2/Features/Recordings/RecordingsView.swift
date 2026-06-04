// Author: Jean-Pierre

import SwiftUI

enum CameraType: String, CaseIterable {
    case front = "Front Camera"
    case rear = "Rear Camera"
}

struct RecordingsView: View {
    @State private var selectedDate = Date.now
    
    private var cameraTypes = ["Front", "Rear"]
    @State private var selectedCamera: CameraType = .front
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 10) {
                    HStack(spacing: 12) {
                        
                        DatePicker("", selection: $selectedDate, in: ...Date.now, displayedComponents: .date)
                            .datePickerStyle(.compact)
                            .labelsHidden()
                            .frame(width: 110, height: 35)
                            .clipShape(Capsule())
//                            .clipped()
                                                
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
