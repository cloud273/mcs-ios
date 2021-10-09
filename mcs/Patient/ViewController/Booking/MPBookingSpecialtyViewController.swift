/*
 * Copyright © 2020 DUNGNGUYEN. All rights reserved.
 *
 * Created by DUNGNGUYEN on 19/12/30.
 */

import UIKit
import QDCore
import CLLocalization

class MPSpecialtyCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func set(_ data: McsSpecialty) {
        imageView.setImageUrl(data.image, placeholder: specialtyIcon) 
        label.text = data.name
    }
    
}

class MPBookingSpecialtyViewController: McsViewController {
    
    private var specialties: [McsSpecialty]!
    private var appointment: McsAppointment!
    
    private let cellId = "cell"
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setRefreshToScrollView(collectionView)
        setupCollectionView()
        NotificationCenter.default.addObserver(self, selector: #selector(self.refresh), name: accountDidSetNotification, object: nil)
        reloadView()
    }
    
    func setup(_ specialties: [McsSpecialty], appointment: McsAppointment) {
        self.specialties = specialties
        self.appointment = appointment
    }
    
    private func setupCollectionView() {
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        var offset = min(self.view.bounds.size.width , self.view.bounds.size.height) / 8
        layout.sectionInset = UIEdgeInsets.init(top: offset, left: offset, bottom: offset, right: offset)
        offset = offset * 1.35
        layout.minimumInteritemSpacing = offset
        layout.minimumLineSpacing = offset
    }
    
    override func refresh() {
        McsPatientListSpecialtyApi.init(McsDatabase.instance.token!, symptoms: appointment.symptoms).run { (success, specialties, code) in
            if success {
                self.specialties = specialties!
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
        self.collectionView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "doctorSegue" {
            let vc = segue.destination as! MPBookingListDoctorViewController
            let obj = sender as! [Any]
            let doctors = obj[1] as! [McsDoctor]
            appointment.set(obj[0] as! String)
            vc.setup(doctors, appointment: appointment)
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension MPBookingSpecialtyViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        let column : CGFloat = 2
        let width = (collectionView.bounds.size.width - layout.sectionInset.left - layout.sectionInset.right - layout.minimumInteritemSpacing * (column - 1) ) / column
        let height = width + 30
        return CGSize.init(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return specialties.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MPSpecialtyCollectionCell
        cell.set(specialties[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let specialty = specialties[indexPath.row]
        McsProgressHUD.show(self)
        McsPatientListDoctorApi.init(McsDatabase.instance.token!, type: appointment.type!, specialtyCode: specialty.code).run() { (success, doctors, code) in
            McsProgressHUD.hide(self)
            if success {
                if doctors!.isEmpty {
                    self.refresh()
                    UIAlertController.show(self, title: nil, message: "No_doctor_available_message".localized, close: "Close".localized)
                } else {
                    self.performSegue(withIdentifier: "doctorSegue", sender: [specialty.code!, doctors!])
                }
            } else {
                if code != 403 {
                    UIAlertController.generalErrorAlert(self)
                }
            }
        }
    }
    
}
