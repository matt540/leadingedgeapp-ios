//
//  AddNewCard_VC.swift
//  SurfBoard
//
//  Created by esparkbiz on 4/24/20.
//  Copyright © 2020 esparkbiz. All rights reserved.
//

import UIKit
import Stripe
import Alamofire

class AddNewCard_VC: BaseViewController,STPPaymentCardTextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let cardField = STPPaymentCardTextField()
    var cards = [AnyObject]()
    var picker:UIPickerView!
    var pickerCountry:UIPickerView!
    
    var arrState:NSMutableArray = []
    var arrCountry:NSMutableArray = []
    
    
    @IBOutlet var viewAddNewCard: UIView!
    @IBOutlet var btnAddNewCard: UIButton!
    
    @IBOutlet var txtCardName: UITextField!
    @IBOutlet var txtCardAddress: UITextField!
    @IBOutlet var txtCardApt: UITextField!
    @IBOutlet var txtCardCountry: UITextField!
    @IBOutlet var txtCardPostCode: UITextField!
    @IBOutlet var txtCardCity: UITextField!
    @IBOutlet var txtCardState: UITextField!
    @IBOutlet var cardView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        AppDelegate.shared().setupNavigationBar()
        self.title = "Add New Card"
        setLeftBarBackItem()
        setTranspertNavigation()

        self.viewAddNewCard.addCornerRadius(5)
        self.viewAddNewCard.layer.borderColor = #colorLiteral(red: 0.2784313725, green: 0.4549019608, blue: 0.5921568627, alpha: 1)
        self.viewAddNewCard.layer.borderWidth = 2
        
        self.btnAddNewCard.addCornerRadius(5)
        
        self.cardView.addSubview(cardField)
        self.cardView.backgroundColor = UIColor.clear
        self.cardField.backgroundColor = UIColor.white
        self.cardField.font = self.cardField.font.withSize(14)
        
        self.arrCountry = AppDelegate.shared().arrAllCountry
        
        self.picker = UIPickerView()
        self.picker.delegate = self
        self.picker.dataSource = self
        self.txtCardState.inputView = self.picker
        
        let numberToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 50))
        numberToolbar.barStyle = .default
        numberToolbar.items = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneClicked))]
        numberToolbar.sizeToFit()
        self.txtCardState.inputAccessoryView = numberToolbar
        
        self.pickerCountry = UIPickerView()
        self.pickerCountry.delegate = self
        self.pickerCountry.dataSource = self
        self.txtCardCountry.inputView = self.pickerCountry
        
        let numberToolbar1 = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 50))
        numberToolbar1.barStyle = .default
        numberToolbar1.items = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneClicked))]
        numberToolbar1.sizeToFit()
        self.txtCardCountry.inputAccessoryView = numberToolbar1
    }
    
    override func viewDidLayoutSubviews() {
        
        let padding: CGFloat = 0
        cardField.frame = CGRect(x: padding,
                                 y: padding,
                                 width: self.cardView.frame.size.width,
                                 height: self.cardView.frame.size.height)
        
    }
    
    @objc func doneClicked() -> Void
    {
        self.view.endEditing(true)
    }
    
    //MARK: - tapConfirmPayment Method
    @IBAction func tapConfirmPayment1(_ sender: Any) {
        
        if(cardField.cardNumber == "" || cardField.cvc == "" || self.txtCardName.text! == "" || self.txtCardAddress.text! == "" || self.txtCardState.text! == "" || self.txtCardCity.text! == "" )
        {
            displayAlert(APPNAME, andMessage: "Please Fill All Details.")
        }
        else
        {
            self.sendCard()
        }
    }
    
    //MARK: - sendCard Method
    @IBAction func sendCard() {
        
        let cardParams = STPCardParams()
        cardParams.number = cardField.cardNumber
        cardParams.expMonth = (cardField.expirationMonth)
        cardParams.expYear = (cardField.expirationYear)
        cardParams.cvc = cardField.cvc
        
        cardParams.name = self.txtCardName.text!
        cardParams.address.line1 = self.txtCardAddress.text!
        cardParams.address.line2 = self.txtCardApt.text!
        cardParams.address.postalCode = self.txtCardPostCode.text!
        cardParams.address.city = self.txtCardCity.text!
        cardParams.address.state = self.txtCardState.text!
        cardParams.address.country = self.txtCardCountry.text!
        
        let result = UserDefaults.standard.value(forKey: "UserAllData") as? NSDictionary
        let custID = result?.value(forKeyPath: "customer_id") as? String
        
        //check if the customerId exist
        if let custId = custID {
            //if yes, call the createCard method of our stripeUtil object, pass customer id
            StripeUtil.shared.createCard(stripeId: custId, card: cardParams, completion: { (success) in
                //there is a new card !
                StripeUtil.shared.getCardsList(completion: { (result) in
                    if let result = result {
                        
                        var ArrCards = [AnyObject]()
                        var ArrDoubleCards = [AnyObject]()
                        
                        if(result.count != 0)
                        {
                            for cards in result
                            {
                                var count = 0
                                let FingerPrint = cards["fingerprint"] as? String
                                for AllCard in result
                                {
                                    let AllFingerPrint = AllCard["fingerprint"] as? String
                                    if(FingerPrint == AllFingerPrint)
                                    {
                                        count += 1
                                    }
                                    else
                                    {
                                        
                                    }
                                }
                                if(count > 1)
                                {
                                    ArrDoubleCards.append(cards)
                                }
                                else
                                {
                                    ArrCards.append(cards)
                                }
                            }
                            
                            print(result.count)
                            print(ArrCards.count)
                            print(ArrDoubleCards.count)
                            
                            if(ArrDoubleCards.count != 0)
                            {
                                ArrCards.append(ArrDoubleCards[0])
                            }
                            
                            self.cards = ArrCards
                            print(self.cards.count)
                            print(self.cards)
                            
                        }
                        else
                        {
                            self.cards = []
                        }
                    }
                    //store results on our cards, clear textfield and reload tableView
                    DispatchQueue.main.async {
                        
                        self.txtCardName.text! = ""
                        self.txtCardAddress.text! = ""
                        self.txtCardApt.text! = ""
                        self.txtCardPostCode.text! = ""
                        self.txtCardState.text! = ""
                        self.txtCardCity.text! = ""
                        self.txtCardCountry.text! = ""
                        
                        self.cardField.clear()
                        displayAlert(APPNAME, andMessage: "Added Successfully")
                        self.navigationController?.popViewController(animated: true)
                    }
                })
            })
        }
        else
        {
            displayAlert(APPNAME, andMessage: "customerId not exist")
            print("customerId not exist")
        }
        
        //        AppDelegate.shared().HideSpinnerView()
    }
    
    
    //MARK: - UIPickerviewDelegate and Datasource methods -
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        if(pickerView == self.pickerCountry)
        {
            return self.arrCountry.count
        }
        else
        {
            return self.arrState.count
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        if(pickerView == self.pickerCountry)
        {
            let dictdata = self.arrCountry[row] as? NSDictionary
            let country = dictdata?.value(forKey: "name") as? String
            return country
        }
        else
        {
            let dictdata = self.arrState[row] as? NSDictionary
            let state = dictdata?.value(forKey: "name") as? String
            return state
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if(pickerView == self.pickerCountry)
        {
            let dictdata = self.arrCountry[row] as? NSDictionary
            let country = dictdata?.value(forKey: "name") as? String
            self.txtCardCountry.text = country
            
            self.arrState = []
            let arr = dictdata?.value(forKey: "states") as? NSArray
            for dict in arr!
            {
                self.arrState.add(dict)
            }
            
        }
        else
        {
            let dictdata = self.arrState[row] as? NSDictionary
            let state = dictdata?.value(forKey: "name") as? String
            self.txtCardState.text = state
        }
        
    }
    

}
