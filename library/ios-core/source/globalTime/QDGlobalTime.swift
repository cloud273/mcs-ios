/*
 * Copyright © 2019 DUNGNGUYEN. All rights reserved.
 */

import UIKit

public class QDGlobalTime {

    public static let instance = QDGlobalTime.init("https://www.google.com")
    
    private var server: String
    
    private var date: Date?
    
    private var localDate: Date?
    
    public init(_ server: String) {
        self.server = server
        NotificationCenter.default.addObserver(self, selector: #selector(reset), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    public func getDate() -> Date? {
        if let date = date, let localDate = localDate {
            return date.addingTimeInterval(-localDate.timeIntervalSinceNow)
        }
        return nil
    }
    
    public func getDate(_ completion: @escaping(Date?) -> Void) {
        if let date = getDate() {
            completion(date)
        } else {
            load {
                completion(self.date)
            }
        }
    }
    
    @objc
    public func reload() {
        load { () in
            
        }
    }
    
    @objc
    public func reset() {
        date = nil
        localDate = nil
    }
    
    private func load(_ completion: @escaping() -> Void) {
        let url = URL(string: server)
        let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
            DispatchQueue.main.async {
                var date: Date? = nil
                if let contentType = (response as? HTTPURLResponse)?.allHeaderFields["Date"] as? String {
                    date = Date.date(contentType, format: "EEE, dd MMM yyyy HH:mm:ss z", locale: "en_US_POSIX")
                }
                if let date = date {
                    self.date = date
                    self.localDate = Date()
                }
                completion()
            }
        }
        task.resume()
    }
    
}
