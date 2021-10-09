/*
* Copyright © 2020 DUNGNGUYEN. All rights reserved.
*
* Created by DUNGNGUYEN on 20/01/19.
*/

import Foundation
import PhoneNumberKit

private let phoneNumberKit = PhoneNumberKit()

extension String {
    
    func isValidPhoneNumber(_ region: String? = "VN") -> Bool {
        if self.count > 9 {
            let phoneKit = phoneNumberKit
            if let region = region {
                return phoneKit.isValidPhoneNumber(self, withRegion: region, ignoreType: false)
            } else {
                return phoneKit.isValidPhoneNumber(self, ignoreType: false)
            }
            
        } else {
            return false
        }
    }

    func phoneNumber(_ region: String? = "VN") -> String? {
        if self.count > 9 {
            let phoneKit = phoneNumberKit
            do {
                var phoneNumber: PhoneNumber
                if let region = region {
                    phoneNumber = try phoneKit.parse(self, withRegion: region, ignoreType: false)
                } else {
                    phoneNumber = try phoneKit.parse(self, ignoreType: false)
                }
                return "+" + String(phoneNumber.countryCode) + String(phoneNumber.nationalNumber)
            } catch {
                return nil
            }
        } else {
            return nil
        }
    }
    
    func regionPhoneNumber() -> String? {
        if self.count > 9 {
            let phoneKit = phoneNumberKit
            do {
                let phoneNumber = try phoneKit.parse(self, ignoreType: false)
                return phoneNumber.regionID
            } catch {
                return nil
            }
        } else {
            return nil
        }
    }
    
}


