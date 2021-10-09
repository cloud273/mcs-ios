/*
 * Copyright © 2020 DUNGNGUYEN. All rights reserved.
 *
 * Created by DUNGNGUYEN on 19/12/12.
 */

import UIKit
import QDCore
import CLLocalization

class MPDoctorCell: McsCell {
    
    class Data {
        
        let specialty: McsSpecialty
        let doctor: McsDoctor
        
        init(specialty: McsSpecialty, doctor: McsDoctor) {
            self.specialty = specialty
            self.doctor = doctor
        }
        
    }
    
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var clinicLabel: UILabel!
    @IBOutlet weak var specialtyLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setData(_ data: Any?) {
        super.setData(data)
        let data = data as! Data
        let doctor = data.doctor
        iconView.setImageUrl(data.doctor.image, placeholder: doctorIcon)
        genderLabel.text = data.doctor.profile!.gender.toString() + ", " + data.doctor.profile!.dob.yearOld().toString() + "Year_old".localized
        nameLabel.text = data.doctor.title!.localized + " " + data.doctor.profile!.fullname
        descLabel.text = doctor.office ?? ""
        clinicLabel.text = doctor.clinic!.name
        specialtyLabel.text = data.doctor.specialtiesString(data.specialty.code)
    }
    
}
