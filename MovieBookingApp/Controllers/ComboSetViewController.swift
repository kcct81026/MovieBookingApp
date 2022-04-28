//
//  ComboSetViewController.swift
//  MovieBookingApp
//
//  Created by KC on 22/02/2022.
//

import UIKit

class ComboSetViewController: UIViewController {

    @IBOutlet weak var tableCardHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableComboSetHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnPay: UIButton!
    @IBOutlet weak var tableViewCards: UITableView!
    @IBOutlet weak var tableViewComboSets: UITableView!
    @IBOutlet weak var textFieldPromo: UITextField!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lableTotal: UILabel!
    
    private var checkOut : CheckOut?
    private var checkOutModel : CheckOutModel = CheckOutModelImpl.shared
    private var comboModel : ComboModel = ComboModelImpl.shared
    private var snackList =  [SnackVO]()
    private var paymentList = [PaymentVO]()
    private var priceList = [Int]()
    private var totalPrice = 0
    private var orderSnackList = [SnackVO]()


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()
        setUpTableViewCells()
        fetchCheckOut()
        fetchPayment()
        fetchSnackList()


    }
    
    private func fetchPayment(){
        comboModel.getPayment{ [weak self] (result) in
            guard let self = self else { return }
            switch result{
            case .success(let data):
                self.paymentList = data
                self.setUpHeightForPayment()
                self.tableViewCards.reloadData()
            case .failure(let message):
                print(message)
            }
        }
    }
    
    private func fetchSnackList(){
        comboModel.getSnacks{ [weak self] (result) in
            guard let self = self else { return }
            switch result{
            case .success(let data):
                self.snackList = data
                self.setUpHeightForSnacks()
                self.tableViewComboSets.reloadData()
            case .failure(let message):
                print(message)
            }
        }
    }
    
    private func fetchCheckOut(){
        checkOutModel.getCheckOut(){ [weak self] (result) in
            guard let self = self else {return }
            switch result{
            case .success(let result):
                self.checkOut = result
                self.checkTotalPrice()
            case .failure(let error):
                debugPrint(error)
            }
    
            
        }
        
    }
    
    private func checkTotalPrice(){
        let comboPrice = priceList.reduce(0, +)
        totalPrice = (checkOut?.totalPrice ?? 0) + comboPrice
    
        lableTotal.text = "Sub total: \(totalPrice) $"
        btnPay.setTitle("Pay for : \(totalPrice)", for: .normal)
    }
    
    private func calculatePrice(){
        priceList.removeAll()
        orderSnackList.removeAll()
        snackList.forEach{
            if $0.count > 0 {
                self.priceList.append(($0.price ?? 0 ) * $0.count)
                self.orderSnackList.append($0)

            }
        }
        checkTotalPrice()
        tableViewComboSets.reloadData()
    }
    
    
    private func setUpTableViewCells(){
        tableViewComboSets.dataSource = self
        tableViewCards.dataSource = self
        tableViewComboSets.registerForCell(identifier: ComboSetTableViewCell.identifier)
        tableViewCards.registerForCell(identifier: CardTableViewCell.identifier)
    }
    
    private func setUpViews(){
        btnPay.addBorderColor(radius: 8, color: UIColor.white.cgColor, borderWidth: 1)
        btnPay.isUserInteractionEnabled = true
        btnPay.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapPay)))
        
        btnBack.isUserInteractionEnabled = true
        btnBack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapBack)))
        
        textFieldPromo.addBottomBorder()
        textFieldPromo.setLeftPaddingPoints(12)
        textFieldPromo.setRightPaddingPoints(12)
        textFieldPromo.font = UIFont.italicSystemFont(ofSize: 16)
    }
    private func setUpHeightForPayment(){
        tableCardHeightConstraint.constant = CGFloat(55 *  paymentList.count )
      
    }
    
    private func setUpHeightForSnacks(){
        tableComboSetHeightConstraint.constant = CGFloat(95 * snackList.count)
    }
    
   
    
    
    @objc func onTapBack(){
        self.navigationController?.popViewController(animated: true)
    }
    
  
    @objc func onTapPay(){
        var snackOrders = [SnackCheckOut]()
        if orderSnackList.count > 0{
            orderSnackList.forEach{
                snackOrders.append(SnackCheckOut(id: $0.id, quantity: $0.count))
            }
            checkOut?.totalPrice = totalPrice
            checkOut?.snacks = snackOrders
            if let checkOut = checkOut {
                checkOutModel.saveCheckOut(checkout: checkOut)
            }
            navigateToPaymentVeiwController()
        }
        else{
            self.showInfo(message: "Please choose combo set!")
        }
        
    }
   
}

extension ComboSetViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tableViewComboSets{
            return snackList.count
        }
        else{
            return paymentList.count
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == tableViewComboSets{
            let cell = tableView.dequeueCell(identifier: ComboSetTableViewCell.identifier, indexPath: indexPath) as ComboSetTableViewCell
            cell.data = snackList[indexPath.row] // data binding
            cell.onTapPlus = {
                self.calculatePrice()
            }
            
            cell.onTapMinus = {
                self.calculatePrice()
            }
            return cell
               
        }else{
            let cell = tableView.dequeueCell(identifier: CardTableViewCell.identifier, indexPath: indexPath) as CardTableViewCell
            cell.data = paymentList[indexPath.row]
            return cell
        }
       
    }
}

