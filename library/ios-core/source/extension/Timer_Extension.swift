/*
 * Copyright © 2017 DUNGNGUYEN. All rights reserved.
 */

import Foundation
import UIKit

public extension Timer {
    
    class func schedule(delay: TimeInterval, handler: @escaping (Timer?) -> Void) -> Timer {
        if Thread.isMainThread {
            let fireDate = delay + CFAbsoluteTimeGetCurrent()
            let timer = CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, fireDate, 0, 0, 0, handler)!
            CFRunLoopAddTimer(CFRunLoopGetCurrent(), timer, CFRunLoopMode.commonModes)
            return timer
        } else {
            return DispatchQueue.main.sync(execute: {
                let fireDate = delay + CFAbsoluteTimeGetCurrent()
                let timer = CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, fireDate, 0, 0, 0, handler)!
                CFRunLoopAddTimer(CFRunLoopGetCurrent(), timer, CFRunLoopMode.commonModes)
                return timer
            })
        }
    }
    
    class func schedule(repeatInterval interval: TimeInterval, handler: @escaping (Timer?) -> Void) -> Timer {
        if Thread.isMainThread {
            let fireDate = interval + CFAbsoluteTimeGetCurrent()
            let timer = CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, fireDate, interval, 0, 0, handler)!
            CFRunLoopAddTimer(CFRunLoopGetCurrent(), timer, CFRunLoopMode.commonModes)
            return timer
        } else {
            return DispatchQueue.main.sync(execute: {
                let fireDate = interval + CFAbsoluteTimeGetCurrent()
                let timer = CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, fireDate, interval, 0, 0, handler)!
                CFRunLoopAddTimer(CFRunLoopGetCurrent(), timer, CFRunLoopMode.commonModes)
                return timer
            })
        }
    }
    
}
