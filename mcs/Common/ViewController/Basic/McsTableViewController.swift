/*
 * Copyright © 2020 DUNGNGUYEN. All rights reserved.
 *
 * Created by DUNGNGUYEN on 19/05/31.
 */

import UIKit
import QDCore
import CLLocalization
import QDWhiteLabel

class McsTableViewController: QDTableViewController {
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.wBgColor = "background"
        NotificationCenter.default.addObserver(self, selector: #selector(languageChanged), name: CLLocalization.languageChangedNotification, object: nil)
    }
    
    @objc
    func languageChanged() {
        
    }
    
}
