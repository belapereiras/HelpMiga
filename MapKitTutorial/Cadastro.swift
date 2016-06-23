//
//  Cadastro.swift
//  MapKitTutorial
//
//  Created by Isabela Pereira on 3/30/16.
//  Copyright © 2016 Isabela Pereira. All rights reserved.
//

import UIKit

class Cadastro: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var nome: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var senha: UITextField!
    @IBOutlet weak var repetirSenha: UITextField!
    @IBOutlet weak var imageViewId: UIImageView!
    @IBOutlet weak var imageViewSelfie: UIImageView!
    
    
//    var imageReceiver = UIImage()
    var botaoImagem:UIImageView = UIImageView()
    
    @IBAction func botaoId(sender: UIButton) {
        botaoImagem = imageViewId
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            
            let idPicker = UIImagePickerController()
            
            idPicker.delegate = self
            idPicker.sourceType = UIImagePickerControllerSourceType.Camera;
            idPicker.allowsEditing = false
            
//            imageViewId.image = imageReceiver
            
            self.presentViewController(idPicker, animated: true, completion: nil)
            
        }
    }
    
    @IBAction func botaoSelfie(sender: UIButton) {
        botaoImagem = imageViewSelfie
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            
            let selfiePicker = UIImagePickerController()
            selfiePicker.delegate = self
            selfiePicker.sourceType = UIImagePickerControllerSourceType.Camera;
            selfiePicker.allowsEditing = false
            
//            imageViewSelfie.image = imageReceiver
            
            self.presentViewController(selfiePicker, animated: true, completion: nil)

        }
    }
    
    @IBAction func enviarParaAprovacao(sender: UIButton) {
        
        let nomeUsuaria = nome.text
        let emailUsuaria = email.text
        let senhaUsuaria = senha.text
        let repetirSenhaUsuaria = repetirSenha.text
        
        
// MARK: VERIFICAR CAMPOS VAZIOS
        
        if nomeUsuaria?.isEmpty == true || emailUsuaria?.isEmpty == true || senhaUsuaria?.isEmpty == true || repetirSenhaUsuaria?.isEmpty == true {
            alerta ("Todos os campos devem ser preenchidos")
        }
    
        
// MARK: VERIFICAR SE AS SENHAS COMBINAM
        
        
        if senhaUsuaria != repetirSenhaUsuaria {
            alerta ("As senhas não combinam")
        }
        
        //
        
        
//        if imageViewId.image == nil {
//            alerta("Você não incluiu a foto da sua identidade!")
//        }
//        
//        if imageViewSelfie.image == nil {
//            alerta("Você não incluiu a sua selfie!")
//        }
            
        else {
            alerta("Seus cadastro foi enviado com sucesso! Aguarde 1 dia útil para a aprovação. Enviaremos a resposta por email.")
        }
        
        UserDAO.sharedInstace.saveUser(nomeUsuaria!, email: emailUsuaria!, senha: senhaUsuaria!)
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.nome.delegate = self
        self.email.delegate = self
        self.senha.delegate = self
        self.repetirSenha.delegate = self
    }

    func alerta(userMessage: String){
        
        let meuAlerta = UIAlertController(title: "Ops!", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let okButton = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
        meuAlerta.addAction(okButton)
        self.presentViewController(meuAlerta, animated: true, completion: nil)
        
    }

    func textFieldShouldReturn(userText: UITextField) -> Bool {
        userText.resignFirstResponder()
        return true;
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        
        botaoImagem.image = image
        //imageViewSelfie.image = image
        
        self.dismissViewControllerAnimated(true, completion: nil);
    }
  
}

  