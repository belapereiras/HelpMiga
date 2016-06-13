//
//  Login.swift
//  MapKitTutorial
//
//  Created by Isabela Pereira on 3/30/16.
//  Copyright © 2016 Isabela Pereira. All rights reserved.
//

import UIKit

class Login: UIViewController, UITextFieldDelegate {
    
    
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var senha: UITextField!
    
    
    
    @IBAction func entrar(sender: UIButton) {
    
        
        
        
        if email.text == "belapereiras@icloud.com" && senha.text == "123"{
            
            performSegueWithIdentifier("irParaPrincipal", sender: sender)
            
        }else{
            
            alerta("Usuário ou senha inválidos")
            
        }
        
    }

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.email.delegate = self
        self.senha.delegate = self
    

        
}
    
    func alerta(userMessage: String){
        
        let meuAlerta = UIAlertController(title: "Alerta", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert)
        
        let okButton = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
        
        
        meuAlerta.addAction(okButton)
        
        self.presentViewController(meuAlerta, animated: true, completion: nil)
        
    }

    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    func textFieldShouldReturn(userText: UITextField) -> Bool {
        userText.resignFirstResponder()
        return true;
    }
    

    
}
