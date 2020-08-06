//
//  Create_PM_VC.swift
//  SurfBoard
//
//  Created by esparkbiz on 3/30/20.
//  Copyright © 2020 esparkbiz. All rights reserved.
//

import UIKit
import Stripe
import Alamofire

class Create_PM_VC: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    
    let cardField = STPPaymentCardTextField()
    var PaymentMethodID:String = ""
    var stripeTool =  StripeTools()
    var cards:NSMutableArray = []
    var ClientSecret:String!
    var SubID:String!
    
    @IBOutlet var cardView: UIView!
    @IBOutlet var btnSubmit: UIButton!
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var tableViewHeight: NSLayoutConstraint!
    
    @IBOutlet var lblMembershipFees: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.separatorStyle = .none
        
        self.navigationController?.isNavigationBarHidden = false
        AppDelegate.shared().setupNavigationBar()
        self.title = "Payment"
        setLeftBarBackItem()
        setTranspertNavigation()
        
        self.btnSubmit.addCornerRadius(5)
        
        self.cardView.addSubview(cardField)
        self.cardView.backgroundColor = UIColor.clear
        self.cardField.backgroundColor = UIColor.white
        self.cardField.font = self.cardField.font.withSize(14)
        
        self.Get_Membership_Fees()
    }
    
    
    override func viewDidLayoutSubviews() {
        
        let padding: CGFloat = 0
        cardField.frame = CGRect(x: padding,
                                 y: padding,
                                 width: self.cardView.frame.size.width,
                                 height: self.cardView.frame.size.height)
        
    }
    
    //MARK: - btnSubmit Method
    @IBAction func btnSubmit(_ sender: Any) {
        
        if(cardField.cardNumber == "" || cardField.cardNumber == nil || cardField.cvc == "" || cardField.cvc == nil)
        {
            displayAlert(APPNAME, andMessage: "Please Fill All Details.")
        }
        else
        {
            self.Get_Payment_Method()
        }
        
    }
    
    //MARK:- TableView
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CardListCell") as! CardListCell
        
        let cardString:String!
        
        let Dictdata = self.cards[indexPath.row] as? NSMutableDictionary
        let DictCard = Dictdata?.value(forKeyPath: "card") as? NSMutableDictionary
        let Brand = DictCard?.value(forKeyPath: "brand") as? String
        
        if Brand == "Visa"{
            cell.imageView?.image = UIImage(imageLiteralResourceName: "visa@2x.png")
            cardString = "VISA_CARD_WITH".localize
        }
        else if Brand == "MasterCard"{
            cell.imageView?.image = UIImage(imageLiteralResourceName: "mastercard@2x.png")
            cardString = "MASTER_CARD_WITH".localize
        }
        else if Brand == "American Express"{
            cell.imageView?.image = UIImage(imageLiteralResourceName: "amex@2x.png")
            cardString = "AMERICAN_CARD_WITH".localize
        }
        else if Brand == "Discover"{
            cell.imageView?.image = UIImage(imageLiteralResourceName: "discover@2x.png")
            cardString = "DISCOVER_CARD_WITH".localize
        }
        else if Brand == "JCB"{
            cell.imageView?.image = UIImage(imageLiteralResourceName: "jcb@2x.png")
            cardString = "JCB_CARD_WITH".localize
        }
        else if Brand == "Laser"{
            cell.imageView?.image = UIImage(imageLiteralResourceName: "laser@2x.png")
            cardString = "LASER_CARD_WITH".localize
        }
        else if Brand == "Diners Club"{
            cell.imageView?.image = UIImage(imageLiteralResourceName: "dinersclubintl@2x.png")
            cardString = "DINERS_CARD_WITH".localize
        }
        else{
            cell.imageView?.image = UIImage(named: "default@2x.png")
            cardString = "CARD_WITH".localize
        }
        
        let last4 = DictCard?.value(forKeyPath: "last4") as? String
        cell.lblCardNumber.text = cardString
        cell.lblLast4.text = last4
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let Dictdata = self.cards[indexPath.row] as? NSMutableDictionary
        self.PaymentMethodID = (Dictdata?.value(forKeyPath: "id") as? String)!
        
        if(self.PaymentMethodID != ""){
            self.Create_Membership()
        }
        
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
    
    
    
    //MARK: - API Method
    func Get_Payment_Method() {
        
        let url = "https://api.stripe.com/v1/payment_methods"
        
        let header = ["Content-Type":"application/x-www-form-urlencoded",
                      "Authorization": StripeTools.shared.getBasicAuth()
        ]
        
        let params: [String: Any] = ["type": "card",
                                     "card[number]": cardField.cardNumber!,
                                     "card[exp_month]": cardField.expirationMonth,
                                     "card[exp_year]": cardField.expirationYear,
                                     "card[cvc]": cardField.cvc!
        ]
        
        if NetworkReachabilityManager()?.isReachable == true
        {
            AppDelegate.shared().ShowSpinnerView()
            Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: header).response { (response) in
                AppDelegate.shared().HideSpinnerView()
                do
                {
                    let dict = try? JSONSerialization.jsonObject(with: response.data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSMutableDictionary
                    if dict?.count==0 || dict == nil
                    {
                        displayAlert(APPNAME, andMessage: MSG.NO_RESPONSE)
                    }
                    else
                    {
                        print(dict!)
                        let status = dict?.value(forKeyPath: "error") as? NSMutableDictionary
                        if(status != nil)
                        {
                            displayAlert(APPNAME, andMessage: (dict?.value(forKeyPath: "error.message") as? String)!)
                        }
                        else
                        {
                            print(dict!)
                            self.PaymentMethodID = dict?.value(forKey: "id") as? String ?? ""
                            if(self.PaymentMethodID != "" || self.PaymentMethodID != nil){
                                print(self.PaymentMethodID)
                                self.Create_Membership()
                            }
                            else
                            {
                                displayAlert(APPNAME, andMessage:"PaymentMethodID Not Found")
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
    
    func Confirm_Subscription() {
        
        let url = API.BASE_URL + API.CONFIRM_SUBSCRIPTION
        
        let header = ["Content-Type":"application/x-www-form-urlencoded",
                      "Authorization": "Bearer \(AppPrefs.shared.getUserId())"
        ]
        
        let params: [String: Any] = ["subscriptionId": self.SubID!]
        
        if NetworkReachabilityManager()?.isReachable == true
        {
            AppDelegate.shared().ShowSpinnerView()
            Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: header).response { (response) in
                AppDelegate.shared().HideSpinnerView()
                do
                {
                    let dict = try? JSONSerialization.jsonObject(with: response.data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSMutableDictionary
                    if dict?.count==0 || dict == nil
                    {
                        displayAlert(APPNAME, andMessage: MSG.NO_RESPONSE)
                    }
                    else
                    {
                        let status = dict?.value(forKeyPath: "status") as? String
                        if(status == "error")
                        {
                            displayAlert(APPNAME, andMessage: (dict?.value(forKeyPath: "message") as? String ?? MSG.SOMETHINGWRONG)!)
                        }
                        else
                        {
                            print(dict!)
                            
                            let alert = UIAlertController(title: APPNAME, message:"Congratulations \n Your Membership is Activated", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(status) in
                                self.navigationController?.popViewController(animated: true)
                                
                            }))
                            self.present(alert, animated: true, completion: nil)

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
    
    func Create_Membership() {
        
        let url = API.BASE_URL + API.CREATE_MEMBERSHIP
        
        let header = ["Content-Type":"application/x-www-form-urlencoded",
                      "Authorization": "Bearer \(AppPrefs.shared.getUserId())"
        ]
        
        let params: [String: Any] = ["pm": self.PaymentMethodID]
        
        if NetworkReachabilityManager()?.isReachable == true
        {
            AppDelegate.shared().ShowSpinnerView()
            Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: header).response { (response) in
                AppDelegate.shared().HideSpinnerView()
                do
                {
                    let dict = try? JSONSerialization.jsonObject(with: response.data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSMutableDictionary
                    if dict?.count==0 || dict == nil
                    {
                        displayAlert(APPNAME, andMessage: MSG.NO_RESPONSE)
                    }
                    else
                    {
                        print(dict!)
                        let status = dict?.value(forKeyPath: "status") as? String
                        if(status == "error")
                        {
                            displayAlert(APPNAME, andMessage: (dict?.value(forKeyPath: "message") as? String ?? MSG.SOMETHINGWRONG)!)
                        }
                        else
                        {
                            print(dict!)
                            
                            let dictData = dict?.value(forKey: "data") as? NSMutableDictionary
                            self.SubID = dictData?.value(forKey: "id") as? String
                            let LatestInvoice = dictData?.value(forKey: "latest_invoice") as? NSMutableDictionary
                            let PaymentMethod = LatestInvoice?.value(forKey: "payment_intent") as? NSMutableDictionary
                            self.ClientSecret = PaymentMethod?.value(forKey: "client_secret") as? String
                            let Status = PaymentMethod?.value(forKey: "status") as? String
                            
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
                                            
                                            self.Confirm_Subscription()
                                            
                                        }
                                        break
                                    @unknown default:
                                        fatalError()
                                        break
                                    }
                                })
                                
                            }
                            else{
                                
                                let alert = UIAlertController(title: APPNAME, message:"Congratulations \n Your Membership is Activated", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(status) in
                                    self.navigationController?.popViewController(animated: true)
                                    
                                }))
                                self.present(alert, animated: true, completion: nil)
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
    
    func Get_Default_PaymentMethod() {
        
        let result = UserDefaults.standard.value(forKey: "UserAllData") as? NSDictionary
        let custID = result?.value(forKeyPath: "customer_id") as? String
        
        let url = "https://api.stripe.com/v1/payment_methods?customer=\(custID!)&type=card"
        
        let header = ["Authorization": self.stripeTool.getBasicAuth()
        ]
        
        if NetworkReachabilityManager()?.isReachable == true
        {
            AppDelegate.shared().ShowSpinnerView()
            Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.httpBody, headers: header).response { (response) in
                AppDelegate.shared().HideSpinnerView()
                do
                {
                    let dict = try? JSONSerialization.jsonObject(with: response.data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSMutableDictionary
                    if dict?.count==0 || dict == nil
                    {
                        displayAlert(APPNAME, andMessage: MSG.NO_RESPONSE)
                    }
                    else
                    {
                        print(dict!)
                        let ArrData = dict?.value(forKeyPath: "data") as? NSMutableArray
                        var Count:Int = 0
                        
                        if(ArrData!.count != 0)
                        {
                           for cards in ArrData!
                            {
                                Count += 1
                                if(Count == 1){
                                    let Arr = cards as? NSMutableDictionary
                                    self.cards.add(Arr!)
                                }
                                
                            }
                            
                        }
                        print(ArrData![0])
                        print(self.cards)
                        
                        self.tableViewHeight.constant = CGFloat(self.cards.count * 70 + 25)
                        self.tableView.reloadData()
                        self.view.updateConstraintsIfNeeded()
                    }
                }
            }
        }
        else
        {
            displayAlert(APPNAME, andMessage: MSG.NO_NETWORK)
        }
    }
    
    func Get_Membership_Fees() {
        
        let url = API.BASE_URL + API.GET_MEMBERSHIP_FEES
        let header = ["Content-Type":"application/x-www-form-urlencoded",
                      "Authorization": "Bearer \(AppPrefs.shared.getUserId())"
        ]
        
        if NetworkReachabilityManager()?.isReachable == true
        {
            AppDelegate.shared().ShowSpinnerView()
            Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.httpBody, headers: header).response { (response) in
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
                            let Membership_Fees = dictData?.value(forKey: "price") as? String ?? ""
                            
                            if(Membership_Fees != ""){
                                self.lblMembershipFees.text = "Membership Amount : $\(Membership_Fees)"
                                self.btnSubmit.setTitle("Continue To Pay $\(Membership_Fees)", for: .normal)
                                self.Get_Default_PaymentMethod()
                            }
                            else{
                                displayAlertWithOneOptionAndAction(APPNAME, andMessage: "Error Fetching Membership Amount.") {
                                    self.navigationController?.popViewController(animated: true)
                                }
                            }
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
}


extension Create_PM_VC: STPAuthenticationContext {
    func authenticationPresentingViewController() -> UIViewController {
        return self
    }
}
