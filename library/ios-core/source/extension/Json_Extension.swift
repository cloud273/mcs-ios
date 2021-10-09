/*
 * Copyright © 2018 DUNGNGUYEN. All rights reserved.
 */

import Foundation

fileprivate extension NSObject {
    
    static func loadJsonBundle(_ file: String, bundle: Bundle) -> Any {
        let data = try! Data(contentsOf: URL(fileURLWithPath: bundle.path(forResource: file, ofType: "json")!))
        let json = try! JSONSerialization.jsonObject(with: data, options: .allowFragments)
        return json
    }
    
}

public extension NSObject {
    
    static func loadJsonBundle(_ file: String) -> Any {
        return loadJsonBundle(file, bundle: Bundle.main)
    }
    
    static func loadJsonBundle(_ file: String, bundle: String) -> Any {
        return loadJsonBundle(file, bundle: Bundle.init(identifier: bundle)!)
    }
    
    static func loadJsonBundle(_ file: String, aClass: AnyClass) -> Any {
        return loadJsonBundle(file, bundle: Bundle.init(for: aClass))
    }
    
}
