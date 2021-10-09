/*
 * Copyright © 2020 DUNGNGUYEN. All rights reserved.
 *
 * Created by DUNGNGUYEN on 19/12/12.
 */

import UIKit
import UserNotifications
import IQKeyboardManagerSwift
import QDCore
import CLLocalization

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.shared.enable = true
        QDGlobalTime.instance.reload()
        CLLocalization.initialize(["vi", "en"])
        _ = McsDatabase.instance // call this to initialize database
        _ = McsAppConfiguration.instance
        
        McsApnsService.instance.registerRemoteNotification()
        if let userInfo = launchOptions?[.remoteNotification] as? [AnyHashable: Any] {
            McsApnsService.instance.action(userInfo) { (_) in
                
            }
        }
        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        let token = tokenParts.joined()
        McsDatabase.instance.deviceToken = token
        McsApnsService.instance.registerDeviceTokenIfNeed()
        print("didRegisterForRemoteNotificationsWithDeviceToken \(token)")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        McsDatabase.instance.deviceToken = nil
        McsApnsService.instance.registerDeviceTokenIfNeed()
        print("didFailToRegisterForRemoteNotificationsWithError \(error)")
    }

    /*
    // Add "remote-notification" to the list of your supported UIBackgroundModes in your Info.plist.
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        action(userInfo, completion: completionHandler)
    }
    */
    
}

