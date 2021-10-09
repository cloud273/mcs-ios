/*
 * Copyright © 2020 DUNGNGUYEN. All rights reserved.
 *
 * Created by DUNGNGUYEN on 19/12/12.
 */

import UIKit
import QDCore
import CLLocalization
import QDWhiteLabel

class McsNavigationController: UINavigationController {
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default;
    }
    
    override func loadView() {
        super.loadView()
        navigationBar.wTitleFont = "header-title-font"
        navigationBar.wTitleColor = "header-title-color"
        navigationBar.wTintColor = "header-tint-color"
        navigationBar.wBarTintColor = "header-background"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(languageChanged), name: CLLocalization.languageChangedNotification, object: nil)
    }
    
    @objc
    func languageChanged() {
        
    }
    
}

