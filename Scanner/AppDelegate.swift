//
//  AppDelegate.swift
//  Scanner
//
//  Created by Sona on 21.12.23.
//

import UIKit
import GoogleSignIn
import CoreData
import YandexMobileMetrica
import AppTrackingTransparency

var isSubscribed = UserDefaults.standard.bool(forKey: "isSubscribed")
var yandexMetricaID = "640609218903-mivqemk73799nol36lelp1o4ei2rrr0k.apps.googleusercontent.com"

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let config = GIDConfiguration(clientID: yandexMetricaID)
        
        GIDSignIn.sharedInstance.configuration = config
        
        if let receiptURL = Bundle.main.appStoreReceiptURL,
            let receiptData = try? Data(contentsOf: receiptURL) {
            // Verify the receipt data with your server to ensure its validity and check the subscription status.
            // For a real-world application, you would usually use a server for receipt validation.
            UserDefaults.standard.setValue(true, forKey: "isSubscribed")
            print("Receipt data: \(receiptData.base64EncodedString())")
        }
        
        let configuration = YMMYandexMetricaConfiguration.init(apiKey: "1e7e2873-dd69-4bee-95d2-3e185e274952")
        YMMYandexMetrica.activate(with: configuration!)
        NotificationCenter.default.addObserver(self, selector: #selector(sendLaunch), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        return true
    }
    
    @objc func sendLaunch() {
        ATTrackingManager.requestTrackingAuthorization { (status) in
                switch status {
                case .denied:
                    print("AuthorizationSatus is denied")
                case .notDetermined:
                    print("AuthorizationSatus is notDetermined")
                case .restricted:
                    print("AuthorizationSatus is restricted")
                case .authorized:
                    print("AuthorizationSatus is authorized")
                @unknown default:
                    fatalError("Invalid authorization status")
                }
              }
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

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "ScannerModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

