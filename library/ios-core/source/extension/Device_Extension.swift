/*
 * Copyright © 2017 DUNGNGUYEN. All rights reserved.
 */

import Foundation
import UIKit

private class DeviceMap {
    static let info : [[String: Any]] = NSObject.loadJsonBundle("device", aClass: DeviceMap.self) as! [[String : Any]]
}

public extension UIDevice {
    
    
    
    var info : String {
        get {
            return "\(modelName) - \(self.systemName) \(self.systemVersion)"
        }
    }
    
    var modelCode: String {
        get {
            var systemInfo = utsname()
            uname(&systemInfo)
            let modelCode = withUnsafePointer(to: &systemInfo.machine) {
                $0.withMemoryRebound(to: CChar.self, capacity: 1) {
                    ptr in String.init(validatingUTF8: ptr)
                    
                }
            }
            return String.init(validatingUTF8: modelCode!)!
        }
    }
    
    var modelName: String {
        get {
            let aCode = modelCode;
            return DeviceMap.info.first(where: { (model) -> Bool in
                model["model"] as! String == aCode
            })?["name"] as? String ?? aCode
            
        }
    }
    
}



