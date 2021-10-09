/*
 * Copyright © 2017 DUNGNGUYEN. All rights reserved.
 */

import Foundation
import UIKit

fileprivate extension String {
    
    private static func bundleShortVersion(_ bundle: Bundle) -> String {
        return bundle.infoDictionary!["CFBundleShortVersionString" as String] as! String
    }
    
    private static func bundleBuild(_ bundle: Bundle) -> String {
        return bundle.infoDictionary![kCFBundleVersionKey as String] as! String
    }
    
    private static func bundleIdentifier(_ bundle: Bundle) -> String {
        return bundle.infoDictionary![kCFBundleIdentifierKey as String] as! String
    }
    
    private static func bundleExecutable(_ bundle: Bundle) -> String {
        return bundle.infoDictionary![kCFBundleExecutableKey as String] as! String
    }
    
    private static func bundleAppName(_ bundle: Bundle) -> String {
        return bundle.infoDictionary![kCFBundleNameKey as String] as! String
    }
    
}

public extension String {
    
    static var bundleShortVersion: String {
        get {
            return bundleShortVersion(Bundle.main)
        }
    }
    
    static var bundleBuild: String {
        get {
            return bundleBuild(Bundle.main)
        }
    }
    
    static var bundleIdentifier: String {
        get {
            return bundleIdentifier(Bundle.main)
        }
    }
    
    static var bundleExecutable: String {
        get {
            return bundleExecutable(Bundle.main)
        }
    }
    
    static var bundleAppName: String {
        get {
            return bundleAppName(Bundle.main)
        }
    }
    
    static func bundleIdentifier(aClass: AnyClass) -> String {
        return bundleIdentifier(Bundle.init(for: aClass))
    }
    
    static func bundleExecutable(aClass: AnyClass) -> String {
        return bundleExecutable(Bundle.init(for: aClass))
    }
    
}

public extension String {
    
    static func mainBundlePath(_ filename : String) -> String? {
        let string = filename as NSString
        let resource = string.deletingPathExtension
        let type = string.pathExtension
        return Bundle.main.path(forResource: resource, ofType: type)!
    }
    
}

