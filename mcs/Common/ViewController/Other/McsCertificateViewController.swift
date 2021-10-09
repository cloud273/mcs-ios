/*
 * Copyright © 2020 DUNGNGUYEN. All rights reserved.
 *
 * Created by DUNGNGUYEN on 19/12/30.
 */

import UIKit
import QDCore

class McsCertificateViewController: McsTableViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    private var _certificate: McsCertificate!
    
    var certificate: McsCertificate! {
        get {
            return _certificate
        }
        set {
            _certificate = newValue
            if isViewLoaded {
                reloadView()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadView()
    }
    
    func reloadView() {
        if let certificate = certificate {
            self.title = certificate.title()
            imageView.setImageUrl(certificate.image, placeholder: certificateIcon)
            var cells = [
                QDCellData.init(cell: "code", data: certificate.code),
                QDCellData.init(cell: "name", data: certificate.name),
                QDCellData.init(cell: "issuer", data: certificate.issuer),
                QDCellData.init(cell: "issueDate", data: certificate.issueDate.toAppDateString())
            ]
            if let expDate = certificate.expDate {
                cells.append(QDCellData.init(cell: "expDate", data: expDate.toAppDateString()))
            }
            self.list = [QDSectionData.init(cells)]
        }
    }
    
    @IBAction func imagePressed(_ sender: Any) {
        if let url = certificate.image {
            McsImagePresentViewController.show(self, url: url)
        }
    }
    
    class func instance() -> McsCertificateViewController {
        let result = UIStoryboard(name: "Other", bundle: nil).instantiateViewController(withIdentifier: "certificateVC") as! McsCertificateViewController
        return result
    }
    
}



