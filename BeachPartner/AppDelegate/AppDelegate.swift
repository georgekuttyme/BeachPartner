//
//  AppDelegate.swift
//  BeachPartner
//
//  Created by Jerry K Mathew on 22/02/18.
//  Copyright © 2018 dev. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    static var shared: AppDelegate { return UIApplication.shared.delegate as! AppDelegate }


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        UIApplication.shared.statusBarView?.backgroundColor = UIColor(red: 56.0/255.0, green: 68.0/255.0, blue: 134.0/255.0, alpha: 1.0)
        let attributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes(attributes, for: .normal)
        
        let barButtonItemAppearance = UIBarButtonItem.appearance()
        barButtonItemAppearance.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.clear], for: .normal)
        
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
        UINavigationBar.appearance().barTintColor = UIColor(red: 32.0/255.0, green: 48.0/255.0, blue: 127.0/255.0, alpha: 1.0)

        FirebaseApp.configure()
        application.registerForRemoteNotifications()
        Messaging.messaging().delegate = self
        Messaging.messaging().shouldEstablishDirectChannel = true
        requestNotificationAuthorization(application: application)
        if let userInfo = launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] {
            NSLog("[RemoteNotification] applicationState: \(applicationStateString) didFinishLaunchingWithOptions for iOS9: \(userInfo)")
            //TODO: Handle background notification
        }
        if Messaging.messaging().fcmToken != nil {
            configureTopicSubscriptions()
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func registerForPushNotifications() {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
                (granted, error) in
                print("Permission granted: \(granted)")
            }
            UNUserNotificationCenter.current().getNotificationSettings(){ (settings) in
                
                switch settings.soundSetting{
                case .enabled:
                    
                    print("enabled sound setting")
                    
                case .disabled:
                    
                    print("setting has been disabled")
                    
                case .notSupported:
                    print("something vital went wrong here")
                }
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    var applicationStateString: String {
        if UIApplication.shared.applicationState == .active {
            return "active"
        } else if UIApplication.shared.applicationState == .background {
            return "background"
        }else {
            return "inactive"
        }
    }
    

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        UserDefaults.standard.set(fcmToken, forKey: "FCM_TOKEN")
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        NSLog("[RemoteNotification] applicationState: \(applicationStateString) didReceiveRemoteNotification for iOS9: \(userInfo)")
        if UIApplication.shared.applicationState == .active {
            //TODO: Handle foreground notification
        } else {
            //TODO: Handle background notification
        }
        
        // Print full message.
        print(userInfo)
    }


}
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    // iOS10+, called when presenting notification in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        let pushUserId = userInfo["gcm.notification.user_id"] ?? ""
        let pushEventId = userInfo["gcm.notification.event_id"] ?? ""
        let currentUserId = UserDefaults.standard.string(forKey: "bP_userId") ?? ""
        NSLog("[UserNotificationCenter] applicationState: \(applicationStateString) willPresentNotification: \(userInfo): \(String(describing: pushUserId))  -- \(pushUserId) ** \(currentUserId)  //  \(pushEventId)  ++ \(String(describing: pushEventId))")
        
        if String(describing: pushUserId) == currentUserId{
            completionHandler([.alert, .sound])
        }else{
            
        }
        //TODO: Handle foreground notification
        
        
    }
    
    
    // iOS10+, called when received response (default open, dismiss or custom action) for a notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        let pushEventId = userInfo["gcm.notification.event_id"] ?? ""
        NSLog("[UserNotificationCenter] applicationState: \(applicationStateString) didReceiveResponse: \(userInfo)   \(pushEventId)")
        
        if let aps = userInfo["aps"] as? NSDictionary {
            if let category = aps["category"] as? String {
                print(category,"")
                let eventId:[String: String
                    ] = ["eventID": String(describing: pushEventId)]
                if category == "HIFI"{
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "foreground-pushNotification"), object: nil)
                    print("&&&&&&&&")
                }
                else if category == "INVITATION"{
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HOME-pushNotification"), object: nil,userInfo:eventId)
                    print("*********")
                }
                else if category == "ACTIVE"{
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ACTIVE-pushNotification"), object: nil)
                    print("---------")
                }
                
            }
        }
        
        
        //TODO: Handle background notification
        
        completionHandler()
    }
    
}

// MARK: -- Notifications

extension AppDelegate : MessagingDelegate {
    func configureTopicSubscriptions() {
        //        Messaging.messaging().subscribe(toTopic: "/topics/condition1")
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        Auth.auth().apnsToken = deviceToken
        Messaging.messaging().apnsToken = deviceToken
        
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        
        let token = tokenParts.joined()
        print("Device Token: \(token)")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for remote notification")
    }
    
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Swift.Void) {
        print("did receive remote notification")
        print(userInfo)
        if(application.applicationState == UIApplicationState.inactive) {
            print("Inactive")
        } else if (application.applicationState == UIApplicationState.background) {
            print("Background")
        } else {
            print("Active")
        }
        Messaging.messaging().appDidReceiveMessage(userInfo)
        completionHandler(.newData)
    }
    
    func requestNotificationAuthorization(application: UIApplication) {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        let token = Messaging.messaging().fcmToken
        print("FCM token: <<\(token ?? "")>>")
        configureTopicSubscriptions()
    }
    
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        print("FCM token (refresh): \(fcmToken)")
        configureTopicSubscriptions()
    }
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        guard let data =
            try? JSONSerialization.data(withJSONObject: remoteMessage.appData, options: .prettyPrinted),
            let prettyPrinted = String(data: data, encoding: .utf8) else { return }
        print("Received direct channel message:\n\(prettyPrinted)")
    }

}

