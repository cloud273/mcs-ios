/*
* Copyright © 2020 DUNGNGUYEN. All rights reserved.
*
* Created by DUNGNGUYEN on 20/02/02.
*/

import UIKit
import QDCore
import ObjectMapper

class McsAppConfiguration: NSObject {
    
    public static let instance = McsAppConfiguration()
    
    private let _store = UserDefaults(suiteName: String.bundleIdentifier + ".application.configuration")!

    private let countryKey = "country"
    private let specialtyKey = "specialty"
    
    private var _countries: [McsCountry]!
    private var _specialties: [McsSpecialty]!
    
    private var _creatableEndKey = "creatableEnd"
    private var _acceptableEndKey = "acceptableEnd"
    private var _cancelableEndKey = "cancelableEnd"
    private var _rejectableEndKey = "rejectableEnd"
    private var _beginableFromKey = "beginableFrom"
    private var _beginableEndKey = "beginableEnd"
    private var _finishableEndKey = "finishableEnd"
    
    private override init() {
        super.init()
        _countries = load(countryKey)
        _specialties = load(specialtyKey)
        update { (success) in
            
        }
    }
    
    private func update(_ completion: @escaping (_ success: Bool) -> Void) {
        McsConfigApi.init().run { (success, countries, specialties, patientCancel, clinicReject, systemReject, creatableEnd, acceptableEnd, cancalableEnd, rejectableEnd, beginableFrom, beginableEnd, finishableEnd) in
            if success {
                if let countries = countries {
                    self._countries = countries
                    self.save(countries, key: self.countryKey)
                }
                if let specialties = specialties {
                    self._specialties = specialties
                    self.save(specialties, key: self.specialtyKey)
                }
                if let creatableEnd = creatableEnd {
                    self._store.set(creatableEnd, forKey: self._creatableEndKey)
                }
                if let acceptableEnd = acceptableEnd {
                    self._store.set(acceptableEnd, forKey: self._acceptableEndKey)
                }
                if let cancalableEnd = cancalableEnd {
                    self._store.set(cancalableEnd, forKey: self._cancelableEndKey)
                }
                if let rejectableEnd = rejectableEnd {
                    self._store.set(rejectableEnd, forKey: self._rejectableEndKey)
                }
                if let beginableFrom = beginableFrom {
                    self._store.set(beginableFrom, forKey: self._beginableFromKey)
                }
                if let beginableEnd = beginableEnd {
                    self._store.set(beginableEnd, forKey: self._beginableEndKey)
                }
                if let finishableEnd = finishableEnd {
                    self._store.set(finishableEnd, forKey: self._finishableEndKey)
                }
                self._store.synchronize()
            }
            completion(success)
        }
    }
    
    func creatableEnd() -> TimeInterval {
        let value = _store.double(forKey: _creatableEndKey)
        if value == 0 {
            return defaultCreatableEnd
        } else {
            return value
        }
    }
    
    func acceptableEnd() -> TimeInterval {
        let value = _store.double(forKey: _acceptableEndKey)
        if value == 0 {
            return defaultAcceptableEnd
        } else {
            return value
        }
    }
    
    func cancelableEnd() -> TimeInterval {
        let value = _store.double(forKey: _cancelableEndKey)
        if value == 0 {
            return defaultCancelableEnd
        } else {
            return value
        }
    }
    
    func rejectableEnd() -> TimeInterval {
        let value = _store.double(forKey: _rejectableEndKey)
        if value == 0 {
            return defaultRejectableEnd
        } else {
            return value
        }
    }
    
    func beginableFrom() -> TimeInterval {
        let value = _store.double(forKey: _beginableFromKey)
        if value == 0 {
            return defaultBeginableFrom
        } else {
            return value
        }
    }
    
    func beginableEnd() -> TimeInterval {
        let value = _store.double(forKey: _beginableEndKey)
        if value == 0 {
            return defaultBeginableEnd
        } else {
            return value
        }
    }
    
    func finishableEnd() -> TimeInterval {
        let value = _store.double(forKey: _finishableEndKey)
        if value == 0 {
            return defaultFinishableEnd
        } else {
            return value
        }
    }
    
    func specialties() -> [McsSpecialty] {
        return _specialties
    }
    
    func specialty(_ code: String) -> McsSpecialty? {
        return _specialties.first { (obj) -> Bool in
            return obj.code == code
        }
    }
    
    func countries() -> [McsCountry] {
        return _countries
    }
    
    func country(_ code: String) -> McsCountry? {
        return _countries.first { (obj) -> Bool in
            return obj.code == code
        }
    }
    
    func states(_ countryCode: String) -> [McsState]? {
        for country in _countries {
            if country.code == countryCode {
                return country.states
            }
        }
        return nil
    }
    
    func state(_ code: String) -> McsState? {
        for country in _countries {
            for state in country.states {
                if state.code == code {
                    return state
                }
            }
        }
        return nil
    }
    
    func cities(_ stateCode: String) -> [McsCity]? {
        for country in _countries {
            for state in country.states {
                if state.code == stateCode {
                    return state.cities
                }
            }
        }
        return nil
    }
    
    func city(_ code: String) -> McsCity? {
        for country in _countries {
            for state in country.states {
                for city in state.cities {
                    if city.code == code {
                        return city
                    }
                }
            }
        }
        return nil
    }
    
}

extension McsAppConfiguration {
    
    private func save<T: McsMappable>(_ objs: [T], key: String) {
        var array = [[String: Any]]()
        for obj in objs {
            array.append(obj.toJSON())
        }
        _store.set(array, forKey: key)
    }
    
    private func load<T: McsMappable>(_ key: String) -> [T] {
        var array = _store.array(forKey: key) as? [[String: Any]]
        if array == nil {
            array = (NSObject.loadJsonBundle(key, aClass: McsAppConfiguration.self) as! [[String: Any]])
        }
        var result = [T]()
        for item in array! {
            if let obj = T.init(JSON: item) {
                result.append(obj)
            }
        }
        return result
    }
    
}
