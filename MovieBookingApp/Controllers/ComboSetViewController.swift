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
                self.setupUI()
            case .failure(let error):
                debugPrint(error)
            }
    
            
        }
        
    }
    
    private func setupUI(){
        let comboPrice = priceList.reduce(0, +)
        totalPrice = (checkOut?.totalPrice ?? 0) + comboPrice
    
        lableTotal.text = "Sub total: \(totalPrice) $" 
        btnPay.setTitle("Pay for : \(totalPrice)", for: .normal)
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
        self.dismiss(animated: true, completion: nil)
    }
    
  
    @objc func onTapPay(){
        var snackOrders = [SnackCheckOut]()
        if orderSnackList.count > 0{
            orderSnackList.forEach{
                snackOrders.append(SnackCheckOut(id: $0.id, quantity: $0.count))
            }
            
            checkOutModel.saveCheckOut(checkout: CheckOut(
                cinemaDayTimeSlotId: checkOut?.cinemaDayTimeSlotId,
                row: checkOut?.row,
                seatNumber: checkOut?.seatNumber,
                bookingDate: checkOut?.bookingDate,
                totalPrice: totalPrice,
                movieId: checkOut?.movieId,
                cardId: nil,
                cinemaId: checkOut?.cinemaId,
                snacks: snackOrders,
                cinemaTimeSlot: checkOut?.cinemaTimeSlot,
                movieName: checkOut?.movieName,
                cinemaName: checkOut?.cinemaName,
                moviePoseter: checkOut?.moviePoseter,
                bookingNo: "",
                qrcode: ""
            ))
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
            cell.onTapPlus = { name in
                
                self.priceList.removeAll()
                self.orderSnackList.removeAll()
                
                
                for j in 0 ..< self.snackList.count{
                    var snackVO: SnackVO = self.snackList[j]
                    if name == snackVO.name{
                        snackVO.changeCount(count: snackVO.count + 1)
                    }
                    self.snackList[j] = snackVO
                    
                    if self.snackList[j].count > 0 {
                        self.priceList.append((self.snackList[j].price ?? 0 ) * self.snackList[j].count)
                        self.orderSnackList.append(self.snackList[j])

                    }
                }
                self.setupUI()
                self.tableViewComboSets.reloadData()
            }
            
            cell.onTapMinus = { name in
                self.priceList.removeAll()
                self.orderSnackList.removeAll()
                
                for j in 0 ..< self.snackList.count{
                    var snackVO: SnackVO = self.snackList[j]
                    if name == snackVO.name{
                        if snackVO.count > 0{
                            snackVO.changeCount(count: snackVO.count - 1)

                        }
                    }
                    self.snackList[j] = snackVO
                    if self.snackList[j].count > 0 {
                        self.priceList.append((self.snackList[j].price ?? 0 ) * self.snackList[j].count)
                        self.orderSnackList.append(self.snackList[j])


                    }
                }
                self.setupUI()
                self.tableViewComboSets.reloadData()
            }
            
            
            return cell
               
        }else{
            let cell = tableView.dequeueCell(identifier: CardTableViewCell.identifier, indexPath: indexPath) as CardTableViewCell
            cell.data = paymentList[indexPath.row]

            //cell.delegate = self
            return cell
        }
        
    
        
       
    }
    
 
    
  
    
    
    
}

