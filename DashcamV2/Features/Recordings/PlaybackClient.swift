// Author: Jean-Pierre

import Foundation
import SwiftUI

struct ListEntry: Codable {
    let start: Date
    let duration: Double
    let url: String
}

struct FailableDecodable<Base: Decodable>: Decodable {
    let base: Base?

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        do {
            self.base = try container.decode(Base.self)
        } catch {
            print("Skipping entry due to error: \(error)")
            self.base = nil
        }
    }
}

class PlaybackClient: NSObject, URLSessionDelegate {
    
    private lazy var session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config, delegate: self, delegateQueue: nil)
    }()
    
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)
            
            if let date = formatter.date(from: dateString) {
                return date
            } else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode date string \(dateString)")
            }
        }
        
        return decoder
    }()
    
    func parseEntries(from jsonData: Data) -> [ListEntry] {
        do {
            let failbleEntries = try decoder.decode([FailableDecodable<ListEntry>].self, from: jsonData)
            return failbleEntries.compactMap { $0.base }
        } catch {
            // TODO: inject warning manager somehow
            print("Failed to decode the JSON entirely: \(error)")
            return []
        }
        
    }
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            if let trust = challenge.protectionSpace.serverTrust {
                completionHandler(.useCredential, URLCredential(trust: trust))
                return
            } else {
                DispatchQueue.main.async {
                    // TODO: inject warning manager somehow
//                    warningManager.show(message: "Failed to get state of the servers SSL transaction state")
                }
                return
            }
        }
        
        completionHandler(.cancelAuthenticationChallenge, nil)
    }
    
    func listRecordings(date: Date, camera: CameraType, warningManager: AppWarningManager) {
        let formatter = ISO8601DateFormatter()
        formatter.timeZone = .current
    
        let startDate = Calendar.current.startOfDay(for: date)
        guard let endDate = Calendar.current.date(byAdding: .day, value: 1, to: startDate) else {
            DispatchQueue.main.async{
                warningManager.show(message: "Failed to calculate timespan end date, invalid start date")
            }
            return
        }
        
        let startDateString = formatter.string(from: startDate)
        let endDateString = formatter.string(from: endDate)
        
        var url = Config.playbackBaseURL
        url.append(queryItems: [
            URLQueryItem(name: "path", value: camera.path()),
            URLQueryItem(name: "start", value: startDateString),
            URLQueryItem(name: "end", value: endDateString),
        ])
        
        print(url)
        
        let task = session.dataTask(with: url) { data, response, error in
            // TODO: Map status codes to a display, not a warning popup
            let status = (response as! HTTPURLResponse).statusCode
            
            if let error = error {
                DispatchQueue.main.async {
                    warningManager.show(message: error.localizedDescription)
                }
                return
            }
            
            guard let data = data else {
                // TODO: instead of warning message, display "No Timespans Found" to the user where the timespans normally would be
                DispatchQueue.main.async {
                    warningManager.show(message: "No data received.")
                }
                return
            }
            
            let timespanEntries = self.parseEntries(from: data)
        
        }
        
        task.resume()
    }
    
    func downloadRecording() {
        //TODO
    }
}
