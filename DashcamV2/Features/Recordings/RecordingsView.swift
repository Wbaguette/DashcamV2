// Author: Jean-Pierre

import SwiftUI

struct RecordingsView: View {
    @State private var selectedDate = Date.now
    
    private var cameraTypes = ["Front", "Rear"]
    @State private var selectedCamera = "Front"
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 10) {
                    HStack(spacing: 12) {
                        Spacer()
                        DatePicker(selection: $selectedDate, in: ...Date.now, displayedComponents: .date) {
                            Label("Date", systemImage: "calendar")
                                .fontWeight(.medium)
                        }
                        .datePickerStyle(.compact)
                        .labelsHidden()
                        .frame(width: 160)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color(.systemGroupedBackground))
                        .cornerRadius(8)
                                                
                        Menu {
                            Picker("Select Camera", selection: $selectedCamera) {
                                ForEach(cameraTypes, id: \.self) { cameraType in
                                    Text(cameraType)
                                }
                            }
                        } label: {
                            HStack(spacing: 8) {
                                Image(systemName: "web.camera")
                                Text(selectedCamera)
                                    .fontWeight(.medium)
                                    .lineLimit(1)
                                Image(systemName: "chevron.down")
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                            }
                            .foregroundColor(.primary)
                            .frame(width: 150)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 10)
                            .background(Color(.systemGroupedBackground))
                            .cornerRadius(8)
                        }
                        
                        Spacer()
                    }
                    .padding(.top, 20)
                    
                    Spacer()
                }
                    
                HStack {
                    Text("Recorded Timespans")
                        .font(.system(size: 14, weight: .bold, design: .monospaced))
                        .foregroundColor(.cyan)
                    Spacer()
                }
                .padding(.leading)
                
                
                
                Spacer()
            }
            .padding()
                
        }
        .navigationTitle("Recordings")
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarBackground(Color.black, for: .navigationBar)
            
    }
}
