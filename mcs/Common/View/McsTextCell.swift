/*
 * Copyright © 2020 DUNGNGUYEN. All rights reserved.
 *
 * Created by DUNGNGUYEN on 19/12/12.
 */

import UIKit
import QDCore

class McsTextCell: McsCell {
    
    @IBOutlet weak var label: UILabel!
    
    override func setData(_ data: Any?) {
        super.setData(data)
        var text : String
        if let tmp = data as? String {
            text = tmp
        } else {
            text = (data as! McsTextProtocol).getText()
        }
        label.text = text
    }
    
}
