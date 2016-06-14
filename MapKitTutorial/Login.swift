//
//  Login.swift
//  MapKitTutorial
//
//  Created by Isabela Pereira on 3/30/16.
//  Copyright © 2016 Isabela Pereira. All rights reserved.
//

import UIKit
import CloudKit

class Login: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var senha: UITextField!
    
    
    
    @IBAction func entrar(sender: UIButton) {
        
        if email.text!.isEmpty == true || senha.text!.isEmpty == true {
            notifyUser("Ops!", message: "Todos os campos devem ser preenchidos")
        } else {
        
        verifyEmail(email.text!)
        verifyLogin(email.text!, senha: senha.text!)

        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.email.delegate = self
        self.senha.delegate = self
        
        
        CKContainer.defaultContainer().accountStatusWithCompletionHandler { (accountStatus, error) in
            if accountStatus == CKAccountStatus.NoAccount {
                print("nao tem conta icloud")
            } else {
                dispatch_async(dispatch_get_main_queue()) {
                    //tem que ter um outlet do botao entrar
//                    self.entrar.enabled = true
                    print("tem conta icloud")
                }
            }
        }
    }
    
    func notifyUser(title: String, message: String) -> Void {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: UIAlertControllerStyle.Alert)
        
        let cancelAction = UIAlertAction(title: "OK",
                                         style: .Cancel, handler: nil)
        
        alert.addAction(cancelAction)
        dispatch_async(dispatch_get_main_queue(), {
            self.presentViewController(alert, animated: true,
                completion: nil)
        })
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(userText: UITextField) -> Bool {
        userText.resignFirstResponder()
        return true;
    }
    
    func verifyEmail(email: String) {
        
        let predicate = NSPredicate(format: "Email = %@", email)
        let query = CKQuery(recordType: "UsersHelpMiga", predicate: predicate)
        
        UserDAO.sharedInstace.container.performQuery(query, inZoneWithID: nil) { results, error in
            
            if (error != nil) {
                print(error?.localizedDescription)
            } else {
                if results!.count > 0 {
                    print("email existe")
                } else {
                    print("email nao cadastrado")
                }
            }
        }
    }
    
    func verifyLogin(email: String, senha: String) {
        
        let pred = NSPredicate(format: "Email = %@ AND Senha = %@", email, senha)
        let query = CKQuery(recordType: "UsersHelpMiga", predicate: pred)
        
        UserDAO.sharedInstace.container.performQuery(query, inZoneWithID: nil) { results, error in
            
            if (error != nil) {
                print(error?.localizedDescription)
            } else {
                if results!.count > 0 {
                    print("email e senha combinam")
                    dispatch_async(dispatch_get_main_queue(), {
                        self.performSegueWithIdentifier("irParaPrincipal", sender: nil)
                    })
                } else {
                    print("email e senha nao combinam")
                    self.notifyUser("Ops!", message: "Usuário ou senha não combinam")
                    
                }
            }
            
        }
    }
}
