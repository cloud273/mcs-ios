/*
 * Copyright © 2019 DUNGNGUYEN. All rights reserved.
 */

import UIKit

public class QDLog : NSObject {
    
    fileprivate let length : Int
    
    fileprivate let filename : String
    
    fileprivate let format : String
    
    fileprivate var latestData = [String]()
    
    fileprivate var data = [String]()
    
    fileprivate var showConsole = false
    
    fileprivate var changed = false
    
    private var queue : DispatchQueue!
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    public init(_ filename: String = "Log", format: String = "txt", showConsole: Bool = true, length : Int = 1000) {
        self.filename = filename
        self.showConsole = showConsole
        self.format = format
        self.length = length
        super.init()
        if let d = FileManager.default.contents(atPath: self.directory()) {
            if let jsonObj = try? JSONSerialization.jsonObject(with: d, options: .allowFragments) {
                if let obj = jsonObj as? [String] {
                    data = obj
                }
            }
        }
        latestData = data
        
        NotificationCenter.default.addObserver(self, selector: #selector(saveFile), name: UIApplication.didEnterBackgroundNotification, object: nil)
        
        self.queue = DispatchQueue(label: self.description)
    }
    
    private func toString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZ"
        return formatter.string(from: date)
    }
    
    private func directory() -> String {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!.appending("/" + filename + "." + format)
    }
    
    private func saveDirectory() -> String {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!.appending("/" + filename + "_" + toString(Date()) + "." + format)
    }
    
    @objc
    private func saveFile() {
        let log = try! JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
        FileManager.default.createFile(atPath: saveDirectory(), contents: log, attributes: nil)
        data = []
        try? FileManager.default.removeItem(atPath: directory())
    }
    
    private func internalSave() {
        if changed {
            let log = try! JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
            FileManager.default.createFile(atPath: directory(), contents: log, attributes: nil)
            changed = false
        }
        
    }
    
    private func internalAdd(_ text: String) {
        let text = String(format: "%@: %@", toString(Date()), text)
        latestData.append(text)
        data.append(text)
        if data.count >= length {
            saveFile()
        }
        if latestData.count >= length {
            latestData.removeFirst()
        }
        changed = true
        if showConsole {
            print(text)
        }
    }
    
    public func save() {
        queue.async {
            self.internalSave()
        }
        
    }
    
    public func add(_ text: String) {
        queue.async {
            self.internalAdd(text)
        }
    }
    
    public var log: [String] {
        get {
            return latestData
        }
    }
    
}
