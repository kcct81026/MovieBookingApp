//
//  ViewExtensions.swift
//  MovieBookingApp
//
//  Created by KC on 20/02/2022.
//

import Foundation
import UIKit

extension UICollectionViewCell{
    static var identifier: String{
        String(describing: self)
    }
}

extension UICollectionView{
    func registerForCell(identifier:String){
        register(UINib(nibName: identifier, bundle: nil), forCellWithReuseIdentifier: identifier)
    }
    
    func dequeueCell<T:UICollectionViewCell>(identifier:String, indexPath: IndexPath)->T{
        guard let cell = dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? T else{
            return UICollectionViewCell() as! T
        }
        return cell
    }
}


extension UITableViewCell{
    static var identifier:String{
        String(describing: self)
    }
}

extension UILabel{
    func setMargins(margin: CGFloat = 10) {
            if let textString = self.text {
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.firstLineHeadIndent = margin
                paragraphStyle.headIndent = margin
                paragraphStyle.tailIndent = -margin
                let attributedString = NSMutableAttributedString(string: textString)
                attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
                attributedText = attributedString
            }
    }
    
    
}

extension UIView {
    func addBorderColorView(radius:CGFloat, color: CGColor, borderWidth: CGFloat ){
        self.layer.cornerRadius = radius
        self.layer.borderColor = color
        self.layer.borderWidth = borderWidth
    }
}

extension UITableView{
    func registerForCell(identifier:String){
        register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
    }
    
    func dequeueCell<T:UITableViewCell>(identifier:String, indexPath: IndexPath)->T{
        guard let cell = dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? T else{
            return UITableViewCell() as! T
        }
        return cell
    }
}

extension UIView{
    func addBorderColor(radius:CGFloat, color: CGColor, borderWidth: CGFloat ){
        self.layer.cornerRadius = radius
        self.layer.borderColor = color
        self.layer.borderWidth = borderWidth
    }
}

extension Sequence where Iterator.Element: Hashable {
    func unique() -> [Iterator.Element] {
        var seen: [Iterator.Element: Bool] = [:]
        return self.filter { seen.updateValue(true, forKey: $0) == nil }
    }
}

extension String {
    var isValidEmail: Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: self)
            
    }
}

//extension UIButton{
//    func addBorderColor(radius:CGFloat, color: CGColor, borderWidth: CGFloat ){
//        self.layer.cornerRadius = radius
//        self.layer.borderColor = color
//        self.layer.borderWidth = borderWidth
//    }
//}

extension UITextField {
    func addBottomBorder(){
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: self.frame.size.height - 1, width: self.frame.size.width, height: 1)
        bottomLine.backgroundColor = UIColor.lightGray.cgColor
        borderStyle = .none
        layer.addSublayer(bottomLine)
    }
    
    func setLeftPaddingPoints(_ amount:CGFloat){
           let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
           self.leftView = paddingView
           self.leftViewMode = .always
    }
    
    func setRightPaddingPoints(_ amount:CGFloat) {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
            self.rightView = paddingView
            self.rightViewMode = .always
    }
}

extension UIViewController{
    static var identifer: String{
        String(describing: self)
    }
}
