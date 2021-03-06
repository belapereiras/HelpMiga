//
//  Login.swift
//  MapKitTutorial
//
//  Created by Isabela Pereira on 3/30/16.
//  Copyright © 2016 Isabela Pereira. All rights reserved.
//

import UIKit
import CloudKit

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

class Login: UIViewController, UITextFieldDelegate {
    
    let defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var senha: UITextField!
    var loginSuccess:Bool?
    
    @IBAction func entrar(sender: UIButton) {
        
        if email.text!.isEmpty == true || senha.text!.isEmpty == true {
            notifyUser("Ops!", message: "Todos os campos devem ser preenchidos")
        } else {
        
//        verifyEmail(email.text!)
        verifyLogin(email.text!, senha: senha.text!)


        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        self.email.delegate = self
        self.senha.delegate = self
        
        
//        loadDataNS()
    
        CKContainer(identifier: "iCloud.HelpMiga").accountStatusWithCompletionHandler { (accountStatus, error) in
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
  

// MARK: DISMISS KEYBOARD
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
 //MARK: TEXT FIELD + SCROLL VIEW
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        if (textField == senha){
        scrollView.setContentOffset(CGPointMake(0, 80), animated: true)
    }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        scrollView.setContentOffset(CGPointMake(0, 0), animated: true)
    }
    
    
//    func saveDataNS() {
//        
//        defaults.setObject(self.email.text, forKey: "email")
//        defaults.setObject(self.senha.text, forKey: "senha")
////        defaults.setObject(self.emailTextField.text, forKey: "email")
////        defaults.setObject(self.phoneNumberTextField.text, forKey: "phoneNumber")
//        
//        defaults.synchronize()
//    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }

    
//    func loadDataNS() {
//        
//        if let emailIsNotNill = defaults.objectForKey("email") as? String {
//            if let senhalIsNotNill = defaults.objectForKey("senha") as? String {
//        
////            self.firstNameTextField.text = defaults.objectForKey("firstName") as String
//            let vc = ViewController()
//            self.presentViewController(vc, animated: true, completion: nil)
//            }
//        }
//        
//        
////        if let senhaIsNotNill = defaults.objectForKey("lastName") as? String {
////            self.lastNameTextField.text = defaults.objectForKey("lastName") as String
////        }
//        
////        if let emailIsNotNill = defaults.objectForKey("email") as? String {
////            self.emailTextField.text = defaults.objectForKey("email") as String
////        }
////        
////        if let phoneNumberIsNotNill = defaults.objectForKey("phoneNumber") as? String {
////            self.phoneNumberTextField.text = defaults.objectForKey("phoneNumber") as String
////        }
//    }
    
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
        
        let myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        myActivityIndicator.center = view.center
        myActivityIndicator.color = UIColor.grayColor()
        myActivityIndicator.startAnimating()
        view.addSubview(myActivityIndicator)
        
        let pred = NSPredicate(format: "Email = %@ AND Senha = %@", email, senha)
        let query = CKQuery(recordType: "UsersHelpMiga", predicate: pred)
        
        UserDAO.sharedInstace.container.performQuery(query, inZoneWithID: nil) { results, error in
            
            if (error != nil) {
                print(error?.localizedDescription)
            } else {
                if results!.count > 0 {
                    print("email e senha combinam")
//                    self.loginSuccess = true
                    
//                    self.saveDataNS()
                    
                    dispatch_async(dispatch_get_main_queue(), {
//                        let vc = ViewController()
//                        self.presentViewController(vc, animated: true, completion: nil)
                        myActivityIndicator.stopAnimating()
                        self.performSegueWithIdentifier("irParaBotao", sender: nil)
                    })
                    
                } else {
                    print("email e senha nao combinam")
//                    self.loginSuccess = false
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        myActivityIndicator.stopAnimating()
                    })
                    self.notifyUser("Ops!", message: "Usuário ou senha não combinam")
                    
                }
                
//                if self.loginSuccess == true {
//                    self.saveDataNS()
//                    let vc = ViewController()
//                    self.presentViewController(vc, animated: true, completion: nil)
//                }
            }
            
        }
    }
   
}
