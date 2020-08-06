//
//  Membership_VC.swift
//  SurfBoard
//
//  Created by esparkbiz on 4/20/20.
//  Copyright © 2020 esparkbiz. All rights reserved.
//

import UIKit
import Alamofire

class Membership_VC: BaseViewController,UITableViewDelegate,UITableViewDataSource,MakeDefaultPayment {
    
    
    var stripeTool =  StripeTools()
    var DictMemberData:NSMutableDictionary = [:]
    var cards = [AnyObject]()
    
    var PaymentMethod:String = ""
    var FlagPaymentMethod:Bool =  false
    var FromAddCard:Bool =  false
    
    var strStatus:String = ""
    var strCancelt_at_period_end:Bool = false
    var strPast_due:Bool = false
    var strAllow_start_membership:Bool = false
    
    var ButtonStatus:String = ""
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var tableViewHeight: NSLayoutConstraint!
    
    
    @IBOutlet var viewNotFound: UIView!
    @IBOutlet var viewNotFoundHeight: NSLayoutConstraint!
    @IBOutlet var lblNotFound: UILabel!
    
    @IBOutlet var lblMembershipDetails: UILabel!
    
    @IBOutlet var viewMembership: UIView!
    @IBOutlet var viewMembershipHeight: NSLayoutConstraint!
    
    @IBOutlet var viewLine: UIView!
    
    @IBOutlet var lblSubTitle: UILabel!
    @IBOutlet var lblPlanTitle: UILabel!
    @IBOutlet var lblCustTitle: UILabel!
    @IBOutlet var lblCostTitle: UILabel!
    @IBOutlet var lblStartTitle: UILabel!
    @IBOutlet var lblEndTitle: UILabel!
    @IBOutlet var lblStatusTitle: UILabel!
    
    @IBOutlet var lblSub: UILabel!
    @IBOutlet var lblPlan: UILabel!
    @IBOutlet var lblCust: UILabel!
    @IBOutlet var lblCost: UILabel!
    @IBOutlet var lblStart: UILabel!
    @IBOutlet var lblEnd: UILabel!
    @IBOutlet var lblStatus: UILabel!
    
    //Manage Card Section
    
    @IBOutlet var ManageCardFound: UIView!
    @IBOutlet var viewLine1: UIView!
    @IBOutlet var ManageCardFoundHeight: NSLayoutConstraint!
    @IBOutlet var lblManageCard: UILabel!
    
    //Cancel MemberShip Section
    @IBOutlet var viewCancelMembership: UIView!
    @IBOutlet var viewLine2: UIView!
    @IBOutlet var viewCancelMembershipHeight: NSLayoutConstraint!
    @IBOutlet var lblviewCancelMembership: UILabel!
    @IBOutlet var btnCancelMembership: UIButton!
    
    @IBOutlet var btnAddNewCard: UIButton!


    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.HideAllView()
        
        
        self.navigationController?.isNavigationBarHidden = false
        AppDelegate.shared().setupNavigationBar()
        setLeftBarBackItem()
        setTranspertNavigation()
        self.title = "Membership"
        
        let result = UserDefaults.standard.value(forKey: "UserAllData") as? NSDictionary
        let Certificatestatus = result?.value(forKeyPath: "certificate_status") as? Int
        let DiscoverySatus = result?.value(forKeyPath: "discover_lesson_status") as? Int
        let ProgressionStatus = result?.value(forKeyPath: "progression_model_status") as? Int
        
        if(Certificatestatus == 2 && DiscoverySatus == 2 && ProgressionStatus == 5){
            print("Eligible")
        }
        else if(Certificatestatus == 2 && DiscoverySatus == 0 && ProgressionStatus == 0){
            print("Eligible")
        }
        else{
            displayAlertWithOneOptionAndAction(APPNAME, andMessage: "You are not eligible for Membership \n \n To become a member please schedule a discovery session or continue through the Progression Program") {
                self.navigationController?.popViewController(animated: true)
            }
        }
        
        self.tableView.separatorStyle = .none

        self.viewNotFound.addCornerRadius(10)
        self.viewNotFound.layer.borderColor = #colorLiteral(red: 0.2784313725, green: 0.4549019608, blue: 0.5921568627, alpha: 1)
        self.viewNotFound.layer.borderWidth = 2
        
        self.viewMembership.addCornerRadius(10)
        self.viewMembership.layer.borderColor = #colorLiteral(red: 0.2784313725, green: 0.4549019608, blue: 0.5921568627, alpha: 1)
        self.viewMembership.layer.borderWidth = 2
        
        self.ManageCardFound.addCornerRadius(10)
        self.ManageCardFound.layer.borderColor = #colorLiteral(red: 0.2784313725, green: 0.4549019608, blue: 0.5921568627, alpha: 1)
        self.ManageCardFound.layer.borderWidth = 2
        
        self.viewCancelMembership.addCornerRadius(10)
        self.viewCancelMembership.layer.borderColor = #colorLiteral(red: 0.2784313725, green: 0.4549019608, blue: 0.5921568627, alpha: 1)
        self.viewCancelMembership.layer.borderWidth = 2
        
        self.btnCancelMembership.addCornerRadius(5)
        
        self.FETCH_MEMBERSHIP()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if(self.FromAddCard == true)
        {
            self.FromAddCard = false
            self.FETCH_MEMBERSHIP()
        }
        
    }
    
     //MARK: - DisplayErrorView Method
    func DisplayErrorView(){
        
        self.viewNotFound.isHidden = false
        self.lblNotFound.isHidden = false
        self.viewNotFoundHeight.constant = 30
        
        self.lblMembershipDetails.isHidden = true
        self.viewMembership.isHidden = true
        self.viewLine.isHidden = true
        self.viewMembershipHeight.constant = 0
        
        self.lblSubTitle.isHidden = true
        self.lblPlanTitle.isHidden = true
        self.lblCustTitle.isHidden = true
        self.lblCostTitle.isHidden = true
        self.lblStartTitle.isHidden = true
        self.lblEndTitle.isHidden = true
        self.lblStatusTitle.isHidden = true
        self.lblSub.isHidden = true
        self.lblPlan.isHidden = true
        self.lblCust.isHidden = true
        self.lblCost.isHidden = true
        self.lblStart.isHidden = true
        self.lblEnd.isHidden = true
        self.lblStatus.isHidden = true
        
        //Cancel Membership
        self.lblviewCancelMembership.isHidden = false
        self.viewCancelMembership.isHidden = false
        self.viewLine2.isHidden = false
        self.viewCancelMembershipHeight.constant = 100
        self.btnCancelMembership.isHidden = false
        //Cancel Membership
        
        self.view.updateConstraintsIfNeeded()
    }
    
    //MARK: - DisplayMemberView Method
    func DisplayMemberView(){
        
        self.viewNotFound.isHidden = true
        self.lblNotFound.isHidden = true
        self.viewNotFoundHeight.constant = 00
        
        self.lblMembershipDetails.isHidden = false
        self.viewMembership.isHidden = false
        self.viewLine.isHidden = false
        self.viewMembershipHeight.constant = 250
        
        //Card View
        self.lblManageCard.isHidden = false
        self.ManageCardFound.isHidden = false
        self.viewLine1.isHidden = false
        //Card View
        
        //Cancel Membership
        self.lblviewCancelMembership.isHidden = false
        self.viewCancelMembership.isHidden = false
        self.viewLine2.isHidden = false
        self.viewCancelMembershipHeight.constant = 100
        self.btnCancelMembership.isHidden = false
        //Cancel Membership
        
        self.lblSubTitle.isHidden = false
        self.lblPlanTitle.isHidden = false
        self.lblCustTitle.isHidden = false
        self.lblCostTitle.isHidden = false
        self.lblStartTitle.isHidden = false
        self.lblEndTitle.isHidden = false
        self.lblStatusTitle.isHidden = false
        self.lblSub.isHidden = false
        self.lblPlan.isHidden = false
        self.lblCust.isHidden = false
        self.lblCost.isHidden = false
        self.lblStart.isHidden = false
        self.lblEnd.isHidden = false
        self.lblStatus.isHidden = false
        
        self.view.updateConstraintsIfNeeded()
        
    }
    
    //MARK: - HideAllView Method
    func HideAllView(){
        
        self.viewNotFound.isHidden = true
        self.lblNotFound.isHidden = true
        self.viewNotFoundHeight.constant = 00
        
        self.lblMembershipDetails.isHidden = true
        self.viewMembership.isHidden = true
        self.viewLine.isHidden = true
        self.viewMembershipHeight.constant = 00
        
        //Card View
        self.lblManageCard.isHidden = true
        self.ManageCardFound.isHidden = true
        self.viewLine1.isHidden = true
        self.tableViewHeight.constant = 0
        //Card View
        
        //Cancel Membership
        self.lblviewCancelMembership.isHidden = true
        self.viewCancelMembership.isHidden = true
        self.viewLine2.isHidden = true
        self.viewCancelMembershipHeight.constant = 0
        self.btnCancelMembership.isHidden = true
        //Cancel Membership
        
        self.lblSubTitle.isHidden = true
        self.lblPlanTitle.isHidden = true
        self.lblCustTitle.isHidden = true
        self.lblCostTitle.isHidden = true
        self.lblStartTitle.isHidden = true
        self.lblEndTitle.isHidden = true
        self.lblStatusTitle.isHidden = true
        self.lblSub.isHidden = true
        self.lblPlan.isHidden = true
        self.lblCust.isHidden = true
        self.lblCost.isHidden = true
        self.lblStart.isHidden = true
        self.lblEnd.isHidden = true
        self.lblStatus.isHidden = true
        
        self.view.updateConstraintsIfNeeded()
        
    }
    
     //MARK: - Protocol Method
    func btnMakeDefaultAction(_ sender: Any?) {
        
        let cell = sender as! CardsCell
        let indexpath = self.tableView.indexPath(for: cell)
        let dictCard = self.cards[(indexpath?.row)!] as? NSMutableDictionary
        let CardID = dictCard!["id"] as? String
        
        self.MAKE_DEFAULT_PAYMENT_METHOD(card: CardID!)
        
    }
    
    //MARK: - SetupData Method
    func SetupData(){
        
        self.lblSub.text = DictMemberData.value(forKey: "subscription_id") as? String ?? "-"
        self.lblPlan.text = DictMemberData.value(forKey: "plan_id") as? String ?? "-"
        self.lblCust.text = DictMemberData.value(forKey: "customer") as? String ?? "-"
        self.lblStart.text = DictMemberData.value(forKey: "start") as? String ?? "-"
        self.lblEnd.text = DictMemberData.value(forKey: "end") as? String ?? "-"
        self.lblStatus.text = DictMemberData.value(forKey: "status") as? String ?? "-"
        
        let Cost = DictMemberData.value(forKey: "cost") as? Int ?? 0
        self.lblCost.text = "$" + String(Cost)
        
        self.loadCards()
        self.SetupCancelMembership()
        
    }
    
    //MARK: - SetupCancelMembership Method
    func SetupCancelMembership(){
        
        if(self.strStatus == "active" && self.strCancelt_at_period_end == true){
            
            displayAlert(APPNAME, andMessage: "Your membership will be cancelled at the end of current billing period")
            
        }
        
        if(self.strStatus == "active" && self.strCancelt_at_period_end == false && self.strPast_due == false && self.strAllow_start_membership == false){
            
            self.lblviewCancelMembership.text = "If you want to cancel your membership, please click button below."
            self.btnCancelMembership.setTitle("Cancel Membership", for: .normal)
            self.btnCancelMembership.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            
            self.ButtonStatus = "cancel"
            
        }
        
        if(self.strStatus == "active" && self.strCancelt_at_period_end == true && self.strPast_due == false && self.strAllow_start_membership == false){
            
            self.lblviewCancelMembership.text = "If you want to restart your membership, please click button below."
            self.btnCancelMembership.setTitle("Restart Membership", for: .normal)
            self.btnCancelMembership.backgroundColor = #colorLiteral(red: 0.06274509804, green: 0.6392156863, blue: 0.2274509804, alpha: 1)
            
            self.ButtonStatus = "restart"
            
        }
        
        if(self.strStatus == "canceled" && self.strAllow_start_membership == true ||
            self.DictMemberData.count == 0 && self.strAllow_start_membership == true){
            
            self.lblviewCancelMembership.text = "If you want to start your membership, please click button below."
            self.btnCancelMembership.setTitle("Start Membership", for: .normal)
            self.btnCancelMembership.backgroundColor = #colorLiteral(red: 0.2784313725, green: 0.4549019608, blue: 0.5921568627, alpha: 1)
            
            self.ButtonStatus = "start"
            
        }
        
        
    }
    
    //MARK: - btnAddNewCardAction Method
    @IBAction func btnAddNewCardAction(_ sender: Any) {
        
        self.FromAddCard = true
        
        let nextNavVc = self.storyboard!.instantiateViewController(withIdentifier: "AddNewCard_VC") as! AddNewCard_VC
        self.navigationController?.pushViewController(nextNavVc, animated: true)
        
    }
    
    //MARK: - btnCancelAction Method
    @IBAction func btnCancelAction(_ sender: Any) {
        
        if(self.ButtonStatus == "cancel"){
            
            self.CANCEL_MEMBERSHIP()
            
        }
        if(self.ButtonStatus == "restart"){
            
            self.RESTART_MEMBERSHIP()
            
        }
        if(self.ButtonStatus == "start"){
            
            self.FromAddCard = true
            
            let nextNavVc = self.storyboard!.instantiateViewController(withIdentifier: "Create_PM_VC") as! Create_PM_VC
            self.navigationController?.pushViewController(nextNavVc, animated: true)
            
        }
        
    }
    
    
    //MARK: - loadCards methods -
    func loadCards(){
        
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
                
                DispatchQueue.main.async {
                    self.tableViewHeight.constant = CGFloat(self.cards.count * 70)
                    self.tableView.reloadData()
                    self.view.updateConstraintsIfNeeded()
                }
            })
        }
        else{
            
        }
    }
    
    //MARK:- GetDefaultPaymentMethod method
    func GetDefaultPaymentMethod(){
        
        let result = UserDefaults.standard.value(forKey: "UserAllData") as? NSDictionary
        let custID = result?.value(forKeyPath: "customer_id") as? String
        
        self.GET_PAYMENT_METHOD(Cust_ID: custID!)
    }
    
    
    //MARK:- TableView
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CardsCell") as! CardsCell
        cell.delegate = self
        
        let cardString:String!
        
        let Brand = self.cards[indexPath.row]["brand"] as? String
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
        
        let last4 = self.cards[indexPath.row]["last4"] as! String
        cell.lblCardNumber.text = cardString
        cell.lblLast4.text = last4
        
        let CurrentCard = self.cards[indexPath.row]["id"] as? String
        if(CurrentCard == self.PaymentMethod)
        {
            print("Matched")
            cell.btnMakeDefault.isHidden = true
            cell.lblDefaultMethod.isHidden = false
            cell.lblDefaulrMethodWidth.constant = 160
            self.view.updateConstraintsIfNeeded()
        }
        else
        {
            print("Not Matched")
            cell.btnMakeDefault.isHidden = false
            cell.lblDefaultMethod.isHidden = false
            cell.lblDefaulrMethodWidth.constant = 0
            self.view.updateConstraintsIfNeeded()
        }
        
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    
    
    //MARK: - API Calls
    func GET_PAYMENT_METHOD(Cust_ID:String) {
        
        let url = "https://api.stripe.com/v1/customers/\(Cust_ID)"
        let header = ["Authorization": self.stripeTool.getBasicAuth()]
        
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
                        let Dictdata = dict?.value(forKeyPath: "invoice_settings") as? NSMutableDictionary
                        self.PaymentMethod = Dictdata?.value(forKey: "default_payment_method") as? String ?? ""
                        
                        if(self.PaymentMethod != ""){
                            
                            if(self.FlagPaymentMethod == true){
                                self.FlagPaymentMethod = false
                                self.tableView.reloadData()
                            }
                            else{
                                self.DisplayMemberView()
                                self.SetupData()
                            }
                        }
                        else
                        {
                            displayAlert(APPNAME, andMessage: MSG.SOMETHINGWRONG)
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
    
    
    func FETCH_MEMBERSHIP() {
        
        let url = API.BASE_URL + API.FETCH_MEMBERSHIP
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
                        displayAlert(APPNAME, andMessage: MSG.NO_RESPONSE)
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
                            print(dict!)
                            
                            let dictData = dict?.value(forKey: "data") as? NSMutableDictionary
                            self.DictMemberData = dictData?.value(forKey: "membership") as? NSMutableDictionary ?? [:]
                            
                            if(self.DictMemberData.count == 0){
                                print("Not a member")
                                let StartMembership = dictData?.value(forKey: "allow_start_membership") as? Bool
                                self.strAllow_start_membership = StartMembership!
                                self.SetupCancelMembership()
                                self.DisplayErrorView()
                            }
                            else
                            {
                                print("member")
                                
                                let Status = self.DictMemberData.value(forKey: "status") as? String
                                let CancelAt = self.DictMemberData.value(forKey: "cancelt_at_period_end") as? Bool
                                let PastDue = self.DictMemberData.value(forKey: "past_due") as? Bool
                                let StartMembership = dictData?.value(forKey: "allow_start_membership") as? Bool

                                
                                self.strStatus = Status!
                                self.strCancelt_at_period_end = CancelAt!
                                self.strPast_due = PastDue!
                                self.strAllow_start_membership = StartMembership!
                                
                                
                                self.GetDefaultPaymentMethod()
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
    
    func MAKE_DEFAULT_PAYMENT_METHOD(card:String) {
        
        let url = API.BASE_URL + API.DEFAULT_MEMBERSHIP
        
        let param : [String:String] = ["card" : card]
        
        let header = ["Content-Type":"application/x-www-form-urlencoded",
                      "Authorization": "Bearer \(AppPrefs.shared.getUserId())"]
        
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
                        displayAlert(APPNAME, andMessage: MSG.NO_RESPONSE)
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
                            displayAlert(APPNAME, andMessage: "Default Payment Method Updated.")
                            self.FlagPaymentMethod = true
                            
                            let result = UserDefaults.standard.value(forKey: "UserAllData") as? NSDictionary
                            let custID = result?.value(forKeyPath: "customer_id") as? String
                            self.GET_PAYMENT_METHOD(Cust_ID: custID!)
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

    func CANCEL_MEMBERSHIP() {
        
        let url = API.BASE_URL + API.CANCEL_MEMBERSHIP
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
                        displayAlert(APPNAME, andMessage: MSG.NO_RESPONSE)
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
                            print(dict!)
                            displayAlert(APPNAME, andMessage: "Successfully canceled your membership")
                            self.FETCH_MEMBERSHIP()
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
    
    func RESTART_MEMBERSHIP() {
        
        let url = API.BASE_URL + API.RESTART_MEMBERSHIP
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
                        displayAlert(APPNAME, andMessage: MSG.NO_RESPONSE)
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
                            print(dict!)
                            displayAlert(APPNAME, andMessage: "Membership Activated")
                            self.FETCH_MEMBERSHIP()
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
