//
//  AppDelegate.swift
//  MapKitTutorial
//
//  Created by Isabela Pereira on 3/23/16.
//  Copyright © 2016 Isabela Pereira. All rights reserved.
//

import UIKit
import CloudKit

import CoreLocation


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        let settings = UIUserNotificationSettings(forTypes: [.Alert, .Sound], categories: nil)
        application.registerUserNotificationSettings(settings)
        

        application.registerForRemoteNotifications()
        
        UserDAO.sharedInstace.getUserID()
        UserDAO.sharedInstace.subscribeForFriendsLocations()
        
//        if let options: NSDictionary = launchOptions {
//            let remoteNotification = options.objectForKey(UIApplicationLaunchOptionsRemoteNotificationKey) as? NSDictionary
//            
//            if let notification = remoteNotification {
//                self.application(application, didReceiveRemoteNotification: notification as [NSObject:AnyObject])
//            }
//        }
        
        return true
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        
        let cloudKitNotification = CKNotification(fromRemoteNotificationDictionary: userInfo as! [String : NSObject])
        
        if cloudKitNotification.notificationType == .Query {
            
            let queryNotification = cloudKitNotification as! CKQueryNotification
//            let recordID = queryNotification.recordID
            
            if queryNotification.queryNotificationReason == .RecordDeleted {
                // If the record has been deleted in CloudKit then delete the local copy here
            } else  { //if queryNotification.queryNotificationReason == .RecordCreated || .RecordCreated
                // If the record has been created or changed, we fetch the data from CloudKit
                
                print("QUERY:\(queryNotification.recordFields)")
                
//                let user = queryNotification.recordFields!["owner"] as! String
                let latitude = queryNotification.recordFields!["Lat"] as! Double
                let longitude = queryNotification.recordFields!["Long"] as! Double
                let nome = queryNotification.recordFields!["Nome"] as! String
                
                
                let userInfo = ["Lat":latitude, "Long":longitude, "Nome":nome]
                
                NSNotificationCenter.defaultCenter().postNotificationName("newLocation", object: nil, userInfo: userInfo as [NSObject : AnyObject])
//                UserDAO.sharedInstace.fetchAndDisplayNewRecord(recordID!)
            }
        }
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

