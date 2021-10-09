/*
 * Copyright © 2020 DUNGNGUYEN. All rights reserved.
 *
 * Created by DUNGNGUYEN on 19/12/31.
 */

import UIKit

protocol McsRefreshAccountVCProtocol : NSObjectProtocol {
    
    func refreshDidPressed(_ target: McsRefreshAccountViewController)
    
}

class McsRefreshAccountViewController: McsViewController {

    public weak var delegate: McsRefreshAccountVCProtocol?
    
    @IBOutlet weak var refreshButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func refreshButtonPressed(_ sender: Any) {
        delegate?.refreshDidPressed(self)
    }
    
    func startAnimation() {
        refreshButton.rotate("refresh")
        print("TODO: startAnimation")
    }
    
    func stopAnimation() {
        refreshButton.stopAnimation("refresh")
        print("TODO: stopAnimation")
    }
    
    class func create(_ delegate: McsRefreshAccountVCProtocol) -> McsRefreshAccountViewController {
        let result = UIStoryboard(name: "Other", bundle: nil).instantiateViewController(withIdentifier: "refreshAccountVC") as! McsRefreshAccountViewController
        result.delegate = delegate
        return result
    }
    
}
