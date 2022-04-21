//
//  LoginViewController.swift
//  MovieBookingApp
//
//  Created by KC on 21/02/2022.
//

import UIKit

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
        //navigateToMainViewController()
        checkFields()
    }
    

    private func checkFields(){
        if isLogInSelected{
            if(self.textFieldEmail.text?.isEmpty ?? true){
               self.showAlert(message: "email missing")
            }
            else if(self.textFieldPassword.text?.isEmpty ?? true){
                self.showAlert(message: "password missing")
            }
            else{
                if let email = self.textFieldEmail.text{
                    if email.isValidEmail{
                        userLoginWithEmail()
                    }
                    else{
                        self.showAlert(message: "Check your email!")
                    }
                }
            }
        }
        else{
            if(self.textFieldName.text?.isEmpty ?? true){
                self.showAlert(message: "name missing")
            }
            else if(self.textFieldEmail.text?.isEmpty ?? true){
                self.showAlert(message: "email missing")
            }
            else if(self.textFieldPassword.text?.isEmpty ?? true){
                self.showAlert(message: "password missing")
            }
            else if(self.textFieldPhone.text?.isEmpty ?? true){
                self.showAlert(message: "phone missing")
            }
            else{
                userRegister()
            }
        }
    }
    
    private func userRegister() {
        self.startLoading()
        
        userModel.register(user: UserInfo(id: 0, name: textFieldName.text, email: textFieldEmail.text, phone: textFieldPhone.text, totalExpense: 0, profileImage: textFieldPassword.text)){ [weak self] (result) in
            guard let self = self else { return }
            switch result{
            case .success(let data):
                print("data \(String(describing: data.code))")
                self.stopLoading()
                print("data \(String(describing: data.message))")
                if data.code == 201{
                    print(data)
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
                print("data \(String(describing: data.code))")
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
        UDM.shared.defaults.setValue(data.token ?? "", forKey: "token")
        UDM.shared.defaults.setValue(data.userinfo?.name ?? "", forKey: "name")
        UDM.shared.defaults.setValue(data.userinfo?.phone ?? "", forKey: "phone")
        UDM.shared.defaults.setValue(data.userinfo?.email ?? "", forKey: "email")
        UDM.shared.defaults.setValue(data.userinfo?.profileImage ?? "", forKey: "image")
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
