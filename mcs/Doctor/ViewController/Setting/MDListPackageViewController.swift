/*
 * Copyright © 2020 DUNGNGUYEN. All rights reserved.
 *
 * Created by DUNGNGUYEN on 20/03/03.
 */

import UIKit
import QDCore

class MDListPackageViewController: McsTableViewController {

    private var packages: [McsPackage]!
    
    private let packageCellId = "packageCell"
    private let emptyCellId = "emptyCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setRefreshToScrollView(tableView)
        self.tableView.register(UINib(nibName: "MDPackageCell", bundle: nil), forCellReuseIdentifier: packageCellId)
        self.tableView.register(UINib(nibName: "McsTextEmptyMessageCell", bundle: nil), forCellReuseIdentifier: emptyCellId)
        self.reloadView()
    }
    
    public func setup(_ packages: [McsPackage]) {
        self.packages = packages
    }
    
    override func refresh() {
        if let token = McsDatabase.instance.token {
            McsDoctorListPackageApi.init(token).run() { (success, packages, code) in
                if success {
                    self.packages = packages!
                    self.reloadView()
                }
                self.endRefresh()
            }
        } else {
            self.endRefresh()
        }
    }
    
    private func reloadView() {
        var cells = [QDCellData]()
        if let packages = packages, packages.count > 0 {
            tableView.separatorStyle = .singleLine
            for package in packages {
                cells.append(QDCellData.init(cell: packageCellId, data: package, accessory: .disclosureIndicator))
            }
        } else {
            tableView.separatorStyle = .none
            cells.append(QDCellData.init(cell: emptyCellId, data: "No_package_contact_clinic_admin_message".localized))
        }
        list = [QDSectionData.init(cells)]
    }
    
    override func userDidTapCell(_ id: Any?, data: Any?) {
        if let package = data as? McsPackage {
            McsDoctorPackageDetailApi.init(McsDatabase.instance.token!, id: package.id!).run { (success, package, code) in
                if success {
                    self.performSegue(withIdentifier: "detailSegue", sender: package)
                } else if code == 404 {
                    self.refresh()
                    UIAlertController.show(self, title: "Error".localized, message: "Not_found".localized, close: "Close".localized)
                } else if code != 403 {
                    UIAlertController.generalErrorAlert(self)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue" {
            let vc = segue.destination as! MDPackageDetailViewController
            vc.setup(sender as! McsPackage)
        }
    }
    
}
