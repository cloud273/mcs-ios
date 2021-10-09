/*
 * Copyright © 2020 DUNGNGUYEN. All rights reserved.
 *
 * Created by DUNGNGUYEN on 19/12/30.
 */

import UIKit
import QDCore
import CLLocalization

class MPBookingListDoctorViewController: McsTableViewController {
    
    private var doctors: [McsDoctor]!
    private var appointment: McsAppointment!
    
    private let doctorCellId = "doctorCell"
    private let emptyCellId = "emptyCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setRefreshToScrollView(tableView)
        self.tableView.register(UINib(nibName: "MPDoctorCell", bundle: nil), forCellReuseIdentifier: doctorCellId)
        self.tableView.register(UINib(nibName: "McsTextEmptyMessageCell", bundle: nil), forCellReuseIdentifier: emptyCellId)
        NotificationCenter.default.addObserver(self, selector: #selector(self.refresh), name: accountDidSetNotification, object: nil)
        reloadView()
    }
    
    func setup(_ doctors: [McsDoctor], appointment: McsAppointment) {
        self.doctors = doctors
        self.appointment = appointment
    }
    
    private func reloadView() {
        var cells = [QDCellData]()
        if doctors.count > 0 {
            for doctor in doctors {
                cells.append(QDCellData.init("doctor", cell: self.doctorCellId, data: MPDoctorCell.Data.init(specialty: appointment.specialty, doctor: doctor)))
            }
            self.tableView.separatorStyle = .singleLine
        } else {
            self.tableView.separatorStyle = .none
            cells.append(QDCellData.init(cell: self.emptyCellId, data: "No_doctor_available_and_refresh_message".localized))
        }
        self.list = [
            QDSectionData(cells)
        ]
    }
    
    override func refresh() {
        McsPatientListDoctorApi.init(McsDatabase.instance.token!, type: appointment.type, specialtyCode: appointment.specialtyCode).run() { (success, doctors, code) in
            if success {
                self.doctors = doctors!
                self.reloadView()
            }
            self.endRefresh()
        }
    }
    
    override func userDidTapCell(_ id: Any?, data: Any?) {
        super.userDidTapCell(id, data: data)
        if let id = id as? String, id == "doctor" {
            let obj = data as! MPDoctorCell.Data
            McsProgressHUD.show(self)
            // Error description
            // 403 Invalid/Expired token
            // 404 Not found doctorId
            McsPatientDoctorDetailApi.init(McsDatabase.instance.token!, id: obj.doctor.id!, type: appointment.type, specialtyCode: appointment.specialtyCode).run() { (success, doctor, code) in
                McsProgressHUD.hide(self)
                if success {
                    self.performSegue(withIdentifier: "doctorSegue", sender: doctor!)
                } else {
                    if code == 404 {
                        self.refresh()
                        UIAlertController.show(self, title: "Error".localized, message: "Not_found".localized, close: "Close".localized)
                    } else if code != 403 {
                        UIAlertController.generalErrorAlert(self)
                    }
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "doctorSegue" {
            let vc = segue.destination as! MPBookingDoctorViewController
            vc.setup(sender as! McsDoctor, appointment: appointment)
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

