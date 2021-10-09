/*
* Copyright © 2020 DUNGNGUYEN. All rights reserved.
*
* Created by DUNGNGUYEN on 20/03/11.
*/

import UIKit

class McsApnsService: NSObject {
    
    static let instance = McsApnsService()
    
    func registerDeviceTokenIfNeed() {
        let db = McsDatabase.instance
        if let token = db.token, db.account != nil {
            McsAccountDeviceSetApi.init(McsDatabase.instance.accountType, userToken: token, deviceToken: db.deviceToken).run() { (_, _) in
                
            }
        }
    }
    
    func clearDeviceTokenIfNeed() {
        let db = McsDatabase.instance
        if let token = db.token {
            McsAccountDeviceSetApi.init(McsDatabase.instance.accountType, userToken: token, deviceToken: nil).run() { (_, _) in
                
            }
        }
    }
    
    func registerRemoteNotification() {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
            UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert], completionHandler: { granted, error in
                if granted {
                    UNUserNotificationCenter.current().getNotificationSettings { (settings) in
                        if (settings.authorizationStatus == .authorized) {
                            DispatchQueue.main.async {
                                UIApplication.shared.registerForRemoteNotifications()
                            }
                        } else {
                            DispatchQueue.main.async {
                                McsDatabase.instance.deviceToken = nil
                                self.registerDeviceTokenIfNeed()
                            }
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        McsDatabase.instance.deviceToken = nil
                        self.registerDeviceTokenIfNeed()
                    }
                }
            })
        } else {
            let type: UIUserNotificationType = [.badge, .alert, .sound]
            let setting = UIUserNotificationSettings(types: type, categories: nil)
            UIApplication.shared.registerUserNotificationSettings(setting)
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    func action(_ userInfo: [AnyHashable : Any], completion: @escaping (UIBackgroundFetchResult) -> Void) {
        print(userInfo)
        completion(.noData)
    }
    
}

extension McsApnsService: UNUserNotificationCenterDelegate {
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        action(userInfo) { (_) in
            completionHandler()
        }
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("willPresent")
        completionHandler([.alert, .badge, .sound])
    }
    
}
