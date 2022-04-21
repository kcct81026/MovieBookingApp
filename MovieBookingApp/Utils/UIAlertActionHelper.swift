//
//  UIAlertActionHelper.swift
//  MovieBookingApp
//
//  Created by KC on 05/04/2022.
//

import Foundation
import Alamofire

extension UIViewController {
    
    func startLoading(yConstraint: Int = 0) {
        let loaderColor = UIColor.black
        let activityIndicator : UIActivityIndicatorView = {
            let ui = UIActivityIndicatorView()
            ui.translatesAutoresizingMaskIntoConstraints = false
            ui.style = UIActivityIndicatorView.Style.large
            ui.color = loaderColor
            ui.startAnimating()
            return ui
        }()
        
        let viewcontroller = self
        
        viewcontroller.view.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: viewcontroller.view.centerXAnchor, constant: 0).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: viewcontroller.view.centerYAnchor, constant: CGFloat(yConstraint)).isActive = true
        activityIndicator.startAnimating()
    }
    
    func stopLoading() {
        let viewcontroller = self
        
        if let activityIndicator = viewcontroller.view.subviews.last,
           ((activityIndicator as? UIActivityIndicatorView) != nil){
            activityIndicator.removeFromSuperview()
        } else {
            print("Failed to stop loading")
        }
    }
    
    func showAlert(title: String,message: String?,handler:(() -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action:UIAlertAction) in
            if let callback = handler {
                callback()
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlertYesNo(title: String,
                        message: String?,
                        actionYesText: String = "OK",
                        actionNoText: String = "Cancel",
                        actionYesStyle : UIAlertAction.Style = .default,
                        actionNoStyle : UIAlertAction.Style = .cancel,
                        handlerYes:(() -> Void)?,
                        handlerNo:(() -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionYesText, style: actionYesStyle, handler: { (action:UIAlertAction) in
            if let callback = handlerYes {
                callback()
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }))
        alert.addAction(UIAlertAction(title: actionNoText, style: actionNoStyle, handler: { (action:UIAlertAction) in
            if let callback = handlerNo {
                callback()
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    public func showAlert(title : String = "Error", message : String) {
        DispatchQueue.main.async {
            let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertVC, animated: true, completion: nil)
        }
    }
    
    public func showAlert(title : String = "Error", message : String, onClickOk: ((UIAlertAction)->Void)?) {
        DispatchQueue.main.async {
            let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: onClickOk))
            self.present(alertVC, animated: true, completion: nil)
        }
    }
    
    public func showInfo(title : String = "Info", message : String) {
        DispatchQueue.main.async {
            let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertVC, animated: true, completion: nil)
        }
    }
    
    public func promptYesNo(title : String = "", message : String, onClickOk: ((UIAlertAction)->Void)?, onClickCancel: ((UIAlertAction)->Void)?) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: { (alertAction) in
            onClickOk?(alertAction)
        }))
        alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (alertAction) in
            self.dismiss(animated: true, completion: nil)
            onClickCancel?(alertAction)
        }))
        self.present(alertVC, animated: true, completion: nil)
    }
    
    
}


