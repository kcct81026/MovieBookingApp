//
//  SideMenuViewController.swift
//  MovieBookingApp
//
//  Created by KC on 25/02/2022.
//

import UIKit
import SDWebImage
import RealmSwift

class SideMenuViewController: UIViewController {

    @IBOutlet weak var labelEmail: UILabel!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var svLogOut: UIStackView!
    
    private var userModel: UserModel = UserModelImpl.shared

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        svLogOut.isUserInteractionEnabled = true
        svLogOut.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapLogOut)))
        
        labelName.text = UDM.shared.defaults.string(forKey: "name")
        labelEmail.text = UDM.shared.defaults.string(forKey: "email")
        let profilePath =  "\(AppConstant.BASEURL)/\(UDM.shared.defaults.string(forKey: "image") ?? "")"
        imgProfile.sd_setImage(with: URL(string: profilePath))

    }
    
    @objc func onTapLogOut(){
        
        userModel.logout(){ [weak self] (result) in
            guard let self = self else {return }
            if result{
                UDM.shared.defaults.removeObject(forKey: "token")
                UDM.shared.defaults.removeObject(forKey: "name")
                UDM.shared.defaults.removeObject(forKey: "email")
                UDM.shared.defaults.removeObject(forKey: "phone")

                let realm = try! Realm()
                try! realm.write {
                    realm.deleteAll()
                }
                self.navigateToLoginVeiwController()
            }
            else{
                self.showAlert(message: "Something went wrong!")
                
            }
        }
       
        
//        UDM.shared.defaults.removeObject(forKey: "token")
//        UDM.shared.defaults.removeObject(forKey: "name")
//        UDM.shared.defaults.removeObject(forKey: "email")
//        UDM.shared.defaults.removeObject(forKey: "phone")
//
//        let realm = try! Realm()
//        try! realm.write {
//            realm.deleteAll()
//        }
        
        
    }

  

}
