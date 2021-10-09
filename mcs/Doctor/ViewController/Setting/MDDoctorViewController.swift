/*
 * Copyright © 2020 DUNGNGUYEN. All rights reserved.
 *
 * Created by DUNGNGUYEN on 20/03/01.
 */

import UIKit
import QDCore
import CLLocalization

class MDDoctorViewController: McsTableViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setRefreshToScrollView(tableView)
        reloadView()
    }
    
    
    override func refresh() {
        McsDoctorDetailApi.init(McsDatabase.instance.token!).run() { (success, doctor, code) in
            if success {
                McsDatabase.instance.updateAccount(doctor!)
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
        if let doctor = McsDatabase.instance.account as? McsDoctor {
            imageView.setImageUrl(doctor.image , placeholder: profileIcon)
            var cells = [QDCellData.init(cell: "info", data: doctor)]
            if let position = doctor.office {
                cells.append(QDCellData.init(cell: "position", data: position))
            }
            cells.append(QDCellData.init(cell: "specialty", data: doctor.specialtiesString(nil)))
            if let startWork = doctor.startWork {
                let text = "\(startWork.yearOld().toString()) \("years".localized)"
                cells.append(QDCellData.init(cell: "experience", data: text))
            }
            if let biography = doctor.biography {
                cells.append(QDCellData.init(cell: "biography", data: biography))
            }
            if let certificates = doctor.certificates {
                for certificate in certificates {
                    cells.append(QDCellData.init(cell: "certificate", data: certificate, accessory: .detailButton))
                }
            }
            list = [
                QDSectionData.init(cells)
            ]
        } else {
            list = []
        }
    }
    
    override func userDidTapAccessoryButton(_ id: Any?, data: Any?) {
        let vc = McsCertificateViewController.instance()
        vc.certificate = data as? McsCertificate
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}



