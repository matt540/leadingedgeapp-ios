//
//  Payment_VC.swift
//  SurfBoard
//
//  Created by esparkbiz on 1/3/20.
//  Copyright © 2020 esparkbiz. All rights reserved.
//

import UIKit
import Stripe
import Alamofire

class Payment_VC: BaseViewController,STPPaymentCardTextFieldDelegate,UITableViewDelegate,UITableViewDataSource,STPAddCardViewControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet var txtCardName: UITextField!
    @IBOutlet var txtCardAddress: UITextField!
    @IBOutlet var txtCardApt: UITextField!
    @IBOutlet var txtCardCountry: UITextField!
    @IBOutlet var txtCardPostCode: UITextField!
    @IBOutlet var txtCardCity: UITextField!
    @IBOutlet var txtCardState: UITextField!
    @IBOutlet var cardView: UIView!
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var tableViewHeight: NSLayoutConstraint!
    
    //    @IBOutlet var lblSelectCard: UILabel!
    //@IBOutlet var textField:UITextField!
    @IBOutlet var btnAddNewCard: UIButton!
    @IBOutlet var viewAddNewCard: UIView!

    //    @IBOutlet var viewSelectCard: UIView!
    //    @IBOutlet var viewSelectCardHeight: NSLayoutConstraint!
    
    //    @IBOutlet var viewNoCard: UIView!
    //    @IBOutlet var lblNoCardError: UILabel!
    //    @IBOutlet var viewNoCardHeight: NSLayoutConstraint!
    var picker:UIPickerView!
    var pickerCountry:UIPickerView!
    
    let cardField = STPPaymentCardTextField()
    //var paymentTextField:STPPaymentCardTextField!
    var dictData:NSMutableDictionary = [:]
    var dictInstructor:NSMutableDictionary = [:]
    var dictBoard:NSMutableDictionary = [:]
    var arrState:NSMutableArray = []
    var arrCountry:NSMutableArray = []
    
    var strID:Int!
    var Token:String!
    var strStringID:String!
    
    var isFromProg:Bool = false
    var TodayDate:String!
    var TodayTime:String!
    var Prog_Type:String!
    var Prog_Loc:String!
    var Amount:String!
    
    var ClientSecret:String!
    var CardID:String!
    var PaymentID:String!
    var JsonResponse:String!
    
    var StrDisInstructor:String!
    var StrDisBoard:String!
    var StrDisStartTime:String!
    var StrDisEndTime:String!
    
    var cards = [AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // CustomTabBar.shared.showTabNav()
        //        self.lblSelectCard.isHidden = true
        self.navigationController?.isNavigationBarHidden = false
        AppDelegate.shared().setupNavigationBar()
        self.title = "Payment"
        setLeftBarBackItem()
        setTranspertNavigation()
        
        self.arrCountry = AppDelegate.shared().arrAllCountry
//        self.arrState = AppDelegate.shared().arrAllState
        
        self.cardView.addSubview(cardField)
        self.cardView.backgroundColor = UIColor.clear
        self.cardField.backgroundColor = UIColor.white
        self.cardField.font = self.cardField.font.withSize(14)
        
        self.tableView.separatorStyle = .none
        self.btnAddNewCard.addCornerRadius(5)
        
        self.viewAddNewCard.addCornerRadius(5)
        self.viewAddNewCard.layer.borderColor = #colorLiteral(red: 0.2784313725, green: 0.4549019608, blue: 0.5921568627, alpha: 1)
        self.viewAddNewCard.layer.borderWidth = 2
        //
        //        self.viewNoCardHeight.constant = 0
        //        self.viewNoCard.isHidden = true
        //        self.lblNoCardError.isHidden = true
        //        self.view.updateConstraintsIfNeeded()
        //
        //        self.viewNoCard.addCornerRadius(10)
        //        self.viewNoCard.layer.borderColor = #colorLiteral(red: 0.2784313725, green: 0.4549019608, blue: 0.5921568627, alpha: 1)
        //        self.viewNoCard.layer.borderWidth = 2
        
        if(isFromProg == true)
        {
            self.strStringID = self.Prog_Loc
        }
        else
        {
            print(dictData)
            print(strID)
            self.strStringID = String(strID)
        }
        
        
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
        numberToolbar1.items = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneClickedCountry))]
        numberToolbar1.sizeToFit()
        self.txtCardCountry.inputAccessoryView = numberToolbar1
        
        let Session_Type = self.dictData["type"] as? String
        if(Session_Type == "discovery_lesson")
        {
            let Inst = String(self.dictInstructor["id"] as! Int)
            let Board = String(self.dictBoard["id"] as! Int)
            self.StrDisInstructor = Inst
            self.StrDisBoard = Board
            
            self.StrDisStartTime = self.dictData["user_start_time"] as? String
            self.StrDisEndTime = self.dictData["user_end_time"] as? String
        }
        
        if(Session_Type == "cruiser" || Session_Type == "explorer" || Session_Type == "sport" || Session_Type == "pro" || Session_Type == "certificate")
        {
            let Inst = String(self.dictInstructor["id"] as! Int)
            let Board = String(self.dictBoard["id"] as! Int)
            self.StrDisInstructor = Inst
            self.StrDisBoard = Board
            
            self.StrDisStartTime = self.dictData["user_start_time"] as? String
            self.StrDisEndTime = self.dictData["user_end_time"] as? String
        }
        if(Session_Type == "normal")
        {
            let Board = String(self.dictBoard["id"] as! Int)
            self.StrDisBoard = Board
            self.StrDisInstructor = ""
            self.StrDisStartTime = self.dictData["user_start_time"] as? String
            self.StrDisEndTime = self.dictData["user_end_time"] as? String
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
    
        
        let result = UserDefaults.standard.value(forKey: "UserAllData") as? NSDictionary
        let custID = result?.value(forKeyPath: "customer_id") as? String
        
        if (custID != "" || custID != nil)
        {
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
                    self.cardField.clear()
                    self.tableViewHeight.constant = CGFloat((self.cards.count * 80) + 25)
                    self.tableView.reloadData()
                    self.view.updateConstraintsIfNeeded()
                }
            })
        }
        else{
            
        }
    }
    
    //    override func viewDidLayoutSubviews() {
    //        if (!self.textField.isHidden) {
    //            paymentTextField = STPPaymentCardTextField(frame: textField.frame)
    //            //paymentTextField.frame = textField.frame
    //            paymentTextField.delegate = self
    //            self.view.addSubview(paymentTextField)
    //            self.textField.isHidden = true
    //        }
    //    }
    
    override func viewDidLayoutSubviews() {
        
        let padding: CGFloat = 0
        cardField.frame = CGRect(x: padding,
                                 y: padding,
                                 width: self.cardView.frame.size.width,
                                 height: self.cardView.frame.size.height)
        
    }
    
    //MARK: - doneClickedCountry Method
    @objc func doneClickedCountry() -> Void
    {
        self.view.endEditing(true)
        
        if(self.txtCardCountry.text! == "")
        {
            let dictdata = self.arrCountry[0] as? NSDictionary
            let country = dictdata?.value(forKey: "name") as? String
            self.txtCardCountry.text = country
            
            self.arrState = []
            let arr = dictdata?.value(forKey: "states") as? NSArray
            for dict in arr!
            {
                self.arrState.add(dict)
            }
            
        }
    }
    
    @objc func doneClicked() -> Void
    {
        self.view.endEditing(true)
        
        if(self.txtCardState.text! == "")
        {
            let dictdata = self.arrState[0] as? NSDictionary
            let state = dictdata?.value(forKey: "name") as? String
            self.txtCardState.text = state
        }
        
    }
    
    //MARK: - tapConfirmPayment Method
    @IBAction func tapConfirmPayment(_ sender: Any) {
        
        //        let addCardViewController = STPAddCardViewController()
        //        addCardViewController.delegate = self
        //        let navigationController = UINavigationController(rootViewController: addCardViewController)
        //        present(navigationController, animated: true)
        
        //        let config = STPPaymentConfiguration()
        //        config.requiredBillingAddressFields = .full
        //        config.publishableKey = "pk_test_bfcHaJ5DBAMWGCZDTwSAWhRt"
        //        let viewController = STPAddCardViewController(configuration: config, theme: STPTheme.default())
        //
        //        viewController.delegate = self
        //        let navigationController = UINavigationController(rootViewController: viewController)
        //        present(navigationController, animated: true, completion: nil)
        //        //viewController.apiClient = MockAPIClient()
        
        
        //        let paymentConfig = STPPaymentConfiguration.init()
        //        paymentConfig.requiredBillingAddressFields = .full
        //        paymentConfig.publishableKey = "pk_test_bfcHaJ5DBAMWGCZDTwSAWhRt"
        //        let addCardViewController = STPAddCardViewController(configuration: paymentConfig, theme: STPTheme.default())
        //
        //        addCardViewController.delegate = self
        //
        //        let navigationController = UINavigationController(rootViewController: addCardViewController)
        //        present(navigationController, animated: true, completion: nil)
        //        //self.navigationController?.pushViewController(addCardViewController, animated: true)
        
        
        if(cardField.cardNumber == "" || cardField.cvc == "" || self.txtCardName.text! == "" || self.txtCardAddress.text! == "" || self.txtCardState.text! == "" || self.txtCardCity.text! == "" )
        {
            displayAlert(APPNAME, andMessage: "Please Fill All Details.")
        }
        else
        {
            self.sendCard()
        }
        //
        ////                AppDelegate.shared().ShowSpinnerView()
        ////
        ////                let cardParams = STPCardParams()
        ////                cardParams.number = paymentTextField.cardNumber
        ////                cardParams.expMonth = (paymentTextField.expirationMonth)
        ////                cardParams.expYear = (paymentTextField.expirationYear)
        ////                cardParams.cvc = paymentTextField.cvc
        ////
        ////                //let card = paymentTextField.cardParams
        ////                STPAPIClient.shared().createToken(withCard: cardParams) { (token, error) in
        ////                    if error != nil  {
        ////                        AppDelegate.shared().HideSpinnerView()
        ////                        print("error: \(String(describing: error))")
        ////                        let alert = UIAlertController(title: "Problem", message: "There was a problem charging your card: \(error!.localizedDescription)", preferredStyle: .alert)
        ////                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(status) in
        ////                            self.navigationController!.popViewController(animated: true)
        ////                        }))
        ////                        self.present(alert, animated: true, completion: nil)
        ////                        return
        ////                    }
        ////                    else if let token = token {
        ////                        AppDelegate.shared().HideSpinnerView()
        ////                        self.Token = token.tokenId
        ////                        print("token:-",token)
        ////                        print("tokenId:-",token.tokenId)
        ////                        self.Payment_API()
        ////                    }
        ////                }
    }
    
    
    //MARK: - STPAddCardViewController Delegate Methods
    //    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
    //        //self.navigationController?.popViewController(animated: true)
    //        dismiss(animated: true, completion: nil)
    //    }
    //
    //    private func addCardViewController(_ addCardViewController: STPAddCardViewController, didCreateToken token: STPToken, completion: @escaping STPErrorBlock) {
    //        print("Token: \(token)")
    //        //self.navigationController?.popViewController(animated: true)
    //        dismiss(animated: true, completion: nil)
    //    }
    
    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func addCardViewController(_ addCardViewController: STPAddCardViewController, didCreatePaymentMethod paymentMethod: STPPaymentMethod, completion: @escaping STPErrorBlock) {
        
        dismiss(animated: true, completion: nil)
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
                        self.tableViewHeight.constant = CGFloat((self.cards.count * 80) + 25)
                        self.tableView.reloadData()
                        self.view.updateConstraintsIfNeeded()
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
    
    //MARK:- TableView
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        //only one section
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //count on our cards array
        return self.cards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CardListCell") as! CardListCell
        
        let cardString:String!
        
        let Brand = self.cards[indexPath.row]["brand"] as? String
        if Brand == "Visa"{
            cell.imageView?.image = UIImage(imageLiteralResourceName: "visa@2x.png")
            cardString = "Visa card ending with"
        }
        else if Brand == "MasterCard"{
            cell.imageView?.image = UIImage(imageLiteralResourceName: "mastercard@2x.png")
            cardString = "MasterCard card ending with"
        }
        else if Brand == "American Express"{
            cell.imageView?.image = UIImage(imageLiteralResourceName: "amex@2x.png")
            cardString = "American Express card ending with"
        }
        else if Brand == "Discover"{
            cell.imageView?.image = UIImage(imageLiteralResourceName: "discover@2x.png")
            cardString = "Discover card ending with"
        }
        else if Brand == "JCB"{
            cell.imageView?.image = UIImage(imageLiteralResourceName: "jcb@2x.png")
            cardString = "JCB card ending with"
        }
        else if Brand == "Laser"{
            cell.imageView?.image = UIImage(imageLiteralResourceName: "laser@2x.png")
            cardString = "Laser card ending with"
        }
        else if Brand == "Diners Club"{
            cell.imageView?.image = UIImage(imageLiteralResourceName: "dinersclubintl@2x.png")
            cardString = "Diners Club card ending with"
        }
        else{
            cell.imageView?.image = UIImage(named: "default@2x.png")
            cardString = "Card ending with"
        }
        
        let last4 = self.cards[indexPath.row]["last4"] as! String
        cell.lblCardNumber.text = cardString
        cell.lblLast4.text = last4
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let dict = self.cards[indexPath.row]
        print("dict:-> ",dict)
        self.CardID = dict.value(forKey: "id") as? String
        
        var AmountToDisplay:String = ""
        let Session_Type = self.dictData["type"] as? String
        let Cost = self.dictData["price"] as? String ?? ""
        
        if(isFromProg == true || Session_Type == "normal")
        {
            AmountToDisplay = self.Amount
        }
        else{
            AmountToDisplay = Cost
        }
        let Message = "Confirm Payment of $\(AmountToDisplay)?"
        
        let refreshAlert = UIAlertController(title: APPNAME, message: Message, preferredStyle: UIAlertController.Style.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            self.Create_Payment_Intent()
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            print("User Cancelled.")
        }))
        
        present(refreshAlert, animated: true, completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if self.cards.count == 0
        {
            let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 25))
            headerView.backgroundColor = UIColor.clear
            return headerView
        }
        
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 25))
        headerView.backgroundColor = #colorLiteral(red: 0.2784313725, green: 0.4549019608, blue: 0.5921568627, alpha: 1)
        headerView.addCornerRadius(5)
        
        let label = UILabel()
        label.frame = CGRect.init(x: 5, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
        label.text = "Select Card From Below To Complete Payment"
        label.textAlignment = .center
        label.font = label.font.withSize(15)
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        headerView.addSubview(label)
        
        return headerView
    }
    
    //MARK: - performAction Method
    private func performAction( completion: @escaping STPErrorBlock) {
        STPAPIClient.shared().retrievePaymentIntent(withClientSecret: self.ClientSecret, completion: { (retrievedIntent, retrieveError) in
            if retrieveError != nil {
                completion(retrieveError)
            } else {
                if let retrievedIntent = retrievedIntent {
                    self.confirmPaymentIntent(retrievedIntent
                        , completion: { (confirmedIntent, confirmError) in
                            if confirmError != nil {
                                completion(confirmError)
                            } else {
                                if let confirmedIntent: STPPaymentIntent = confirmedIntent {
                                    print(confirmedIntent)
                                } else {
                                    completion(NSError(domain: StripeDomain, code: 123, userInfo: [NSLocalizedDescriptionKey: "Error parsing confirmed payment intent"]))
                                }
                            }
                    })
                } else {
                    completion(NSError(domain: StripeDomain, code: 123, userInfo: [NSLocalizedDescriptionKey: "Error retrieving payment intent"]))
                }
            }
        })
    }
    
    //MARK: - confirmPaymentIntent Method
    func confirmPaymentIntent(_ paymentIntent: STPPaymentIntent, completion: @escaping STPPaymentIntentCompletionBlock) {
        
        let header = ["Content-Type":"application/x-www-form-urlencoded",
                      "Authorization": StripeTools.shared.getBasicAuth()
        ]
        let url = "https://api.stripe.com/v1/payment_intents/\(paymentIntent.stripeId)/confirm"
        //self.baseURL.appendingPathComponent("confirm_payment")
        
        
        let params: [String: Any] = ["payment_method": paymentIntent.paymentMethodId!]
        
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: header).response { (response) in
            do
            {
                let dict = try? JSONSerialization.jsonObject(with: response.data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSMutableDictionary
                print(dict!)
                
                let error = dict?.value(forKey: "error") as? NSMutableDictionary ?? [:]
                if(error.count != 0){
                    
                    let msg = error.value(forKey: "message") as? String ?? ""
                    if(msg == "You cannot confirm this PaymentIntent because it has already succeeded after being previously confirmed."){
                        
                        let dict = error.value(forKey: "payment_intent") as? NSMutableDictionary
                        let dictionary = dict
                        let jsonData = try? JSONSerialization.data(withJSONObject: dictionary!, options: [])
                        let jsonString = String(data: jsonData!, encoding: .utf8)
                        self.JsonResponse = jsonString
                        self.PaymentID = dict?.value(forKey: "id") as? String
                        
                        self.Payment_API()
                     }
                }
                
                else{
                    self.PaymentID = dict?.value(forKey: "id") as? String
                    let Status = dict?.value(forKey: "status") as? String
                    
                    print(Status!)
                    if(Status == "requires_source_action"){
                        
                        let paymentHandler = STPPaymentHandler.shared()
                        paymentHandler.handleNextAction(forPayment: self.ClientSecret, with: self, returnURL: nil, completion: { (status, paymentIntent, handleActionError) in
                            switch (status) {
                            case .failed:
                                displayAlert(APPNAME, andMessage: handleActionError?.localizedDescription ?? "")
                                break
                            case .canceled:
                                displayAlert(APPNAME, andMessage: handleActionError?.localizedDescription ?? "")
                                break
                            case .succeeded:
                                if let paymentIntent = paymentIntent, paymentIntent.status == STPPaymentIntentStatus.requiresConfirmation {
                                    print("Re-confirming PaymentIntent after handling action")
                                }
                                else {
                                    
                                    self.confirmPaymentIntent(paymentIntent!, completion: { (confirmedIntent, confirmError) in
                                        if confirmError != nil {
                                            displayAlert(APPNAME, andMessage: (confirmError?.localizedDescription)!)
                                        } else {
                                            if let confirmedIntent: STPPaymentIntent = confirmedIntent {
                                                print(confirmedIntent)
                                            } else {
                                                displayAlert(APPNAME, andMessage: (confirmError?.localizedDescription)!)
                                            }
                                        }
                                    })
                                }
                                break
                            @unknown default:
                                fatalError()
                                break
                            }
                        })
                        
                    }
                    else{
                        
                        let dictionary = dict
                        let jsonData = try? JSONSerialization.data(withJSONObject: dictionary!, options: [])
                        let jsonString = String(data: jsonData!, encoding: .utf8)
                        self.JsonResponse = jsonString
                        
                        self.Payment_API()
                        
                    }
                }
            }
        }
    }
    
    //MARK: - API Calls
    func Payment_API() {
        
        let url = API.BASE_URL + API.STRIPE_PAYMENT_NEW
        var param : [String:String] = ["":""]
        
        if(isFromProg == true)
        {
            param = ["type" : Prog_Type,
                     "date" : TodayDate,
                     "time_slot_id" : "",
                     "location_id" : Prog_Loc,
                     "cost" : Amount,
                     "token" : self.PaymentID,
                     "payment_intent" : self.JsonResponse]
        }
        else
        {
            let Date = self.dictData["date"] as? String ?? ""
            //let Time = self.dictData["timeID"] as? String ?? ""
            let Cost = self.dictData["price"] as? String ?? ""
            let Session_Type = self.dictData["type"] as? String
            let Session_ID = String(self.dictData["id"] as! Int)
            
            if(Session_Type == "discovery_lesson"){
                
                param = ["type" : Session_Type!,
                         "session_id" : Session_ID,
                         "date" : Date,
                         "location_id" : self.strStringID,
                         "cost" : Cost,
                         "instructor" : self.StrDisInstructor,
                         "board" : self.StrDisBoard,
                         "start_time" : self.StrDisStartTime,
                         "end_time" : self.StrDisEndTime,
                         "token" : self.PaymentID,
                         "payment_intent" : self.JsonResponse]
                
            }
            
            if(Session_Type == "cruiser" || Session_Type == "explorer" || Session_Type == "sport" || Session_Type == "pro")
            {
                param = ["type" : Session_Type!,
                         "date" : Date,
                         "location_id" : self.strStringID,
                         "cost" : Cost,
                         "instructor" : self.StrDisInstructor,
                         "board" : self.StrDisBoard,
                         "start_time" : self.StrDisStartTime,
                         "end_time" : self.StrDisEndTime,
                         "token" : self.PaymentID,
                         "payment_intent" : self.JsonResponse]
            }
            
            if(Session_Type == "normal")
            {
                
                param = ["type" : Session_Type!,
                         "date" : Date,
                         "location_id" : self.strStringID,
                         "cost" : self.Amount,
                         "instructor" : self.StrDisInstructor,
                         "board" : self.StrDisBoard,
                         "start_time" : self.StrDisStartTime,
                         "end_time" : self.StrDisEndTime,
                         "token" : self.PaymentID,
                         "payment_intent" : self.JsonResponse]
            }
            
            if(Session_Type == "certificate")
            {
                param = ["type" : Session_Type!,
                         "date" : Date,
                         "location_id" : self.strStringID,
                         "cost" : Cost,
                         "instructor" : self.StrDisInstructor,
                         "board" : self.StrDisBoard,
                         "start_time" : self.StrDisStartTime,
                         "end_time" : self.StrDisEndTime,
                         "token" : self.PaymentID,
                         "payment_intent" : self.JsonResponse]
            }
            else
            {
                
            }
            
        }
        
        print(param)
        let header = ["Content-Type":"application/x-www-form-urlencoded",
                      "Authorization": "Bearer \(AppPrefs.shared.getUserId())"
        ]
        
        if NetworkReachabilityManager()?.isReachable == true
        {
            AppDelegate.shared().ShowSpinnerView()
            Alamofire.request(url, method: .post, parameters: param, encoding: URLEncoding.httpBody, headers: header).response { (response) in
                AppDelegate.shared().HideSpinnerView()
                do
                {
                    let dict = try? JSONSerialization.jsonObject(with: response.data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSMutableDictionary
                    if dict?.count==0 || dict == nil
                    {
                        displayAlert(APPNAME, andMessage: "ERROR_RESPONSE".localize)
                    }
                    else
                    {
                        print(dict!)
                        let status = dict?.value(forKeyPath: "status") as? String ?? ""
                        if(status == "error")
                        {
                            displayAlert(APPNAME, andMessage: (dict?.value(forKeyPath: "message") as? String)!)
                        }
                        else
                        {
                            let alert = UIAlertController(title: APPNAME, message: (dict?.value(forKeyPath: "message") as? String)!, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(status) in
                                
                                AppDelegate.shared().isFromBooking = true
                                
                                (self.tabBarController?.selectedViewController as! UINavigationController).popToRootViewController(animated: false)
                                
                                //self.tabBarController?.selectedIndex = 2
                                
                                
                            }))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                }
            }
        }
        else
        {
            displayAlert(APPNAME, andMessage: "ERROR_NETWORK".localize)
        }
    }
    
    func Create_Payment_Intent() {
        
        let url = API.BASE_URL + API.CREATE_PAYMENT_INTENT
        let Time = self.dictData["timeID"] as? String ?? ""
        
        let Session_Type:String!
        if(isFromProg == true)
        {
            Session_Type = self.Prog_Type
        }
        else
        {
            Session_Type = self.dictData["type"] as? String
        }
        
        var param : [String:String] = ["":""]
        
        if(Session_Type == "discovery_lesson")
        {
            let SessionID = String(self.dictData["id"] as! Int)
            param = ["type" : Session_Type,"card" : self.CardID,"location_id" : self.strStringID,"session_id" : SessionID, "start_time" : self.StrDisStartTime, "end_time" : self.StrDisEndTime] as! [String : String]
        }
        if(Session_Type == "discovery_enrollment")
        {
            param = ["type" : Session_Type,"card" : self.CardID,"location_id" : self.strStringID] as! [String : String]
        }
        if(Session_Type == "cruiser" || Session_Type == "explorer" || Session_Type == "sport" || Session_Type == "pro")
        {
            param = ["type" : Session_Type,"card" : self.CardID,"location_id" : self.strStringID, "start_time" : self.StrDisStartTime, "end_time" : self.StrDisEndTime] as! [String : String]
        }
        
        if(Session_Type == "normal")
        {
            param = ["type" : Session_Type,"card" : self.CardID,"location_id" : self.strStringID, "start_time" : self.StrDisStartTime, "end_time" : self.StrDisEndTime] as! [String : String]
        }
        
        if(Session_Type == "certificate")
        {
            param = ["type" : Session_Type,"card" : self.CardID,"location_id" : self.strStringID, "start_time" : self.StrDisStartTime, "end_time" : self.StrDisEndTime] as! [String : String]
        }
        //        else
        //        {
        //            param = ["type" : Session_Type,"card" : self.CardID,"location_id" : self.strStringID] as! [String : String]
        //        }
        print(param)
        
        
        let header = ["Content-Type":"application/x-www-form-urlencoded",
                      "Authorization": "Bearer \(AppPrefs.shared.getUserId())"
        ]
        
        if NetworkReachabilityManager()?.isReachable == true
        {
            AppDelegate.shared().ShowSpinnerView()
            Alamofire.request(url, method: .post, parameters: param, encoding: URLEncoding.httpBody, headers: header).response { (response) in
                AppDelegate.shared().HideSpinnerView()
                do
                {
                    let dict = try? JSONSerialization.jsonObject(with: response.data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSMutableDictionary
                    if dict?.count==0 || dict == nil
                    {
                        displayAlert(APPNAME, andMessage: "ERROR_RESPONSE".localize)
                    }
                    else
                    {
                        
                        let status = dict?.value(forKeyPath: "status") as? String ?? ""
                        if(status == "error")
                        {
                            displayAlert(APPNAME, andMessage: (dict?.value(forKeyPath: "message") as? String)!)
                        }
                        else
                        {
                            print(dict!)
                            let dictData = dict?.value(forKey: "data") as? NSMutableDictionary
                            self.ClientSecret = dictData?.value(forKey: "client_secret") as? String
                            print(self.ClientSecret)
                            
                            self.performAction { (error) in
                                print(error as Any)
                            }
                        }
                    }
                }
            }
        }
        else
        {
            displayAlert(APPNAME, andMessage: MSG.NO_NETWORK)
        }
    }
    
    
}

extension Payment_VC: STPAuthenticationContext {
    func authenticationPresentingViewController() -> UIViewController {
        return self
    }
}
