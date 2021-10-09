/*
 * Copyright © 2017 DUNGNGUYEN. All rights reserved.
 */

import Foundation
import UIKit

public extension String {

    func formattedString(_ format: String, acceptedCharacter: String?) -> String {
        if self.count == 0 || format.count == 0 {
            return self
        }
        let format = format.appending("X")
        let string: String = self.appending("0")
        let regex = try! NSRegularExpression(pattern: "\\D", options: .caseInsensitive)
        var stripped = regex.stringByReplacingMatches(in: string, options: [], range: NSRange.init(location: 0, length: string.count), withTemplate: "")
        var patterns = [0]
        var separators = [String]()
        var maxLength: Int = 0
        for i in 0 ..< format.count {
            let character = format.substring(with: NSRange.init(location: i, length: 1))
            if character.isEqual("X") {
                maxLength += 1
                patterns[patterns.count - 1] += 1
            } else {
                patterns.append(0)
                separators.append(character)
            
            }
        }
        if stripped.count > maxLength {
            stripped = stripped.substring(to: maxLength)
        }
        var match: String = ""
        var replace: String = ""
        var expressions = [[String: String]]()
        for i in 0 ..< patterns.count {
            let currentMatch = match.appending("(\\d+)")
            match = match.appending("(\\d{\(patterns[i])})")
            let template: String
            if i == 0 {
                template = "$\(CLong(i)+1)"
            } else {
                let separatorCharacter = separators[i-1].first!
                template = "\\\(separatorCharacter)$\(i+1)"
            
            }
            replace = replace.appending(template)
            expressions.append(["match":currentMatch, "replace":replace])
        }
        var result = stripped
        for expression in expressions {
            let match = expression["match"]!
            let replace = expression["replace"]!
            let modifiedString = stripped.replacingOccurrences(of: match, with: replace, options: .regularExpression, range: nil)
            if modifiedString != stripped {
                result = modifiedString
            }
        }
        result = result.substring(to: result.count - 1)
        if let acceptedCharacter = acceptedCharacter {
            let characterSet: NSCharacterSet = NSCharacterSet(charactersIn: acceptedCharacter.appending("X"))
            result = result.trimmingCharacters(in: characterSet.inverted)
        }
        return result
    }
    
    func unFormattedString(_ format: String, acceptedCharacter: String?) -> String {
        if self.count == 0 || format.count == 0 {
            return self
        }
        var characterSet: NSCharacterSet
        if let acceptedCharacter = acceptedCharacter {
            characterSet = NSCharacterSet(charactersIn: acceptedCharacter.appending("X"))
        } else {
            characterSet = NSCharacterSet(charactersIn: "X")
        }
        let trimmedFormat = format.components(separatedBy: characterSet.inverted).joined(separator: "")
        let trimmedText = self.components(separatedBy: NSCharacterSet.decimalDigits.inverted).joined(separator: "")
        var result = ""
        let length = min(trimmedFormat.count, trimmedText.count)
        for i in 0 ..< length {
            let range: NSRange = NSMakeRange(i, 1)
            let symbol: String = trimmedText.substring(with: range)
            if !trimmedFormat.substring(with: range).isEqual(symbol) {
                result.append(symbol)
            }
        }
        return result
    }
    
}
