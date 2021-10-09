/*
 * Copyright © 2020 DUNGNGUYEN. All rights reserved.
 *
 * Created by DUNGNGUYEN on 19/12/24.
 */

import UIKit
import QDCore

class McsUtility {
    
    static func secondToTimeString(_ second : Int) -> String {
        var result = ""
        var num = Int(3600 * 24 * 365.25)
        var remain = second
        let year = remain/num
        if year > 0 {
            result = year.toString() + " \("year".localized)"
        }
        remain = remain - year * num
        num = num/12
        let month = remain/num
        if month > 0 {
            if result.count > 0 {
                result += " "
            }
            result += month.toString() + " \("month".localized)"
        }
        remain = remain - month * num
        num = 3600 * 24
        let day = remain / num
        if day > 0 {
            if result.count > 0 {
                result += " "
            }
            result += day.toString() + " \("day".localized)"
        }
        remain = remain - day * num
        num = 3600
        let hour = remain / num
        if hour > 0 {
            if result.count > 0 {
                result += " "
            }
            result += hour.toString() + " \("hour".localized)"
        }
        remain = remain - hour * num
        num = 60
        let minute = remain / num
        if minute > 0 {
            if result.count > 0 {
                result += " "
            }
            result += minute.toString() + " \("minute".localized)"
        }
        let sec = remain - minute * num
        if sec > 0 {
            if result.count > 0 {
                result += " "
            }
            result += sec.toString() + " \("second".localized)"
        }
        return result
    }
    
    static func appendStrikeText(_ label: UILabel, text: String?) {
        if let text = text, text.count > 0 {
            let attText = NSMutableAttributedString.init(label.text!, font: label.font, color: label.textColor)
            attText.append(NSAttributedString.init("  ", font: label.font, color: UIColor.lightGray))
            attText.append(NSAttributedString.init(text, font: label.font, color: UIColor.lightGray, strike: true))
            label.attributedText = attText
        }
    }
    
    static func appendLightGrayText(_ label: UILabel, text: String?) {
        if let text = text, text.count > 0 {
            let attText = NSMutableAttributedString.init(label.text!, font: label.font, color: label.textColor)
            attText.append(NSAttributedString.init("  ", font: label.font, color: UIColor.lightGray))
            attText.append(NSAttributedString.init(text, font: label.font, color: UIColor.lightGray))
            label.attributedText = attText
        }
    }
    
    static func clone<T: McsBase> (_ obj: T?, withoutID: Bool) -> T? {
        if let obj = obj {
            let result = T.init(JSON: obj.toJSON())!
            if withoutID {
                result.id = nil
            }
            return result
        }
        return nil
    }
    
    static func clone<T: McsBase> (_ list: [T]?, withoutID: Bool) -> [T]? {
        if let list = list {
            let result = Array<T>.init(JSONArray: list.toJSON())
            if withoutID {
                for item in result {
                    item.id = nil
                }
            }
            return result
        }
        return nil
    }
    
}
