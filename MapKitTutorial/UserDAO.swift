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
//                print("LATITUDE PRINT \(location.coordinate.latitude)/n")
                
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
    
    
    func saveUser(nome:String, email:String, senha:String, id: CKAsset, selfie: CKAsset) {
        
        let usersHelpMigaID = CKRecordID(recordName: "UsersHelpMiga" + (userRecordID?.recordName)!)

        container.fetchRecordWithID(usersHelpMigaID) { (fetchedRecord, error) in
            
            if error == nil {
                
                print("updating user record")
                
                fetchedRecord!["Nome"] = nome
                fetchedRecord!["Email"] = email
                fetchedRecord!["Senha"] = senha
                fetchedRecord!["ID"] = id
                fetchedRecord!["Selfie"] = selfie
                
                self.save(fetchedRecord!)
                
            } else {
                
                if fetchedRecord == nil {
                    
                    print("<<< creating first user record >>>")
                    let userRecord = CKRecord(recordType: "UsersHelpMiga", recordID: usersHelpMigaID)
                    
                    
                    userRecord["Nome"] = nome
                    userRecord["Email"] = email
                    userRecord["Senha"] = senha
                    userRecord["ID"] = id
                    userRecord["Selfie"] = selfie
                    
                    self.save(userRecord)
                }
            }
        }
    }
    
    
    func saveAskHelp(location: CLLocation) {
            
//            let helpID = CKRecordID(recordName: "Help" + (userRecordID?.recordName)!)
//              let helpRecord = CKRecord(recordType: "Help", recordID: helpID)
        let helpRecord = CKRecord(recordType: "Help")
        let usersHelpMigaID = CKRecordID(recordName: "UsersHelpMiga" + (userRecordID?.recordName)!)
        let userReference = CKReference(recordID: usersHelpMigaID, action: CKReferenceAction.DeleteSelf)
            
        helpRecord.setObject(location, forKey: "Location")
        helpRecord.setObject(location.coordinate.latitude, forKey: "Lat")
        helpRecord.setObject(location.coordinate.longitude, forKey: "Long")
        helpRecord.setObject(userReference, forKey: "User")
            
            self.save(helpRecord)
        print ("PEDIU HELP")
    }
    
    func saveEstouIndo(lat: Double, long: Double) {

        let helpRecord = CKRecord(recordType: "EstouIndo")
        
        helpRecord.setObject(lat, forKey: "Lat")
        helpRecord.setObject(long, forKey: "Long")
        
        self.save(helpRecord)
        print ("PEDIU HELP")
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
        CKContainer(identifier: "iCloud.HelpMiga").fetchUserRecordIDWithCompletionHandler { (recordID, error) in
            guard error == nil else {
                // Handle the error here
                print(#file, error?.localizedDescription)
                return
            }
            self.userRecordID = recordID
        }
    }
    
    func queryUserReference(userReference: CKReference) -> String {
        var nome: String = ""
        
        UserDAO.sharedInstace.container.fetchRecordWithID(userReference.recordID, completionHandler: { (record: CKRecord?, error: NSError?) -> Void in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            nome = record!["Nome"] as! String
        })
        return nome
    }

    
    func subscribeForFriendsLocations() {
    
        container.fetchAllSubscriptionsWithCompletionHandler() { (subscriptions, error) -> Void in //[unowned self]
            if error == nil {
                if subscriptions!.isEmpty {
                    
                    let radiusInMeters = 500
//                    let pred = NSPredicate(value: true)
                    let predicate = NSPredicate(format: "distanceToLocation:fromLocation:(%K,%@) < %f", "Location",
                                    Location.sharedInstace.lastLocation, radiusInMeters)
                    
                    
                    let subscription = CKSubscription(recordType:"Help", predicate: predicate, options:[.FiresOnRecordCreation, .FiresOnRecordUpdate])
                    
                    let notification = CKNotificationInfo()
                    notification.desiredKeys = ["Lat", "Long"]
//                    notification.desiredKeys = ["Location"]
//                    notification.desiredKeys = ["Lat", "Long"] //trocar por Location
//                    notification.shouldSendContentAvailable = true
                    notification.shouldBadge = true
                    notification.alertBody = "Uma miga precisa de ajuda!"
                    subscription.notificationInfo = notification
                    
                    self.container.saveSubscription(subscription) { (subscription: CKSubscription?, error: NSError?) -> Void in
                        guard error == nil else {
                            // Handle the error here
                            print("Erro salvando a notificação: \(#file, error?.localizedDescription)")
                            return
                        }
                        
                        // Save that we have subscribed successfully to keep track and avoid trying to subscribe again
                        print(#file, "subscribed!")
                    }
                    
                } else { print(#file, "there's a subscription already!")}
                
            } else {
                // do your error handling here!
                print("Erro mandando a notificacao \(error!.localizedDescription)")
            }
        }
    }
    
    func subscribeEstouIndo() {
        
        container.fetchAllSubscriptionsWithCompletionHandler() { (subscriptions, error) -> Void in //[unowned self]
            if error == nil {
                    
                    let pred = NSPredicate(value: true)
                    
                    
                    let subscription = CKSubscription(recordType:"EstouIndo", predicate: pred, options:[.FiresOnRecordCreation])
                    
                    let notification = CKNotificationInfo()

                    notification.shouldBadge = true
                    notification.alertBody = "Estou Indo!"
                    subscription.notificationInfo = notification
                    
                    self.container.saveSubscription(subscription) { (subscription: CKSubscription?, error: NSError?) -> Void in
                        guard error == nil else {
                            // Handle the error here
                            print("Erro salvando a notificação: \(#file, error?.localizedDescription)")
                            return
                        }
                        
                        // Save that we have subscribed successfully to keep track and avoid trying to subscribe again
                        print(#file, "subscribed to estou indo!")
                    }
            } else {
                // do your error handling here!
                print("Erro mandando a notificacao \(error!.localizedDescription)")
            }
        }
        
    }
//    func subscribeForHelpInfo() {
//        
//        container.fetchAllSubscriptionsWithCompletionHandler() { (subscriptions, error) -> Void in //[unowned self]
//            if error == nil {
//                if subscriptions!.isEmpty {
//
//                    let pred = NSPredicate(value: true)
//                    let subscription = CKSubscription(recordType:"Helpinfo", predicate: pred, options:[.FiresOnRecordCreation])
//                    let notification = CKNotificationInfo()
////                    notification.desiredKeys = ["Lat", "Long"] //trocar por Location
//                    notification.desiredKeys = ["Lat", "Long"]
//                    notification.shouldSendContentAvailable = true
//                    notification.shouldBadge = true
////                    notification.alertBody = "Help"
//                    subscription.notificationInfo = notification
//                    
//                    self.container.saveSubscription(subscription) { (subscription: CKSubscription?, error: NSError?) -> Void in
//                        guard error == nil else {
//                            // Handle the error here
//                            print("Erro salvando a notificação: \(#file, error?.localizedDescription)")
//                            return
//                        }
//                        
//                        // Save that we have subscribed successfully to keep track and avoid trying to subscribe again
//                        print(#file, "subscribed for helpinfo!")
//                    }
//                    
//                } else { print(#file, "there's a subscription already!")}
//                
//            } else {
//                // do your error handling here!
//                print("Erro mandando a notificacao \(error!.localizedDescription)")
//            }
//        }
//    }
}