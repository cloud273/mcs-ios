/*
 * Copyright © 2020 DUNGNGUYEN. All rights reserved.
 *
 * Created by DUNGNGUYEN on 20/03/02.
 */

import UIKit
import QDCore
import CLLocalization

class MDClinicViewController: McsTableViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setRefreshToScrollView(tableView)
        reloadView()
    }
    
    
    override func refresh() {
        McsDoctorClinicDetailApi.init(McsDatabase.instance.token!).run() { (success, clinic, code) in
            if success {
                McsDatabase.instance.clinic = clinic
                self.reloadView()
            } else {
                if code != 403 {
                    UIAlertController.generalErrorAlert(self)
                }
            }
            self.endRefresh()
        }
    }
    
    private func reloadView() {
        if let clinic = McsDatabase.instance.clinic {
            var list = [QDSectionData]()
            imageView.setImageUrl(clinic.image , placeholder: clinicIcon)
            var cells = [
                QDCellData.init(cell: "name", data: clinic.name),
                QDCellData.init(cell: "phone", data: clinic.phone),
            ]
            if let workPhone = clinic.workPhone {
                cells.append(QDCellData.init(cell: "workPhone", data: workPhone))
            }
            cells.append(QDCellData.init(cell: "email", data: clinic.email))
            cells.append(QDCellData.init(cell: "address", data: clinic.address.toString()))
            list.append(QDSectionData.init(cells, header: QDCellData.init(data: "Basic_information".localized))
            )
            if let certificates = clinic.certificates, certificates.count > 0 {
                var cells = [QDCellData]()
                for certificate in certificates {
                    cells.append(QDCellData.init("certificate", cell: "certificate", data: certificate, accessory: .detailButton))
                }
                list.append(QDSectionData.init(cells, header: QDCellData.init(data: "Certificate".localized)))
            }
            self.list = list
        } else {
            list = []
        }
    }
    
    @IBAction func imagePressed(_ sender: Any) {
        if let url = McsDatabase.instance.clinic?.image {
            McsImagePresentViewController.show(self, url: url)
        }
    }
    
    override func userDidTapAccessoryButton(_ id: Any?, data: Any?) {
        let vc = McsCertificateViewController.instance()
        vc.certificate = data as? McsCertificate
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}



