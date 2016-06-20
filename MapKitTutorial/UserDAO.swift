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
                print("LATITUDE PRINT \(location.coordinate.latitude)/n")
                
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
    }
    
    func saveAskHelp(location: CLLocation) {
            
//            let helpID = CKRecordID(recordName: "Help" + (userRecordID?.recordName)!)
//            let helpRecord = CKRecord(recordType: "Help", recordID: helpID)
            let helpRecord = CKRecord(recordType: "Help")
            
            helpRecord.setObject(location, forKey: "Location")
            helpRecord.setObject(location.coordinate.latitude, forKey: "Lat")
            helpRecord.setObject(location.coordinate.longitude, forKey: "Long")
            
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

    
    
    
    func subscribeForFriendsLocations() {
        
        container.fetchAllSubscriptionsWithCompletionHandler() { (subscriptions, error) -> Void in //[unowned self]
            if error == nil {
                print (">>>>>>>>>>>>>>>>>\(subscriptions?.description)<<<<<<<<<<<<<")
                if subscriptions!.isEmpty {
                    
                    let predicate = NSPredicate(value: true)
                    
                    let subscription = CKSubscription(recordType: "Help", predicate: predicate, options:[.FiresOnRecordCreation, .FiresOnRecordUpdate])
                    
                    let notification = CKNotificationInfo()
                    notification.desiredKeys = ["Lat", "Long"] //trocar por Location
                    notification.shouldSendContentAvailable = true
                    
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
}