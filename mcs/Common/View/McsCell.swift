/*
 * Copyright © 2020 DUNGNGUYEN. All rights reserved.
 *
 * Created by DUNGNGUYEN on 19/12/12.
 */

import UIKit
import QDCore
import QDWhiteLabel

class McsCell: QDTableCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        wBgColor = "background"
        wHighlightedBgColor = "cell-highlight-background"
    }
    
}
