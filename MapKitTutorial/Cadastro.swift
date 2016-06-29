//
//  Cadastro.swift
//  MapKitTutorial
//
//  Created by Isabela Pereira on 3/30/16.
//  Copyright © 2016 Isabela Pereira. All rights reserved.
//

import UIKit
import CloudKit

class Cadastro: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var nome: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var senha: UITextField!
    @IBOutlet weak var repetirSenha: UITextField!
    @IBOutlet weak var imageViewId: UIImageView!
    @IBOutlet weak var imageViewSelfie: UIImageView!
    
    var selfieImageReceiver = UIImage()
    var idImageReceiver = UIImage()
    var botaoImagem:UIImageView = UIImageView()
    var selfieImageURL: NSURL?
    var idImageURL: NSURL?
    let selfieDocumentsDirectoryPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
    let selfieTempImageName = "temp_image.jpg"
    let idDocumentsDirectoryPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
    let idTempImageName = "temp_image.jpg"
    var selfieImageAsset: CKAsset?
    var idImageAsset: CKAsset?

    @IBAction func botaoId(sender: UIButton) {
        botaoImagem = imageViewId
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            
            let idPicker = UIImagePickerController()
            idPicker.delegate = self
            idPicker.sourceType = UIImagePickerControllerSourceType.Camera;
            idPicker.allowsEditing = false

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

            self.presentViewController(selfiePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func enviarParaAprovacao(sender: UIButton) {
        
//        let selfieImageAsset = CKAsset(fileURL: selfieImageURL!)
//        let idImageAsset = CKAsset(fileURL: idImageURL!)
        let nomeUsuaria = nome.text
        let emailUsuaria = email.text
        let senhaUsuaria = senha.text
        let repetirSenhaUsuaria = repetirSenha.text
        
        if imageViewId.image == nil {
            print ("")
        } else {
            idImageAsset = CKAsset(fileURL: idImageURL!)
        }
        if imageViewSelfie.image == nil {
            print ("")
        } else {
            selfieImageAsset = CKAsset(fileURL: selfieImageURL!)
        }

        if nomeUsuaria?.isEmpty == true || emailUsuaria?.isEmpty == true || senhaUsuaria?.isEmpty == true || repetirSenhaUsuaria?.isEmpty == true {
            alerta ("Todos os campos devem ser preenchidos. Não esqueça das fotos!")
            return
        }
        if senhaUsuaria != repetirSenhaUsuaria {
            alerta ("As senhas não combinam")
            return
        }
        else {
            alerta("Seus cadastro foi enviado com sucesso! Aguarde 1 dia útil para a aprovação. Enviaremos a resposta por email.")
            
            UserDAO.sharedInstace.saveUser(nomeUsuaria!, email: emailUsuaria!, senha: senhaUsuaria!, id: idImageAsset!, selfie: selfieImageAsset!)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        self.nome.delegate = self
        self.email.delegate = self
        self.senha.delegate = self
        self.repetirSenha.delegate = self
    }

    func alerta(userMessage: String){
        
        let meuAlerta = UIAlertController(title: "Ops!", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let okButton = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
        meuAlerta.addAction(okButton)
        dispatch_async(dispatch_get_main_queue(), {
        self.presentViewController(meuAlerta, animated: true, completion: nil)
        })
    }

    func textFieldShouldReturn(userText: UITextField) -> Bool {
        userText.resignFirstResponder()
        return true;
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        
        botaoImagem.image = image
//        imageViewSelfie.image = image
//        imageViewId.image = image
        
        guard let selfieImageReceiver2 = botaoImagem.image else {
            print ("nao tem selfie")
            return
        }
        selfieImageReceiver = selfieImageReceiver2
        
        guard let idImageReceiver2 = botaoImagem.image else {
            print ("nao tem id")
            return
        }
        idImageReceiver = idImageReceiver2
        
        saveLocally()

        self.dismissViewControllerAnimated(true, completion: nil)
  
    }
    
    func saveLocally() {
        
        guard let imageData: NSData = UIImageJPEGRepresentation((idImageReceiver), 0.8) else {
            print("imagi vazea")
            return
        }
        guard let imageData2: NSData = UIImageJPEGRepresentation((selfieImageReceiver), 0.8) else {
            print ("imagem 2 vazia")
            return
        }
        let path = idDocumentsDirectoryPath.stringByAppendingPathComponent(idTempImageName)
        let path2 = selfieDocumentsDirectoryPath.stringByAppendingPathComponent(selfieTempImageName)
        idImageURL = NSURL(fileURLWithPath: path)
        selfieImageURL = NSURL(fileURLWithPath: path2)
        guard imageData.writeToURL(idImageURL!, atomically: true) else {
            print ("no url")
            return
        }
        guard imageData2.writeToURL(selfieImageURL!, atomically: true) else {
            print ("no url2")
            return
        }
    }
   
}

  