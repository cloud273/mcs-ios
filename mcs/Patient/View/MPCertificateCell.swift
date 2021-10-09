/*
 * Copyright © 2020 DUNGNGUYEN. All rights reserved.
 *
 * Created by DUNGNGUYEN on 19/12/12.
 */

import UIKit
import QDCore

class MPCertificateCell: McsCell {
    
    @IBOutlet private weak var typeLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    
    override func setData(_ data: Any?) {
        let certificate = data as! McsCertificate
        typeLabel.text = certificate.title()
        nameLabel.text = certificate.name
    }
    
}
