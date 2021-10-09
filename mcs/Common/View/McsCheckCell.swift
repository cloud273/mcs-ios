/*
 * Copyright © 2020 DUNGNGUYEN. All rights reserved.
 *
 * Created by DUNGNGUYEN on 19/12/12.
 */

import UIKit
import QDCore

protocol McsCheckCellProtocol : NSObjectProtocol {
    
    func userDidChangeSwitch(_ id: Any?, data: Any?, value: Bool)
    
}

protocol McsCheckCellDataProtocol: McsTextProtocol {
    
    func isOn() -> Bool
    
}

class McsCheckCell: McsCell {
    
    class Input: McsCheckCellDataProtocol {
        
        var title: String
        var on: Bool
        
        init(_ title: String, on: Bool) {
            self.title = title
            self.on = on
        }
        
        func getText() -> String {
            return title
        }
        
        func isOn() -> Bool {
            return on
        }
        
    }
    
    @IBOutlet private weak var label: UILabel!
    @IBOutlet private weak var iSwitch: UISwitch!
    
    weak var delegate: McsCheckCellProtocol?
    
    override func setData(_ data: Any?) {
        super.setData(data)
        if let obj = data as? McsCheckCellDataProtocol {
            label.text = obj.getText()
            iSwitch.isOn = obj.isOn()
        }
    }
    
    @IBAction private func switchChanged(_ sender: Any) {
        delegate?.userDidChangeSwitch(id, data: data, value: iSwitch.isOn)
    }
    
}
