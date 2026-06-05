// Author: Jean-Pierre

import Foundation

struct ListEntry: Codable {
    let start: Date
    let duration: Double
    let url: String
}

class MediaMTXClient {
    
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)
            
            if let date = formatter.date(from: dateString) {
                return date
            }
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode date string \(dateString)")
        }
        
        return decoder
    }()
    
    func parseEntries(from jsonData: Data) throws -> [ListEntry] {
        return try decoder.decode([ListEntry].self, from: jsonData)
    }
    
    func listRecordings() {}
    
    func downloadRecording() {}
}
