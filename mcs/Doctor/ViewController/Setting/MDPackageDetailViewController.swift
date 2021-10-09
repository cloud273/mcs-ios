/*
 * Copyright © 2020 DUNGNGUYEN. All rights reserved.
 *
 * Created by DUNGNGUYEN on 20/03/04.
 */

import UIKit
import QDCore

class MDPackageDetailViewController: McsTableViewController {

    private var package: McsPackage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setRefreshToScrollView(tableView)
        self.reloadView()
    }
    
    public func setup(_ package: McsPackage) {
        self.package = package
    }
    
    override func refresh() {
        McsDoctorPackageDetailApi.init(McsDatabase.instance.token!, id: package.id!).run { (success, package, code) in
            if success {
                self.package = package!
                self.reloadView()
            } else if code == 404 {
                UIAlertController.show(self, title: "Error".localized, message: "Not_found".localized, close: "Close".localized) {
                    self.navigationController?.popViewController(animated: true)
                }
            } else if code != 403 {
                UIAlertController.generalErrorAlert(self)
            }
            self.endRefresh()
        }
    }
    
    private func reloadView() {
        var list = [QDSectionData.init([
            QDCellData.init(cell: "type", data: package!.type.toString()),
            QDCellData.init(cell: "price", data: package!.price!.toString()),
            QDCellData.init(cell: "duration", data: package!.durationString()),
            QDCellData.init(cell: "specialty", data: package!.specialty.name)
        ], header: QDCellData.init(data: "Basic_information".localized))]
        for schedule in package.schedules! {
            list.append(
                QDSectionData.init([
                    QDCellData.init(cell: "weekday", data: MDTimeCell.Data.init("Monday".localized, timeRanges: schedule.monday)),
                    QDCellData.init(cell: "weekday", data: MDTimeCell.Data.init("Tuesday".localized, timeRanges: schedule.tuesday)),
                    QDCellData.init(cell: "weekday", data: MDTimeCell.Data.init("Wednesday".localized, timeRanges: schedule.wednesday)),
                    QDCellData.init(cell: "weekday", data: MDTimeCell.Data.init("Thursday".localized, timeRanges: schedule.thursday)),
                    QDCellData.init(cell: "weekday", data: MDTimeCell.Data.init("Friday".localized, timeRanges: schedule.friday)),
                    QDCellData.init(cell: "weekday", data: MDTimeCell.Data.init("Saturday".localized, timeRanges: schedule.saturday)),
                    QDCellData.init(cell: "weekday", data: MDTimeCell.Data.init("Sunday".localized, timeRanges: schedule.sunday))
                ], header: QDCellData.init(data: "\("Schedule".localized) (\("From".localized) \(schedule.duration!.from.toAppDateString()) \("To".localized) \(schedule.duration!.to.toAppDateString()))"))
            )
        }
        self.list = list
    }
    
}
