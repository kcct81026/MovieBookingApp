//
//  LoginViewController.swift
//  MovieBookingApp
//
//  Created by KC on 21/02/2022.
//

import UIKit
import CloudKit

class LoginViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldPhone: UITextField!
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var hiddenViewLogin: UIView!
    @IBOutlet weak var hiddenViewSignIn: UIView!
    @IBOutlet weak var svGoogleSignIn: UIStackView!
    @IBOutlet weak var svFbSignIn: UIStackView!
    @IBOutlet weak var svPhone: UIStackView!
    @IBOutlet weak var svName: UIStackView!
    @IBOutlet weak var svSignIn: UIStackView!
    @IBOutlet weak var svLogIn: UIStackView!
    @IBOutlet weak var lblSignIn: UILabel!
    @IBOutlet weak var lblLogin: UILabel!
    @IBOutlet weak var lblForgotPassword: UILabel!
    @IBOutlet weak var viewConfirm: UIView!
    let facebookAuth = FacebookAuth()
    let googleAuth = GoogleAuth()
    private var fbId = ""
    private var ggId = ""

 
    var isLogInSelected = true
    private let userModel : UserModel = UserModelImpl.shared

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()
        checkViews()
       

    }
    
   

    
    private func setUpViews(){
        textFieldEmail.addBottomBorder()
        textFieldEmail.setLeftPaddingPoints(12)
        textFieldEmail.setRightPaddingPoints(12)
        textFieldPassword.addBottomBorder()
        textFieldPassword.setLeftPaddingPoints(12)
        textFieldPassword.setRightPaddingPoints(12)
        textFieldName.addBottomBorder()
        textFieldName.setLeftPaddingPoints(12)
        textFieldName.setRightPaddingPoints(12)
        textFieldPhone.addBottomBorder()
        textFieldPhone.setLeftPaddingPoints(12)
        textFieldPhone.setRightPaddingPoints(12)
        textFieldPhone.delegate = self
   
        svFbSignIn.addBorderColor(radius: 8, color: UIColor.lightGray.cgColor, borderWidth: 1)
        svGoogleSignIn.addBorderColor(radius: 8, color: UIColor.lightGray.cgColor, borderWidth: 1)
        viewConfirm.layer.cornerRadius = 8
        
        
        
        svSignIn.isUserInteractionEnabled = true
        svLogIn.isUserInteractionEnabled =  true
        viewConfirm.isUserInteractionEnabled = true
        viewConfirm.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapMain)))
        svLogIn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapLogin)))
        svSignIn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapSignIn)))
        
        svFbSignIn.isUserInteractionEnabled = true
        svFbSignIn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapFbSignIn)))
        
        svGoogleSignIn.isUserInteractionEnabled = true
        svGoogleSignIn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapGoogleSignIn)))


    }
    
    @objc func onTapGoogleSignIn(){
        
        googleAuth.start(view:self, success: { [weak self] (result) in
            guard let self = self else { return }
            if self.isLogInSelected {
                self.loginWithGgId(id: result.id)
            }
            else{
                do{
                    try self.validateUserInputs()
                    self.ggId = result.id
                    self.userRegister()
                }catch{
                    self.showAlert(message: error.localizedDescription)
                }
            }
            
        }) { error  in
            print(error)
        }


    }
    
    @objc func onTapFbSignIn(){
        
        facebookAuth.start(vc: self, success: {  [weak self] (result) in
            guard let self = self else { return }
            if self.isLogInSelected{
                self.loginWithFbId(id: result.id)
            }
            else {
                do{
                    self.fbId = result.id
                    self.userRegister()
                    try self.validateUserInputs()
                    
                }catch{
                    self.showAlert(message: error.localizedDescription)
                }
            }
            
        }, failure: { error in
            print(error.debugDescription)
        })
 
        
    }
    
    
    
    func checkViews(){
        if isLogInSelected {
            hiddenViewLogin.backgroundColor = UIColor(named: "primary_color")
            hiddenViewSignIn.backgroundColor = UIColor.white
            lblLogin.textColor = UIColor(named: "primary_color")
            lblSignIn.textColor = UIColor.black
            svName.isHidden = true
            svPhone.isHidden = true
        
        }
        else{
            hiddenViewSignIn.backgroundColor = UIColor(named: "primary_color")
            hiddenViewLogin.backgroundColor = UIColor.white
            lblSignIn.textColor = UIColor(named: "primary_color")
            lblLogin.textColor = UIColor.black
            svName.isHidden = false
            svPhone.isHidden = false

        }
    }
        
    @objc func onTapLogin(){
        isLogInSelected = true
        checkViews()
    }
    
    @objc func onTapSignIn(){
        isLogInSelected = false
        checkViews()
    }
    
    @objc func onTapMain(){
        do {
            try validateUserInputs()
            
            if isLogInSelected {
                userLoginWithEmail()
            }
            else {
                userRegister()
            }
            
        } catch {
            showAlert(message: error.localizedDescription)
        }
    }
    
    private func validateUserInputs() throws{
        if ( self.textFieldEmail.text == nil || !EmailValidation.isValidEmail(textFieldEmail.text!)){
            throw "Check your email!"
        }
        else if (self.textFieldPassword.text == nil || self.textFieldPassword.text!.isEmpty){
            throw "Check your password!"
        }
        
        if (!isLogInSelected){
            if (self.textFieldName.text == nil || self.textFieldName.text!.isEmpty){
                throw "Enter your name!"
            }
            else if (self.textFieldPhone.text == nil || self.textFieldPhone.text!.isEmpty){
                throw "Enter your phone number!"
            }
        }
    }
    

    
    private func userRegister() {
        self.startLoading()
        userModel.register(user: UserCredentialVO(name: textFieldName.text, email: textFieldEmail.text, phone: textFieldPhone.text, password: textFieldPassword.text, gid: ggId, fid: fbId)){ [weak self] (result) in
            guard let self = self else { return }
            switch result{
            case .success(let data):
                self.stopLoading()
                if data.code == 201{
                    self.goToMain(data: data)
                }
                else{
                    self.showInfo(message: data.message ?? "")
                }
                

            case .failure(let message):
                self.showAlert(message: message)
            }
            
        }
    }
    
    private func userLoginWithEmail() {
        self.startLoading()
        
        userModel.loginWithEmail(user: UserInfo(id: 0, name: "", email: textFieldEmail.text, phone: "", totalExpense: 0, profileImage: textFieldPassword.text)){ [weak self] (result) in
            guard let self = self else { return }
            switch result{
            case .success(let data):
                self.stopLoading()
                if data.code == 200{
                    self.goToMain(data:data)
                    
                }
                else{
                    self.showInfo(message: data.message ?? "")
                }

            case .failure(let message):
                self.stopLoading()
                self.showAlert(message: message)
            }
            
        }
    }
    
    private func loginWithFbId(id: String) {
        self.startLoading()
        
        userModel.loginWithFbId(id: id){ [weak self] (result) in
            guard let self = self else { return }
            switch result{
            case .success(let data):
                self.stopLoading()
                if data.code == 200{
                    self.goToMain(data:data)
                    
                }
                else{
                    self.showInfo(message: data.message ?? "")
                }

            case .failure(let message):
                self.stopLoading()
                self.showAlert(message: message)
            }
            
        }
    }
    
    private func loginWithGgId(id: String) {
        self.startLoading()
        
        userModel.loginWithGgId(id: id){ [weak self] (result) in
            guard let self = self else { return }
            switch result{
            case .success(let data):
                self.stopLoading()
                if data.code == 200{
                    self.goToMain(data:data)
                    
                }
                else{
                    self.showInfo(message: data.message ?? "")
                }

            case .failure(let message):
                self.stopLoading()
                self.showAlert(message: message)
            }
            
        }
    }
    
    private func goToMain(data: RegisterResponse){
        self.navigateToMainViewController()

    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == textFieldPhone {
                    let allowedCharacters = "1234567890"
                    let allowedCharacterSet = CharacterSet(charactersIn: allowedCharacters)
                    let typedCharacterSet = CharacterSet(charactersIn: string)
                    let alphabet = allowedCharacterSet.isSuperset(of: typedCharacterSet)
                    return alphabet


          }
        
        return false
      }


}
