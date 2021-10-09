/*
 * Copyright © 2020 DUNGNGUYEN. All rights reserved.
 *
 * Created by DUNGNGUYEN on 19/12/30.
 */

import UIKit
import QDCore

class MDListAppointmentViewController: McsTableViewController {
    
    private var packageType: McsPackageType = .classic
    
    private let cellId = "appointmentCell"
    
    private let emptyCellId = "emptyCell"
    
    private var appointments: [McsAppointment]?
    
    @IBOutlet weak var filterSegmentControl: UISegmentedControl?
    
    override func loadView() {
        super.loadView()
        filterSegmentControl?.setSegments(titles: ["Today".localized, "All".localized])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setRefreshToScrollView(tableView)
        self.tableView.register(UINib(nibName: "MDAppointmentCell", bundle: nil), forCellReuseIdentifier: cellId)
        self.tableView.register(UINib(nibName: "McsTextEmptyMessageCell", bundle: nil), forCellReuseIdentifier: emptyCellId)
        NotificationCenter.default.addObserver(self, selector: #selector(self.reset), name: accountDidSetNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.refresh), name: appointmentDidUpdatedNotification, object: nil)
        refresh()
    }
    
    @objc func reset() {
        appointments = nil
        reloadView()
        refresh()
    }
    
    func getAppointments(_ completion: @escaping (_ success: Bool, _ data: [McsAppointment]?) -> Void) {
        if let token = McsDatabase.instance.token {
            QDGlobalTime.instance.getDate { (today) in
                if let today = today {
                    let to = today.dateByAdd(month: 1)!
                    let from = today.addingTimeInterval(McsAppConfiguration.instance.beginableFrom())
                    McsDoctorListAppointmentApi.init(token, type: self.packageType, statusTypes: [.accepted, .started], from: from, to: to).run() { (success, appointments, code) in
                        completion(success, appointments)
                    }
                } else {
                    UIAlertController.generalErrorAlert(self)
                }
            }
        } else {
            completion(false, nil)
        }
    }
    
    override func refresh() {
        getAppointments { (success, appointments) in
            if success {
                self.appointments = appointments
                self.reloadView()
            }
            self.endRefresh()
        }
    }
    
    func reloadView() {
        var list = [QDSectionData]()
        let isAll = filterSegmentControl == nil || filterSegmentControl!.selectedSegmentIndex == 1
        var cells = [QDCellData]()
        if let appointments = appointments, appointments.count > 0 {
            for appointment in appointments {
                if isAll || appointment.isToday {
                    cells.append(QDCellData.init("appointment", cell: self.cellId, data: appointment))
                }
            }
        }
        if cells.count > 0 {
            list.append(QDSectionData.init(cells))
            tableView.separatorStyle = .singleLine
        } else {
            tableView.separatorStyle = .none
            if isAll {
                list = [QDSectionData.init([QDCellData.init("empty", cell: self.emptyCellId, data: "No_appointment_doctor_message".localized)])]
            } else {
                list = [QDSectionData.init([QDCellData.init("empty", cell: self.emptyCellId, data: "No_appointment_today_doctor_message".localized)])]
            }
        }
        self.list = list
    }
    
    override func userDidTapCell(_ id: Any?, data: Any?) {
        super.userDidTapCell(id, data: data)
        if let id = id as? String {
            if id == "appointment" {
                let appointment = data as! McsAppointment
                McsProgressHUD.show(self)
                McsDoctorAppointmentDetailApi.init(McsDatabase.instance.token!, id: appointment.id!).run() { (success, appointment, code) in
                    McsProgressHUD.hide(self)
                    if success {
                        if appointment!.finishable! {
                            self.performSegue(withIdentifier: "prescriptionSegue", sender: appointment)
                        } else {
                            self.performSegue(withIdentifier: "appointmentSegue", sender: appointment)
                        }
                    } else {
                        if code == 404 {
                            self.refresh()
                            UIAlertController.show(self, title: "Error".localized, message: "Not_found_appointment_message".localized, close: "Close".localized)
                        } else if code != 403 {
                            UIAlertController.generalErrorAlert(self)
                        }
                    }
                }
            } else if id == "empty" {
                self.tabBarController?.selectedIndex = 0
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "appointmentSegue" {
            let vc = segue.destination as! MDAppointmentViewController
            vc.setup(sender as! McsAppointment) 
        } else if segue.identifier == "prescriptionSegue" {
            let vc = segue.destination as! MDPrescriptionViewController
            vc.setup(sender as! McsAppointment)
        }
    }
    
    @IBAction func filterSegmentChanged(_ sender: Any) {
        reloadView()
    }
}

