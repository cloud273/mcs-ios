/*
 * Copyright © 2020 DUNGNGUYEN. All rights reserved.
 *
 * Created by DUNGNGUYEN on 19/12/07.
 */

import UIKit
import QDCore

protocol McsTextDetailProtocol: McsTextProtocol {
    
    func getDetail() -> String?
    
}

class McsTextDetailCell: McsCell {
    
    class Data: McsTextDetailProtocol {
        private let text: String
        private let detail: String?
        init(_ text: String, detail: String?) {
            self.text = text
            self.detail = detail
        }
        func getText() -> String {
            return text
        }
        func getDetail() -> String? {
            return detail
        }
    }
    
    private var ratioConstraint: NSLayoutConstraint?
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    func setRatio(_ ratio: CGFloat?) {
        ratioConstraint?.isActive = false
        if let ratio = ratio {
            ratioConstraint = label.addWidthConstraint(detailLabel, multiplier: ratio)
        }
    }
    
    override func setData(_ data: Any?) {
        super.setData(data)
        if let tmp = data as? McsTextDetailProtocol {
            label.text = tmp.getText()
            detailLabel.text = tmp.getDetail()
        }
    }
    
}
