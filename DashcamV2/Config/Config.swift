// Author: Jean-Pierre

import Foundation

enum Config {
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("Plist file not found")
        }
        return dict
    }()

    static let dashcamSSID: String = {
        guard let string = infoDictionary["DashcamSSID"] as? String else {
            fatalError("DashcamSSID not set in xcconfig")
        }
        return string
    }()
    
    static let frontCamURL: URL = {
        guard let urlString = infoDictionary["FrontCamURL"] as? String,
              let url = URL(string: urlString.replacingOccurrences(of: " ", with: "")) else {
            fatalError("FrontCamURL is missing or invalid in Info.plist")
        }
        return url
    }()
    
    static let rearCamURL: URL = {
        guard let urlString = infoDictionary["RearCamURL"] as? String,
              let url = URL(string: urlString.replacingOccurrences(of: " ", with: "")) else {
            fatalError("RearCamURL is missing or invalid in Info.plist")
        }
        return url
    }()
    
}
