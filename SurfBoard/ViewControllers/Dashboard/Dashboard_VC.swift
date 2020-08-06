//
//  Dashboard_VC.swift
//  Surf Board
//
//  Created by eSparkBiz-1 on 03/12/19.
//  Copyright © 2019 eSparkBiz. All rights reserved.
//

import UIKit
import Alamofire

class Dashboard_VC: BaseViewController,FSPagerViewDataSource,FSPagerViewDelegate{
    
    //var dGLocale = DGLocalization()
    var arrImages = Array<UIImage>()
    
    @IBOutlet var MainPaserView: FSPagerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AppDelegate.shared().setupNavigationBar()
        setLeftBarMenuItem()
        setTranspertNavigation()
        self.title = "Dashboard"
        
        let tabBarHeight = self.tabBarController!.tabBar.frame.size.height
        let topBarHeight = UIApplication.shared.statusBarFrame.size.height +
            (self.navigationController?.navigationBar.frame.height ?? 0.0)
        let Final_Height = tabBarHeight + topBarHeight
        
        arrImages = [UIImage(named: "FirstPoster"),UIImage(named: "SecondPoster"),UIImage(named: "ThirdPoster"),UIImage(named: "ForthPoster"),UIImage(named: "FifthPoster"),UIImage(named: "SixthPoster")] as! [UIImage]
        
        self.MainPaserView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        self.MainPaserView.itemSize = CGSize(width: self.view.frame.size.width, height:
            self.view.frame.size.height - Final_Height)
        self.MainPaserView.isInfinite = true
        self.MainPaserView.transformer = FSPagerViewTransformer(type: .crossFading)
        self.MainPaserView.automaticSlidingInterval = 2.0
        
        let result = UserDefaults.standard.value(forKey: "UserAllData") as? NSDictionary
        if(result != nil)
        {
            AppDelegate.shared().certificateStatus = result?.value(forKeyPath: "certificate_status") as? Int
            AppDelegate.shared().discoverStatus = result?.value(forKeyPath: "discover_lesson_status") as? Int
            AppDelegate.shared().progressionStatus = result?.value(forKeyPath: "progression_model_status") as? Int
            
            if(AppDelegate.shared().certificateStatus == 0 && AppDelegate.shared().discoverStatus == 0)
            {
                let popupVC = storyboard?.instantiateViewController(withIdentifier: "DashboardPopup_VC") as! DashboardPopup_VC
                view.addSubview(popupVC.view)
                addChild(popupVC)
            }
            else
            {
                print("certificateStatus")
                print("discoverStatus")
                print("progressionStatus")
                print(AppDelegate.shared().certificateStatus)
                print(AppDelegate.shared().discoverStatus)
                print(AppDelegate.shared().progressionStatus)
            }
            
            let CustID_Stripe = result?.value(forKeyPath: "customer_id") as? String
            if(CustID_Stripe == "" || CustID_Stripe == nil)
            {
                self.Create_Cust_Id_Stripe()
            }
            else
            {
                print(CustID_Stripe!)
            }
        }
        else
        {
            print("Blank User Data")
        }
        
        let ACK = UserDefaults.standard.value(forKey: "UserPrivacyACK") as? Bool
        if(ACK == nil){
            
            let popupVC = storyboard?.instantiateViewController(withIdentifier: "PrivacyPopup_VC") as! PrivacyPopup_VC
            view.addSubview(popupVC.view)
            addChild(popupVC)
            
        }
        else{
            print("User Privacy")
            print(ACK!)
        }
        
        self.Push_Notification_API()
        
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        setTranspertNavigation()
        setLeftBarMenuItem()
        self.navigationController?.isNavigationBarHidden = false
        
        //self.navigationController?.isNavigationBarHidden = false
        //self.setData()
        //GetUser_API()
        
        if AppDelegate.shared().isFrom_Notification == true{
            if AppDelegate.shared().NOTIFICATION_TYPE == "chat"
            {
                AppDelegate.shared().isFrom_Notification = false
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChatUserList_VC") as! ChatUserList_VC
                self.navigationController?.pushViewController(vc, animated: true)
            }
            if AppDelegate.shared().NOTIFICATION_TYPE == "canceled_session"
            {
                AppDelegate.shared().isFrom_Notification = false
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "Calender_VC") as! Calender_VC
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
        self.HandlePushNotification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.openBuyBoard(_:)), name: NSNotification.Name(rawValue: "BuyBoard"), object: nil)
        self.SetupData()
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "BuyBoard"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "PushNotification_CALL"), object: nil)
        
    }

    @objc func openBuyBoard(_ notification: NSNotification) {
        
        let popupVC = self.storyboard?.instantiateViewController(withIdentifier: "BuyBoard_VC") as! BuyBoard_VC
        self.view.addSubview(popupVC.view)
        self.addChild(popupVC)
        
    }
    //MARK: - ChangeLanguage method -
    @objc func ChangeLanguage(_ notification: NSNotification) {
        
        let lang = DGLocalization.sharedInstance.getCurrentLanguage()
        
        if (lang.languageCode == "en"){
            print("Selected Lang english")
            self.SetupData()
        }
        else if (lang.languageCode == "es"){
            print("Selected Lang Spanish")
            self.SetupData()
        }
        else if (lang.languageCode == "de"){
            print("Selected Lang German")
            self.SetupData()
        }
        else if (lang.languageCode == "fr"){
            print("Selected Lang French")
            self.SetupData()
        }
        else if (lang.languageCode == "it"){
            print("Selected Lang Italian")
            self.SetupData()
        }
        else{
            
        }
    }
    
    func SetupData(){
        
        self.title = "DASHBOAD_TITLE".localize
        
        self.tabBarController?.tabBar.items![0].title = "TABBAR_ITEM_TITLE_0".localize
        self.tabBarController?.tabBar.items![1].title = "TABBAR_ITEM_TITLE_1".localize
        self.tabBarController?.tabBar.items![2].title = "TABBAR_ITEM_TITLE_2".localize
        self.tabBarController?.tabBar.items![3].title = "TABBAR_ITEM_TITLE_3".localize
        self.tabBarController?.tabBar.items![4].title = "TABBAR_ITEM_TITLE_4".localize
        
    }
    
    //MARK: - FSPagerView Delegate and Datasource -
    func numberOfItems(in pagerView: FSPagerView) -> Int
    {
        return arrImages.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell
    {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        cell.imageView?.contentMode = .scaleToFill
        cell.imageView?.clipsToBounds = true
        cell.imageView?.image = arrImages[index]
        
        return cell
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int)
    {
        pagerView.deselectItem(at: index, animated: true)
        pagerView.scrollToItem(at: index, animated: true)
    }
    
    //MARK:- BUTTON ACTION
    func LogoutAction(){
        
        //Clear User Data
        AppPrefs.shared.setIsUserLogin(isUserLogin: false)
        AppPrefs.shared.removeUserId()
        AppPrefs.shared.removeUserName()
        AppPrefs.shared.removeUserProfile()
        AppPrefs.shared.setIsUserRememberLogin(isUserLogin: false)
        
        UserDefaults.standard.removeObject(forKey: "UserAllData")
        UserDefaults.standard.synchronize()
        
         goToMainScreen()
    }
    
    @objc func goToMainScreen() {
        
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "Register_VC")  as! Register_VC
        self.navigationController?.pushViewController(nextVC, animated: false)
        
    }
    
    // MARK:- Extra Method
    func HandlePushNotification()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(self.GoOnNotificationVC), name: NSNotification.Name(rawValue: "PushNotification_CALL"), object: nil)
        
    }
    
    @objc func GoOnNotificationVC(notification: NSNotification){
        DispatchQueue.main.async() {
            self.moveVCBaseonNotificationType()
        }
    }
    
    func moveVCBaseonNotificationType()
    {
        if AppDelegate.shared().NOTIFICATION_TYPE == "chat"
        {
            AppDelegate.shared().isFrom_Notification = false
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChatUserList_VC") as! ChatUserList_VC
            self.navigationController?.pushViewController(vc, animated: true)
        }
        if AppDelegate.shared().NOTIFICATION_TYPE == "canceled_session"
        {
            AppDelegate.shared().isFrom_Notification = false
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "Calender_VC") as! Calender_VC
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    //MARK: - API Calls
    func Create_Cust_Id_Stripe() {
        
        let url = API.BASE_URL + API.CREATE_STRIPE_CUST
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
                            self.GetUser_API()
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
    
    func GetUser_API() {
        
        let url = API.BASE_URL + API.CURRENT_USER_PROFIE
        let header = ["Content-Type":"application/x-www-form-urlencoded",
                      "Authorization": "Bearer \(AppPrefs.shared.getUserId())"
        ]
        
        if NetworkReachabilityManager()?.isReachable == true
        {
            //AppDelegate.shared().ShowSpinnerView()
            Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.httpBody, headers: header).response { (response) in
                //AppDelegate.shared().HideSpinnerView()
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
                            UserDefaults.standard.removeObject(forKey: "UserAllData")
                            UserDefaults.standard.synchronize()
                            
                            var dictUser:NSMutableDictionary = [:]
                            let dict1 = (dict?.value(forKey: "data") as? NSMutableDictionary)!
                            dictUser = dict1.value(forKeyPath: "user") as! NSMutableDictionary
                            UserDefaults.standard.set(dictUser, forKey: "UserAllData")
                            UserDefaults.standard.synchronize()
                            print(dictUser)
                            
                            AppDelegate.shared().certificateStatus = dictUser.value(forKeyPath: "certificate_status") as? Int
                            AppDelegate.shared().discoverStatus = dictUser.value(forKeyPath: "discover_lesson_status") as? Int
                            AppDelegate.shared().progressionStatus = dictUser.value(forKeyPath: "progression_model_status") as? Int
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
    
    func Push_Notification_API() {
        
        let baseURL = API.BASE_URL + API.PUSH_NOTIFICATION
        
        let NotiToken = AppDelegate.shared().NOTIFICATION_TOKEN
        
        let params:[String:String] = ["token":NotiToken , "os":"ios"]
        
        let header = ["Content-Type":"application/x-www-form-urlencoded",
                      "Authorization": "Bearer \(AppPrefs.shared.getUserId())"
        ]
        
        if NetworkReachabilityManager()?.isReachable == true
        {
            Alamofire.request(baseURL, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: header).response { (response) in
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
                            let Code = dict?.value(forKeyPath: "code") as? Int
                            if(Code == 401){
                                
                                let alert = UIAlertController(title: APPNAME, message: "Session Expired. Please Login Again.", preferredStyle: UIAlertController.Style.alert)
                                
                                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
                                    
                                    self.goToMainScreen()
                                }))
                                self.present(alert, animated: true, completion: nil)
                                
                            }
                            else{
                                 //displayAlert(APPNAME, andMessage: (dict?.value(forKeyPath: "message") as? String)!)
                                print((dict?.value(forKeyPath: "message") as? String)!)
                            }
                           
                        }
                        else
                        {
                            
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
