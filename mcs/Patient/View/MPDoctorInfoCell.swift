/*
 * Copyright © 2020 DUNGNGUYEN. All rights reserved.
 *
 * Created by DUNGNGUYEN on 19/12/12.
 */

import UIKit
import QDCore
import CLLocalization

class MPDoctorInfoCell: McsCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var genderAgeLabel: UILabel!
    
    override func setData(_ data: Any?) {
        super.setData(data)
        let doctor = data as! McsDoctor
        nameLabel.text = doctor.title!.localized + " " + doctor.profile!.fullname
        genderAgeLabel.text = "\(doctor.profile!.gender.toString()) / \(doctor.profile!.dob.yearOld().toString())\("Year_old".localized)"
    }
    
}
