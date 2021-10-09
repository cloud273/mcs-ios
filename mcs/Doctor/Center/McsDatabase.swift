/*
 * Copyright © 2020 DUNGNGUYEN. All rights reserved.
 *
 * Created by DUNGNGUYEN on 20/01/04.
 */

import UIKit

class McsDatabase : McsBaseDatabase {
    
    static let instance = McsDatabase()
    
    private var _clinic : McsClinic? = nil
    
    override var accountType: McsAccountType {
        get {
            return .doctor
        }
    }
    
    var clinic: McsClinic? {
        get {
            return _clinic
        }
        set {
            _clinic = newValue
        }
    }
    
    func setAccount(_ account : McsDoctor, clinic: McsClinic, token : String) {
        _clinic = clinic
        super.setAccount(account, token: token)
    }
    
    func setAccount(_ account : McsDoctor, clinic: McsClinic) {
        _clinic = clinic
        super.setAccount(account)
    }
    
    func updateAccount(_ account : McsDoctor, clinic: McsClinic) {
        _clinic = clinic
        super.updateAccount(account)
    }
    
    
    override func setAccount(_ account : McsAccount) {
        fatalError("Do not call this method")
    }
    
    override func setAccount(_ account : McsAccount, token : String){
        fatalError("Do not call this method")
    }
    
    override func clear() {
        _clinic = nil
        super.clear()
    }
    
}
