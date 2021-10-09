/*
 * Copyright © 2020 DUNGNGUYEN. All rights reserved.
 *
 * Created by DUNGNGUYEN on 20/03/11.
 */

import UIKit
import QDCore
import FSCalendar
import ObjectMapper

class MDWorkingTimeHelper {
    
    static func reload(_ completion: @escaping (_ success: Bool,_ from: Date,_ to: Date ,_ workingTime: [MDWorkingTime]?,_ packages: [McsPackage]?, _ expired: Bool) -> Void) {
        let from = Date().beginDate()
        let to = Date().dateByAdd(month: 2)!.endDayOfThisMonth().endDate()
        let token = McsDatabase.instance.token!
        var workingTimes: [McsWorkingTime]?
        var packages: [McsPackage]?
        var fSuccess: Bool = true
        var fExpired: Bool = false
        let group = DispatchGroup.init()
        group.enter()
        McsDoctorListWorkingTimeApi.init(token, from: from, to: to).run() { (success, list, code) in
            fSuccess = fSuccess && success
            fExpired = fExpired || code == 403
            workingTimes = list
            group.leave()
        }
        group.enter()
        McsDoctorListPackageApi.init(token).run { (success, list, code) in
            fSuccess = fSuccess && success
            fExpired = fExpired || code == 403
            packages = list
            group.leave()
        }
        group.notify(queue: .main) {
            if fSuccess {
                var list = [MDWorkingTime]()
                for workingTime in workingTimes! {
                    if let wt = MDWorkingTime.init(workingTime, packages: packages!) {
                        list.append(wt)
                    }
                }
                completion(fSuccess, from, to, list, packages!, fExpired)
            } else {
                completion(fSuccess, from, to, nil, nil, fExpired)
            }
        }
    }
}

class MDWorkingTime: McsWorkingTime {
    
    var package: McsPackage!
    var isMultiPackage: Bool!
    
    init?(_ workingTime: McsWorkingTime, packages: [McsPackage]) {
        let package = packages.first { (pk) -> Bool in
            return pk.id == workingTime.packageId
        }
        if let package = package {
            super.init()
            self.begin = workingTime.begin
            self.end = workingTime.end
            self.visitTime = workingTime.visitTime
            self.packageId = workingTime.packageId
            self.scheduleId = workingTime.scheduleId
            self.workingDayId = workingTime.workingDayId
            self.package = package
            self.isMultiPackage = packages.count > 1
        } else {
            return nil
        }
    }
    
    required init?(map: Map) {
        fatalError("init(map:) has not been implemented")
    }
    
}

class WorkingTimeCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var label: UILabel!
    
    func setData(_ data: MDWorkingTime) {
        var text = "\("From".localized) " + data.begin.toAppTimeString() + " \("to".localized) " + data.end.toAppTimeString()
        if data.isMultiPackage {
            text.append(" (\(data.package.type.toString()))")
        }
        label.text = text
    }
    
}

class MDScheduleViewController: McsBaseCalendarViewController {

    @IBOutlet weak var scheduleLabel: UILabel!
    
    private var workingTimes: [MDWorkingTime]!
    
    private var packages: [McsPackage]!
    
    private var selectedWorkingTimes = [MDWorkingTime]()
    
    private var from: Date!
    
    private var to: Date!
    
    override func loadView() {
        super.loadView()
        scheduleLabel.text = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: scheduleDidUpdatedNotification, object: nil)
        reloadView()
    }
    
    func setup(_ workingTimes: [MDWorkingTime], packages: [McsPackage], from: Date, to: Date) {
        self.workingTimes = workingTimes
        self.packages = packages
        self.from = from
        self.to = to
    }
    
    override func setupCalendar() {
        super.setupCalendar()
        let min = from.beginDate()
        let max = to.endDate()
        self.setCalendarDates(min, maxDate: max)
        let today = Date()
        if today < min {
            calendar.select(min)
        } else if today > max {
            calendar.select(max)
        } else {
            calendar.select(today)
        }
    }
    
    @objc
    override func refresh() {
        MDWorkingTimeHelper.reload { (success, from, to, workingTimes, pacakges, expired) in
            if success {
                self.setup(workingTimes!, packages: pacakges!, from: from, to: to)
                self.reloadView()
            }
            self.endRefresh()
        }
    }
    
    private func reloadView() {
        self.calendar.reloadData()
        self.reloadBookingTime()
    }
    
    private func reloadBookingTime() {
        if let selectedDate = calendar.selectedDate {
            var array = [MDWorkingTime]()
            for wT in workingTimes! {
                if calendar.gregorian.isDate(wT.begin, inSameDayAs: selectedDate) {
                    array.append(wT)
                }
            }
            self.selectedWorkingTimes = array
            if array.count > 0 {
                scheduleLabel.text = "\("Schedule_on".localized) \(calendar.selectedDate!.toAppDateString())"
            } else {
                scheduleLabel.text = "\("No_schedule".localized) \(calendar.selectedDate!.toAppDateString())"
            }
        } else {
            self.selectedWorkingTimes = []
            scheduleLabel.text = ""
        }
        self.collectionView.reloadData()
    }
    
    override func heightOfCollectionCell(_ width: CGFloat) -> CGFloat {
        return 35
    }
    
    override func numberOfCollectionCoumn() -> CGFloat {
        return 1
    }
    
}

extension MDScheduleViewController: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.selectedWorkingTimes.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! WorkingTimeCollectionCell
        let workingTime = self.selectedWorkingTimes[indexPath.row]
        cell.setData(workingTime)
        return cell
    }
    
}

extension MDScheduleViewController {
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        var result = 0
        if let workingTimes = workingTimes {
            for wT in workingTimes {
                if calendar.gregorian.isDate(wT.begin, inSameDayAs: date) {
                    result += 1
                }
            }
        }
        return result
    }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        if monthPosition != .current {
            calendar.setCurrentPage(date, animated: true)
        }
        return true
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.reloadBookingTime()
    }
    
}
