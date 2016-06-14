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
    let publicDatabase = CKContainer.defaultContainer().publicCloudDatabase
    var userName:String?
    var userRecordID:CKRecordID? {
        didSet {
            print("user ID:\(userRecordID?.recordName)")
        }
    }
    
    private init() {}
    
//    func saveMyLocation(location:CLLocation) {
//        
//        let myPlaceID = CKRecordID(recordName: "myPlace" + (userRecordID?.recordName)!)
//        
//        //esse fetch eh p atualizar a parada da location
//        publicDatabase.fetchRecordWithID(myPlaceID) { (fetchedRecord, error) in
//            
//            if error == nil {
//                
//                print("updating location record")
//                
//                fetchedRecord!["lat"] = location.coordinate.latitude
//                fetchedRecord!["lng"] = location.coordinate.longitude
//                fetchedRecord!["owner"] = self.userName
//                //                fetchedRecord!["location"] = location
//                
//                self.save(fetchedRecord!)
//                
//            } else {
//                
//                if fetchedRecord == nil {
//                    
//                    print("<<< creating first location record >>>")
//                    
//                    let myPlaceRecord = CKRecord(recordType: "Place", recordID: myPlaceID)
//                    myPlaceRecord["lat"] = location.coordinate.latitude
//                    myPlaceRecord["lng"] = location.coordinate.longitude
//                    myPlaceRecord["owner"] = self.userName
//                    //                    fetchedRecord!["location"] = location
//                    
//                    self.save(myPlaceRecord)
//                }
//            }
//        }
//    }
    
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
    
//    func verifyEmail(email: String) {
//        
//        let predicate = NSPredicate(format: "Email = %@", email)
//        let query = CKQuery(recordType: "UsersHelpMiga", predicate: predicate)
//        
//        container.performQuery(query, inZoneWithID: nil) { results, error in
//            
//            if (error != nil) {
//                print(error?.localizedDescription)
//            } else {
//                if results!.count > 0 {
//                    print("email existe")
//                } else {
//                    print("email nao cadastrado")
//                }
//            }
//        }
//    }
//    
//    func verifyLogin(email: String, senha: String) {
//        
////        let predicate = NSPredicate(format: "Email =  %@", email, )
//        let pred = NSPredicate(format: "Email = %@ AND Senha = %@", email, senha)
//        let query = CKQuery(recordType: "UsersHelpMiga", predicate: pred)
//        
//        container.performQuery(query, inZoneWithID: nil) { results, error in
//            
//            if (error != nil) {
//                print(error?.localizedDescription)
//            } else {
//                if results!.count > 0 {
//                    print("email e senha combinam")
//                } else {
//                    print("email e senha nao combinam")
//                    
//                }
//            }
//            
//        }
//    }
    
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
        
        CKContainer.defaultContainer().fetchUserRecordIDWithCompletionHandler { (recordID, error) in
            
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