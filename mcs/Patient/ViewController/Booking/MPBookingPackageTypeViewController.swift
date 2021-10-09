/*
 * Copyright © 2020 DUNGNGUYEN. All rights reserved.
 *
 * Created by DUNGNGUYEN on 20/02/21.
 */

import UIKit
import QDCore
import CLLocalization

class MPBookingPackageTypeViewController: McsViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func classBookingButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "classicSegue", sender: nil)
    }
    
    @IBAction func telemedicineButtonPressed(_ sender: Any) {
        UIAlertController.show(self, title: "Coming_soon".localized, message: nil, close: "Close".localized)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "classicSegue" {
            let vc = (segue.destination as! McsNavigationController).viewControllers[0] as! MPBookingSymptomViewController
            vc.setup(McsAppointment.create(.classic))
        }
    }
    
}
