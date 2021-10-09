/*
 * Copyright © 2020 DUNGNGUYEN. All rights reserved.
 *
 * Created by DUNGNGUYEN on 19/12/30.
 */

import UIKit
import QDCore
import CLLocalization

class MPListAppointmentViewController: McsTableViewController {
    
    private var packageType: McsPackageType = .classic
    
    private let cellId = "appointmentCell"
    
    private let emptyCellId = "emptyCell"
    
    private var appointments: [McsAppointment]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setRefreshToScrollView(tableView)
        self.tableView.register(UINib(nibName: "MPAppointmentCell", bundle: nil), forCellReuseIdentifier: cellId)
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
    
    override func refresh() {
        if let token = McsDatabase.instance.token {
            let to = Date().dateByAdd(month: 3)!
            let from = Date().dateByAdd(month: -12)!
            McsPatientListAppointmentApi.init(token, type: packageType, statusTypes: nil, from: from, to: to).run() { (success, appointments, code) in
                if success {
                    self.appointments = appointments
                    self.reloadView()
                }
                self.endRefresh()
            }
        } else {
            endRefresh()
        }
    }
    
    func reloadView() {
        var list = [QDSectionData]()
        if let appointments = appointments, appointments.count > 0 {
            var cells = [QDCellData]()
            var historyCells = [QDCellData]()
            for appointment in appointments {
                if appointment.isActive {
                    cells.append(QDCellData.init("appointment", cell: self.cellId, data: appointment))
                } else {
                    historyCells.insert(QDCellData.init("appointment", cell: self.cellId, data: appointment), at: 0)
                }
            }
            if cells.count > 0 {
                list.append(QDSectionData.init(cells, header: QDCellData.init(data: "Waiting_examination".localized), footer: nil))
            }
            if historyCells.count > 0 {
                list.append(QDSectionData.init(historyCells, header: QDCellData.init(data: "History_appointment".localized), footer: nil))
            }
            tableView.separatorStyle = .singleLine
        } else {
            tableView.separatorStyle = .none
            list = [QDSectionData.init([QDCellData.init("empty", cell: self.emptyCellId, data: "No_appointment_patient_message".localized)])]
        }
        self.list = list
    }
    
    override func userDidTapCell(_ id: Any?, data: Any?) {
        super.userDidTapCell(id, data: data)
        if let id = id as? String {
            if id == "appointment" {
                let appointment = data as! McsAppointment
                McsProgressHUD.show(self)
                McsPatientAppointmentDetailApi.init(McsDatabase.instance.token!, id: appointment.id!).run() { (success, appointment, code) in
                    McsProgressHUD.hide(self)
                    if success {
                        self.performSegue(withIdentifier: "appointmentSegue", sender: appointment)
                    } else {
                        // Error description
                        // 403 Invalid/Expired token
                        // 404 Not found
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
            let vc = segue.destination as! MPAppointmentViewController
            vc.setup(sender as! McsAppointment)
        }
    }
    
}

