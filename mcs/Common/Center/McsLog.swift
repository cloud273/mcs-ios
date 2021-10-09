/*
 * Copyright © 2020 DUNGNGUYEN. All rights reserved.
 *
 * Created by DUNGNGUYEN on 19/12/12.
 */

import Foundation
import QDCore

private let isEnable = true

private var _log: QDLog?

var log: QDLog? {
    if isEnable {
        if _log == nil {
            _log = QDLog.init("Application", format: "json", showConsole: true, length: 1000)
        }
        return _log
    } else {
        return nil
    }
}

private var _apiLog: QDLog?
var apiLog: QDLog? {
    get {
        if isEnable {
            if _apiLog == nil {
                _apiLog = QDLog.init("Http", format: "json", showConsole: true, length: 1000)
            }
            return _apiLog
        } else {
            return nil
        }
    }
}

func Log(_ data: Any?) {
    if let log = log, let data = data {
        log.add(String.init(format: "%@", data as! CVarArg))
    }
}

func Debug(_ data: Any) {
    print(Date().toAppDateTimeString() + " - " +  String.init(format: "%@", data as! CVarArg))
}



