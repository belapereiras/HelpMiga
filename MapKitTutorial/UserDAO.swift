//
//  UserDAO.swift
//  MapKitTutorial
//
//  Created by Priscila Rosa on 09/06/16.
//  Copyright © 2016 Isabela Pereira. All rights reserved.
//

import Foundation
import CoreLocation
import CloudKit

class UserDAO {
    
    var currentRecord: CKRecord?
    static let sharedInstace = UserDAO()
    
    let container = CKContainer(identifier: "iCloud.HelpMiga").publicCloudDatabase
//    let publicDatabase = CKContainer.defaultContainer().publicCloudDatabase
    var userName:String?
    var userRecordID:CKRecordID? {
        didSet {
            print("user ID:\(userRecordID?.recordName)")
        }
    }
    
    private init() {}
    
    func saveMyLocation(location:CLLocation) {
        
        let myPlaceID = CKRecordID(recordName: "UsersHelpMiga" + (userRecordID?.recordName)!)
        
        //esse fetch eh p atualizar a parada da location
        container.fetchRecordWithID(myPlaceID) { (fetchedRecord, error) in
            
            if error == nil {
                
                print("updating location record")
                print("LATITUDE PRINT \(location.coordinate.latitude)")
                
                fetchedRecord!["Lat"] = location.coordinate.latitude
                fetchedRecord!["Long"] = location.coordinate.longitude
//                fetchedRecord!["owner"] = self.userName
                fetchedRecord!["Location"] = location
                
                self.save(fetchedRecord!)
                
            } else {
                
                if fetchedRecord == nil {
                    
                    print("<<< creating first location record >>>")
                    
                    let myPlaceRecord = CKRecord(recordType: "UsersHelpMiga", recordID: myPlaceID)
                    myPlaceRecord["Lat"] = location.coordinate.latitude
                    myPlaceRecord["Long"] = location.coordinate.longitude
                    myPlaceRecord["Location"] = location
                    
                    self.save(myPlaceRecord)
                }
            }
        }
    }
    
    func saveUser(nome:String, email:String, senha:String) {
        
        let usersHelpMigaID = CKRecordID(recordName: "UsersHelpMiga" + (userRecordID?.recordName)!)

        container.fetchRecordWithID(usersHelpMigaID) { (fetchedRecord, error) in
            
            if error == nil {
                
                print("updating user record")
                
                fetchedRecord!["Nome"] = nome
                fetchedRecord!["Email"] = email
                fetchedRecord!["Senha"] = senha
                
                self.save(fetchedRecord!)
                
            } else {
                
                if fetchedRecord == nil {
                    
                    print("<<< creating first user record >>>")
                    let userRecord = CKRecord(recordType: "UsersHelpMiga", recordID: usersHelpMigaID)
                    
                    
                    userRecord["Nome"] = nome
                    userRecord["Email"] = email
                    userRecord["Senha"] = senha
                    
                    self.save(userRecord)
                }
            }
        }


//        se deixar isso aqui, tem que tirar a parada do ID
//        userRecord["Nome"] = nome
//        userRecord["Email"] = email
//        userRecord["Senha"] = senha
//        
//        container.saveRecord(userRecord) { (record, error) in
//            if error == nil {
//                print ("salvou user")
//            } else {
//                print (error!.localizedDescription)
//            }
//        }
    }
 
    func save(record:CKRecord) {
        
        container.saveRecord(record) { (savedRecord, error) in
            if error == nil {
                print ("salvou record")
            } else {
                print (error!.localizedDescription)
            }
        }
    }
    
    func getUserID() {
        
//        CKContainer.defaultContainer().fetchUserRecordIDWithCompletionHandler { (recordID, error) in
        CKContainer(identifier: "iCloud.HelpMiga").fetchUserRecordIDWithCompletionHandler { (recordID, error) in
        
            guard error == nil else {
                // Handle the error here
                print(#file, error?.localizedDescription)
                return
            }
            self.userRecordID = recordID
        }
    }
    
    
    
    /*func subscribeForFriendsLocations() {
        
        publicDatabase.fetchAllSubscriptionsWithCompletionHandler() { (subscriptions, error) -> Void in //[unowned self]
            if error == nil {
                
                if subscriptions!.isEmpty {
                    
                    let predicate = NSPredicate(value: true)
                    
                    let subscription = CKSubscription(recordType: "Place", predicate: predicate, options:[.FiresOnRecordCreation, .FiresOnRecordUpdate])
                    
                    let notification = CKNotificationInfo()
                    notification.desiredKeys = ["owner", "lat", "lng"]// "location"
                    notification.shouldSendContentAvailable = true
                    
                    subscription.notificationInfo = notification
                    
                    self.publicDatabase.saveSubscription(subscription) { (subscription: CKSubscription?, error: NSError?) -> Void in
                        guard error == nil else {
                            // Handle the error here
                            print(#file, error?.localizedDescription)
                            return
                        }
                        
                        // Save that we have subscribed successfully to keep track and avoid trying to subscribe again
                        print(#file, "subscribed!")
                    }
                    
                } else { print(#file, "there's a subscription already!")}
                
            } else {
                // do your error handling here!
                print(error!.localizedDescription)
            }
        }
    }*/
}