/*
 * Copyright © 2020 DUNGNGUYEN. All rights reserved.
 *
 * Created by DUNGNGUYEN on 19/12/12.
 */

import UIKit
import QDCore
import CLLocalization

class McsBaseDatabase : NSObject {
    
    private let _tKey : String = "token"
    private let _storeCenter = UserDefaults(suiteName: String.bundleIdentifier + ".database")!
    private var _account : McsAccount? = nil
    private var _token : String? = nil
    private var _deviceToken : String? = nil
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override init() {
        super.init()
        _token = _storeCenter.string(forKey: _tKey)
        NotificationCenter.default.addObserver(self, selector: #selector(clear), name: expiredTokenNotification, object: nil)
    }

    var accountType: McsAccountType {
        get {
            return .patient
        }
    }
    
    var language: McsLanguage {
        get {
            return McsLanguage.init(rawValue: CLLocalization.language)!
        }
        set {
            CLLocalization.setLanguage(newValue.rawValue)
        }
    }
    
    var deviceToken: String? {
        get {
            return _deviceToken
        }
        set {
            _deviceToken = newValue
        }
    }
    
    var account: McsAccount? {
        get {
            return _account
        }
    }
    
    var token: String? {
        get {
            if _account != nil {
                return _token
            } else {
                return nil
            }
        }
    }
    
    var existedToken: String? {
        get {
            return _token
        }
    }
    
    func updateAccount(_ token : String) {
        _token = token
        _storeCenter.set(token, forKey: _tKey)
       _storeCenter.synchronize()
    }
    
    func updateAccount(_ account : McsAccount) {
        if _token != nil {
            _account = account
            NotificationCenter.default.post(name: accountInfoDidChangeNotification, object: nil)
        }
    }
    
    func setAccount(_ account : McsAccount) {
        if _token != nil {
            _account = account
            NotificationCenter.default.post(name: accountDidSetNotification, object: nil)
        }
    }
    
    func setAccount(_ account : McsAccount, token : String){
        _token = token
        _account = account
        _storeCenter.set(token, forKey: _tKey)
        NotificationCenter.default.post(name: accountDidSetNotification, object: nil)
        _storeCenter.synchronize()
    }
    
    @objc func clear() {
        NotificationCenter.default.post(name: accountWillLogoutNotification, object: nil)
        let shoudNotify = _token != nil
        _token = nil
        _account = nil
        _storeCenter.removeObject(forKey: _tKey)
        _storeCenter.synchronize()
        if shoudNotify {
            NotificationCenter.default.post(name: accountDidClearNotification, object: nil)
        }
    }
    
}


extension McsBaseDatabase {
    
    var currency : McsCurrency {
        get {
            return .vnd
        }
    }
    
}
