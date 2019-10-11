//
//  AppDelegate.swift
//  OASIS2
//
//  Created by Honey on 5/19/19.
//  Copyright © 2019 theDevHoney. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import FirebaseUI
import SwiftEntryKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    var db: Firestore!
    var ref: DatabaseReference!
    var storageRef:Storage!
    
    var oasis : OASIS?
    var loginVC : LoginVC?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        Constant.logTimestamp(label: "AppDelegate started")
        
        self.configureMyFirebase()
        
        Constant.logTimestamp(label: "AppDelegate homeTabVC init")
        
        
        window = UIWindow(frame: UIScreen.main.bounds)
        self.setRootVC()
        window?.makeKeyAndVisible()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        print("TERMINATOR not -- will resign Active ")
        //deInit & exit chats/etc/monitors/etc;
        self.oasis?.appWillEnterBackground()
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        print("willed enter Background ")
        
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        print("willed enter foreground")
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        print("willed did become active")
        self.oasis?.appEnteredForeground()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        print("TERMINATOR")
        self.saveContext()
    }
    
    
    
    
    
    // MARK: Firebase AUTH
    
    func setRootVC() {
        print("BINI \(Auth.auth().currentUser) - \(Auth.auth().currentUser?.isEmailVerified)")
        if let user = Auth.auth().currentUser, user.isEmailVerified {
            
            
            self.loginVC?.shutDown() //FIX: Do
            self.loginVC = nil
            
            self.oasis = OASIS(myUID: user.uid)
            self.window?.rootViewController = self.oasis!.homeTabBarVC
            
            
        } else {
            
            try! Auth.auth().signOut()
            
            self.oasis?.shutDown()
            self.oasis = nil
            
            self.loginVC = LoginVC()
            let navVC = UINavigationController(rootViewController: self.loginVC!)
            loginVC?.navigationController?.setNavigationBarHidden(true, animated: false)
            //UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController") as! ViewController
            self.window?.rootViewController = navVC
        }
        
        
        
    }
    
    
    
    
    

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "OASIS2")
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
    
    
    
    
    
    
    
    
    // MARK: - Configure Firebase
    
    func configureMyFirebase() {
        FirebaseApp.configure()
        db = Firestore.firestore()
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = false
        Firestore.firestore().settings = settings
        Database.database().isPersistenceEnabled = false
        ref = Database.database().reference()
        storageRef = Storage.storage()
    }
    
    
    
    
    
    
    
    
    
    

}

