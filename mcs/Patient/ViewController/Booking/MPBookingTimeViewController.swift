/*
 * Copyright © 2020 DUNGNGUYEN. All rights reserved.
 *
 * Created by DUNGNGUYEN on 19/12/12.
 */

import UIKit
import QDCore
import CLLocalization
import FSCalendar

class MPBookingTimeViewController: McsBaseCalendarViewController {
    
    class MPBookingTimeHelper {

        fileprivate class Day {
            var workings: [McsWorkingTime]
            var date: Date
            init(_ workings: [McsWorkingTime], date: Date) {
                self.workings = workings
                self.date = date
            }
        }

        fileprivate class Time: NSObject {
            var working: McsWorkingTime
            var time: Date
            init(_ working: McsWorkingTime, time: Date) {
                self.working = working
                self.time = time
            }
        }

        private var packageId: Int

        fileprivate var selectDay: Day?
        fileprivate var selectTime: Time?

        fileprivate var days: [Day]?
        fileprivate var times: [[Time]]?
        
        fileprivate var min: Date?
        fileprivate var max: Date?

        init(_ packageId: Int) {
            self.packageId = packageId
        }

        func isValid() -> Bool {
            return selectDay != nil && selectTime != nil
        }
        
        private func getFrom() -> Date {
            return Date().addingTimeInterval(-McsAppConfiguration.instance.creatableEnd())
        }
        
        func refresh(_ completion: @escaping (_ code: Int) -> Void) {
            let from = getFrom()
            let to = from.dateByAdd(month: 1)!
            if let token = McsDatabase.instance.token {
                McsPatientListWorkingTimeApi.init(token, packageId: packageId, from: from, to: to).run() { (success, workingTimes, code) in
                    if success {
                        var list = [Day]()
                        if let wts = workingTimes {
                            for wt in wts {
                                var found = false
                                for item in list {
                                    if wt.begin.isSameDayAs(item.date) {
                                        item.workings.append(wt)
                                        found = true
                                        break
                                    }
                                }
                                if !found {
                                    list.append(Day.init([wt], date: wt.begin))
                                }
                            }
                        }
                        self.days = list
                        self.processDay()
                        self.reloadTime(completion)
                    } else {
                        completion(code)
                    }
                }
            } else {
                completion(403)
            }
        }

        private func processDay() {
            var min: Date?
            var max: Date?
            var selectDay: Day?
            if let days = days {
                for day in days {
                    let date = day.date
                    if min == nil || min! > date {
                        min = date
                    }
                    if max == nil || max! < date {
                        max = date
                    }
                }
                if let sel = selectDay {
                    for day in days {
                        if day.date.isSameDayAs(sel.date) {
                            selectDay = day
                            break
                        }
                    }
                }
                if selectDay == nil {
                    selectDay = days.first
                }
            }
            self.min = min
            self.max = max
            self.selectDay = selectDay
        }

        fileprivate func reloadTime(_ completion: @escaping (_ code: Int) -> Void) {
            if let day = selectDay {
                if let token = McsDatabase.instance.token {
                    let group = DispatchGroup.init()
                    var list = [[Time]]()
                    var apiCode = 200
                    let from = getFrom()
                    for wt in day.workings {
                        group.enter()
                        McsPatientListBookingTimeApi.init(token, packageId: packageId, from: wt.begin, to: wt.end).run() { (success, bookingTimes, code) in
                            if success {
                                if let array = bookingTimes, array.count > 0 {
                                    var tmp = [Time]()
                                    for time in array {
                                        if let time = Date.dateApiDateTimeFormat(time) {
                                            if time >= from {
                                                tmp.append(Time.init(wt, time: time))
                                            }
                                        }
                                    }
                                    list.append(tmp)
                                }
                            } else {
                                if apiCode == 200 {
                                    apiCode = code
                                }
                            }
                            group.leave()
                        }
                    }
                    group.notify(queue: DispatchQueue.main) {
                        self.times = list.sorted(by: { (obj1, obj2) -> Bool in
                            return obj1.first!.time < obj2.first!.time
                        })
                        if let sel = self.selectTime {
                            self.selectTime = nil
                            for objs in list {
                                for obj in objs {
                                    if obj.time == sel.time {
                                        self.selectTime = obj
                                        break
                                    }
                                }
                                if self.selectTime != nil {
                                    break
                                }
                            }
                        }
                        if self.selectTime == nil {
                            self.selectTime = self.times?.first?.first
                        }
                        completion(apiCode)
                    }
                } else {
                    completion(403)
                }
            } else {
                times = nil
                selectTime = nil
                completion(200)
            }
        }

    }
    
    private var doctor: McsDoctor!
    private var appointment: McsAppointment!
    private var helper: MPBookingTimeHelper!
    
    @IBOutlet private weak var continueButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadChooseButton()
        reloadView()
    }
    
    func setup(_ helper: MPBookingTimeHelper, doctor: McsDoctor, appointment: McsAppointment) {
        self.doctor = doctor
        self.appointment = appointment
        self.helper = helper
    }
    
    override func refresh() {
        helper.refresh { code in
            if code == 200 {
                self.reloadView()
            } else if code == 404 {
                UIAlertController.show(self, title: nil, message: "Unavailable_doctor_message".localized, close: "Close".localized) {
                    let vc = self.navigationController!.viewControllers[max(self.navigationController!.viewControllers.count - 3, 0)]
                    self.navigationController?.popToViewController(vc, animated: true)
                }
            }
            self.endRefresh()
        }
    }
    
    private func reloadView() {
        setCalendarDates(helper.min?.beginDate(), maxDate: helper.max?.endDate())
        self.calendar.reloadData()
        reloadTimeView()
    }
    
    private func reloadTimeView() {
        let dates = self.calendar.selectedDates
        for date in dates {
            self.calendar.deselect(date)
        }
        if let day = helper.selectDay {
            self.calendar.select(day.date)
        }

        self.collectionView.reloadData()
        self.reloadChooseButton()
    }
    
    
    private func reloadChooseButton() {
        if helper.selectTime == nil {
            continueButton.isEnabled = false
            continueButton.wBgColor = "lightgray-color"
        } else {
            continueButton.isEnabled = true
            continueButton.wBgColor = "blue-color"
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func continueButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "summarySegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "summarySegue" {
            let vc = segue.destination as! MPBookingSummaryViewController
            appointment.set(helper.selectTime!.time)
            vc.setup(doctor, appointment: appointment)
        }
    }
    
    override func numberOfCollectionCoumn() -> CGFloat {
        return 3
    }
    
}

extension MPBookingTimeViewController : UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return helper.times?.count ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return helper.times![section].count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        let time = helper.times![indexPath.section][indexPath.row]
        let label = cell.viewWithTag(1) as! UILabel
        label.text = time.time.toAppTimeString()
        if let sel = helper.selectTime, time == sel {
            label.textColor = .white
            label.wBgColor = "blue-color"
        } else {
            label.textColor = .black
            label.backgroundColor = .clear
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        helper.selectTime = helper.times![indexPath.section][indexPath.row]
        collectionView.reloadData()
        self.reloadChooseButton()
    }
    
}

extension MPBookingTimeViewController {

    private func numberEvent(_ date: Date) -> Int {
        var result: Int = 0
        if let days = helper.days {
            for day in days {
                if (day.date.isSameDayAs(date)) {
                    result = day.workings.count
                    break
                }
            }
        }
        return result

    }
    
    private func selectable(_ date: Date) -> Bool {
        if let days = helper.days {
            for day in days {
                if (day.date.isSameDayAs(date)) {
                    return true
                }
            }
        }
        return false
    }
    
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
        if monthPosition == .current {
            if calendar.selectedDate != date {
                if selectable(date) {
                    cell.titleLabel.textColor = .black
                } else {
                    cell.titleLabel.textColor = .lightGray
                }
            } else {
                cell.titleLabel.textColor = .white
            }
        }
    }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        let result = selectable(date)
        if result && monthPosition != .current {
            calendar.setCurrentPage(date, animated: true)
        }
        return result
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if let days = helper.days {
            for day in days {
                if (day.date.isSameDayAs(date)) {
                    helper.selectDay = day
                    break
                }
            }
        }
        McsProgressHUD.show(self)
        helper.reloadTime {_ in
            McsProgressHUD.hide(self)
            self.reloadTimeView()
        }
    }
    
}
