/*
 * Copyright © 2020 DUNGNGUYEN. All rights reserved.
 *
 * Created by DUNGNGUYEN on 19/12/12.
 */

import UIKit
import QDCore

class MDTimeCell: McsCell {
    
    class Data {
        
        fileprivate var weekday: String
        
        fileprivate var timeRanges: [McsTimeRange]
        
        init(_ weekday: String, timeRanges: [McsTimeRange]) {
            self.weekday = weekday
            self.timeRanges = timeRanges
        }
        
    }
    
    @IBOutlet private weak var titleLabel: UILabel!
    
    @IBOutlet private weak var nameLabel: UILabel!
    
    override func setData(_ data: Any?) {
        let data = data as! Data
        titleLabel.text = data.weekday
        var text = ""
        if data.timeRanges.count > 0 {
            for item in data.timeRanges {
                if text.count > 0 {
                    text.append("\n")
                }
                if data.timeRanges.count > 1 {
                    text.append("+ ")
                }
                text.append("\(item.fromText) - \(item.toText)")
            }
        } else {
            text = "No_schedule_on_weekday".localized
        }
        
        nameLabel.text = text
    }
    
}
