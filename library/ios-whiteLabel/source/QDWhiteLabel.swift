/*
 * Copyright © 2019 DUNGNGUYEN. All rights reserved.
 */

import UIKit

class QDWhiteLabel {

    private static let instance = QDWhiteLabel.init()
    
    private var colorMap: [String: [String: String]]!
    private var fontMap: [String: [String: Any]]!
    
    private init() {
        colorMap = (loadJson("color") as! [String: [String: String]])
        fontMap = (loadJson("font") as! [String: [String: Any]])
    }
    
    private func getColor(_ code: String) -> UIColor? {
        var value: String?
        if #available(iOS 13.0, *) {
            if UIScreen.main.traitCollection.userInterfaceStyle == .dark {
                value = colorMap[code]?["dark"]
            } else {
                value = colorMap[code]?["light"]
            }
        } else {
            value = colorMap[code]?["light"]
        }
        if let code = value {
            let rgb = Int.init(code, radix: 16)!
            return UIColor.init(rgb: rgb)
        } else {
            print("-----------------WHITE LABEL COLOR '\(code)' NOT FOUND OR ERROR-------------")
            return nil
        }
    }
    
    private func getFont(_ code: String) -> UIFont? {
        if let f = fontMap[code], let name = f["name"] as? String, let size = f["size"] as? CGFloat {
            return UIFont.init(name: name, size: size)!
        } else {
            print("-----------------WHITE LABEL FONT '\(code)' NOT FOUND OR ERROR-------------")
            return nil
        }
    }
    
    static func getColor(_ code: String) -> UIColor? {
        return instance.getColor(code)
    }
    
    static func getFont(_ code: String) -> UIFont? {
        return instance.getFont(code)
    }
    
}


private extension QDWhiteLabel {
    
    func loadJson(_ filename: String) -> Any? {
        if let path = Bundle.main.path(forResource: filename, ofType: "json") {
            if let result = try? JSONSerialization.jsonObject(with: Data.init(contentsOf: URL.init(fileURLWithPath: path)), options: .allowFragments) {
                return result
            } else {
                print("-----------------WHITE LABEL FILE JSON \(filename) FAIL-------------")
            }
        } else {
            print("-----------------WHITE LABEL FILE \(filename) NOT FOUND-------------")
        }
        return nil
    }
    
}


