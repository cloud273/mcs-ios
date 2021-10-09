/*
* Copyright © 2020 DUNGNGUYEN. All rights reserved.
*
* Created by DUNGNGUYEN on 20/02/07.
*/

import UIKit

extension UISegmentedControl {
    
    func setSegments(titles: [String]) {
        var index = 0
        for title in titles {
            setTitle(title, forSegmentAt: index)
            index += 1
        }
    }
    
    func isGenderType() {
        setTitle("Male".localized, forSegmentAt: 0)
        setTitle("Female".localized, forSegmentAt: 1)
    }
    
    var gender: McsGender {
        set {
            selectedSegmentIndex = (newValue == .male) ? 0 : 1
        }
        get {
            return selectedSegmentIndex == 0 ? .male : .female
        }
    }
    
}


