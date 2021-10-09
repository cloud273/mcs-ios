/*
 * Copyright © 2020 DUNGNGUYEN. All rights reserved.
 *
 * Created by DUNGNGUYEN on 19/12/12.
 */

import UIKit
import QDCore

class MDDoctorCell: McsCell {
    
    @IBOutlet private weak var profileImage: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet private weak var genderLabel: UILabel!
    @IBOutlet private weak var dobLabel: UILabel!
    
    override func setData(_ data: Any?) {
        super.setData(data)
        let account = data as! McsAccount
        nameLabel.text = account.profile!.fullname
        usernameLabel.text = account.username
        genderLabel.text = account.profile!.gender.toString()
        dobLabel.text = "\("Dob".localized): \(account.profile!.dob.toAppDateString())" 
        profileImage.setImageUrl(account.image, placeholder: profileIcon)
    }
    
}
