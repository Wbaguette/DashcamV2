// Author: Jean-Pierre

import SwiftUI
import Network
import NetworkExtension

enum ConnectionStatus: CustomStringConvertible {
    case searching
    case connectedToDashcam
    case otherWiFi
    case cellular
    case disconnected
    
    var description: String {
        switch self {
        case .searching: return "Searching..."
        case .connectedToDashcam: return "Dashcam AP"
        case .otherWiFi: return "Wi-Fi"
        case .cellular: return "Cellular"
        case .disconnected: return "Disconnected"
        }
    }
}

class DashcamMonitor: ObservableObject {
    @Published var status: ConnectionStatus = .searching
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "DashcamMonitorQueue")
    private let targetSSID = Config.dashcamSSID
    
    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if path.usesInterfaceType(.wifi) {
                    self.verifySSID()
                } else if path.usesInterfaceType(.cellular) {
                    self.status = .cellular
                } else {
                    self.status = .disconnected
                }
            }
        }
        monitor.start(queue: queue)
    }
    
    private func verifySSID() {
        #if targetEnvironment(simulator)
        // MOCK: Automatically succeed if running on Simulator
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            print("--- SIMULATOR MOCK: Bypassing SSID check ---")
            self.status = .connectedToDashcam
        }
        #else
        // REAL: Actual hardware logic
        NEHotspotNetwork.fetchCurrent { [weak self] network in
            DispatchQueue.main.async {
                if let ssid = network?.ssid, ssid == self?.targetSSID {
                    self?.status = .connectedToDashcam
                } else {
                    self?.status = .otherWiFi
                }
            }
        }
        #endif
    }

}
