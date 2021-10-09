/*
 * Copyright © 2017 DUNGNGUYEN. All rights reserved.
 */

import Foundation
import UIKit

public extension String {
    
    func isValidateEmail() -> Bool {
        let expression = "[a-zA-Z0-9\\+\\.\\_\\%\\-\\+]{1,256}" + "\\@" + "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" + "(" + "\\." + "[a-zA-Z][a-zA-Z\\-]{0,25}" + ")+"
        let predicate = NSPredicate(format:"SELF MATCHES %@", expression)
        return predicate.evaluate(with: self)
    }
    
    func isValidateUsaPhone() -> Bool {
        let prex = "^\\d{3}-\\d{3}-\\d{4}$"
        let predicate = NSPredicate(format:"SELF MATCHES %@", prex)
        return predicate.evaluate(with: self)
    }
    
    func isValidateZip() -> Bool {
        let prex = "^(\\d{5}(-\\d{4})?|[a-zA-Z]\\d[a-zA-Z][- ]*\\d[a-zA-Z]\\d)$"
        let predicate = NSPredicate(format:"SELF MATCHES %@", prex)
        return predicate.evaluate(with: self)
    }
    
    func isValidateVisaCard() -> Bool {
        let prex = "^4[0-9]{12}(?:[0-9]{3})?$"
        let predicate = NSPredicate(format:"SELF MATCHES %@", prex)
        return predicate.evaluate(with: self)
    }
    
    func isValidateMasterCard() -> Bool {
        let prex = "^(?:5[1-5][0-9]{2}|222[1-9]|22[3-9][0-9]|2[3-6][0-9]{2}|27[01][0-9]|2720)[0-9]{12}$"
        let predicate = NSPredicate(format:"SELF MATCHES %@", prex)
        return predicate.evaluate(with: self)
    }
    
    func isValidateDiscoverCard() -> Bool {
        let prex = "^6(?:011|5[0-9]{2})[0-9]{12}$"
        let predicate = NSPredicate(format:"SELF MATCHES %@", prex)
        return predicate.evaluate(with: self)
    }
    
    func containsIgnoreCase(_ containsString: String) -> Bool {
        return self.uppercased().contains(containsString.uppercased())
    }
}
