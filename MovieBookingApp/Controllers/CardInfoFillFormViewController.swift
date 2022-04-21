//
//  CardInfoFillFormViewController.swift
//  MovieBookingApp
//
//  Created by KC on 24/02/2022.
//

import UIKit

class CardInfoFillFormViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var textFiledCardNumber: UITextField!
    @IBOutlet weak var btnConfrim: UIButton!
    @IBOutlet weak var textFieldCVC: UITextField!
    @IBOutlet weak var textFieldExpireDate: UITextField!
    @IBOutlet weak var textFiledCardHolder: UITextField!
   
    @IBOutlet weak var btnBack: UIButton!
    private var userModel: UserModel = UserModelImpl.shared

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()

    }
    
    private func setUpViews(){
        
        textFiledCardNumber.addBottomBorder()
        textFiledCardNumber.setLeftPaddingPoints(12)
        textFiledCardNumber.setRightPaddingPoints(12)
        
        textFieldCVC.addBottomBorder()
        textFieldCVC.setLeftPaddingPoints(12)
        textFieldCVC.setRightPaddingPoints(12)
        textFieldCVC.delegate = self
        
        textFieldExpireDate.addBottomBorder()
        textFieldExpireDate.setLeftPaddingPoints(12)
        textFieldExpireDate.setRightPaddingPoints(12)
        
        textFiledCardHolder.addBottomBorder()
        textFiledCardHolder.setLeftPaddingPoints(12)
        textFiledCardHolder.setRightPaddingPoints(12)
        
        
        
        btnConfrim.addBorderColor(radius: 8, color: UIColor.lightGray.cgColor, borderWidth: 1)
        btnConfrim.isUserInteractionEnabled = true
        btnConfrim.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapConfirm)))
        btnBack.isUserInteractionEnabled = true
        btnBack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapBack)))


    }
    
    @objc func onTapConfirm(){
        if(self.textFiledCardHolder.text?.isEmpty ?? true){
           self.showAlert(message: "card holder missing")
        }
        else if(self.textFieldExpireDate.text?.isEmpty ?? true){
            self.showAlert(message: "card expired date missing")
        }
        else if(self.textFiledCardNumber.text?.isEmpty ?? true){
            self.showAlert(message: "card number missing")
        }
        else if(self.textFieldCVC.text?.isEmpty ?? true){
            self.showAlert(message: "card cvc missing")
        }
        else if(self.textFieldCVC.text?.count != 3){
            self.showAlert(message: "The cvc must be 3 digits.")
        }
        else{
            self.startLoading()
            createCard()
        }
        
    }
    
    private func createCard(){
        let card = Card(id: Int(textFieldCVC.text ?? ""), cardHolder: textFiledCardHolder.text, cardNumber: textFiledCardNumber.text, expireDate: textFieldExpireDate.text, cardType: textFieldCVC.text, isSelected: false)
        
        userModel.addCard(card: card){ [weak self] (result) in
            guard let self = self else { return }
            switch result{
            case .success(let data):
                self.stopLoading()
                if data.message == "Success"{
                    self.dismiss(animated: true, completion: nil)
                    
                }
                else{
                    self.showInfo(message: data.message ?? "")
                }
                

            case .failure(let message):
                self.showAlert(message: message)
            }
            
        }
    }
    
    @objc func onTapBack(){
        self.dismiss(animated: true, completion: nil)
    }
    

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == textFieldCVC {
                    let allowedCharacters = "1234567890"
                    let allowedCharacterSet = CharacterSet(charactersIn: allowedCharacters)
                    let typedCharacterSet = CharacterSet(charactersIn: string)
                    let alphabet = allowedCharacterSet.isSuperset(of: typedCharacterSet)
                    return alphabet


          }
        
        return false
      }

}


