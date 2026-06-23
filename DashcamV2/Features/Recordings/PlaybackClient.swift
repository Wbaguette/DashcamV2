// Author: Jean-Pierre

import Foundation

struct ListEntry: Codable {
    let start: Date
    let duration: Double
    let url: String
}

class PlaybackClient {
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
    
    func listRecordings(date: Date, camera: CameraType) {
        let formatter = ISO8601DateFormatter()
        formatter.timeZone = .current
    
        let startDate = Calendar.current.startOfDay(for: date)
        guard let endDate = Calendar.current.date(byAdding: .day, value: 1, to: startDate) else {
            // TODO: some error banner
            return
        }
        
        let startDateString = formatter.string(from: startDate)
        let endDateString = formatter.string(from: endDate)
        
        var path = ""
        switch camera {
            case .front:
                path = "cam1audio"
            case .rear:
                path = "cam2audio"
        }
        
        if path == "" {
            // TODO: Some error/warning banner
        }
        
        var url = Config.playbackBaseURL
        url.append(queryItems: [
            URLQueryItem(name: "path", value: path),
            URLQueryItem(name: "start", value: startDateString),
            URLQueryItem(name: "end", value: endDateString),
        ])
        
        print(url)
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            guard let data = data else {
                print("No data received")
                return
            }
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Success! Data received:\n\(jsonString)")
            }
        }
        
        task.resume()
    }
    
    func downloadRecording() {}
}
