//
//  AppDelegate.swift
//  BSGNProject
//
//  Created by Linh Thai on 13/08/2024.
//

import UIKit
import Firebase
import UserNotificationsUI
import GoogleMaps
import GooglePlaces
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?

    func application ( _ application : UIApplication ,
        didFinishLaunchingWithOptions launchOptions :
                       [ UIApplication.LaunchOptionsKey : Any ]?) -> Bool {

        
        FirebaseApp.configure()
        GMSServices.provideAPIKey("AIzaSyDaC5exHhkXgpuD1SHnUiREDViWUHCFf2I")
        GMSPlacesClient.provideAPIKey("AIzaSyDaC5exHhkXgpuD1SHnUiREDViWUHCFf2I")
        
        configIQKeyboard()
        return true
      }

    private func configIQKeyboard() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        let doneBtn = IQBarButtonItemConfiguration(title: "Done")
        IQKeyboardManager.shared.toolbarConfiguration.doneBarButtonConfiguration = doneBtn
        IQKeyboardManager.shared.resignOnTouchOutside = true
//        IQKeyboardManager.shared.keyboardDistanceFromTextField = 0

    }
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    // Called when APNs successfully registers your app for remote notifications.
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Pass device token to FCM
        Messaging.messaging().apnsToken = deviceToken
    }
    
    // Called when APNs fails to register the device for push notifications
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for remote notifications: \(error.localizedDescription)")
    }

}

