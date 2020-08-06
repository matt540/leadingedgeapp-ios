//
//  Login_VC.swift
//  Surf Board
//
//  Created by eSparkBiz-1 on 03/12/19.
//  Copyright © 2019 eSparkBiz. All rights reserved.
//

import UIKit
import Alamofire

class Login_VC: BaseViewController {
    
    var isFromDashBoard:Bool = false
    //MARK:- IBOUTLET AND VARIABLES
    //    @IBOutlet var imgProfile: UIImageView!
    @IBOutlet var lblWelcome: UILabel!
    //    @IBOutlet var lblName: UILabel!
    @IBOutlet var viewEmail: UIView!
    @IBOutlet var viewPassword: UIView!
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var txtPassword: UITextField!
    @IBOutlet var btnLogin: UIButton!
    @IBOutlet var viewBottom: UIView!
    @IBOutlet var viewRound: UIView!
    @IBOutlet var btnTwitter: UIButton!
    @IBOutlet var btnFacebook: UIButton!
    @IBOutlet var btnForgetPassword: UIButton!
    @IBOutlet var viewBottomHeight: NSLayoutConstraint!
    
    
    //MARK:- LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        AppDelegate.shared().setupNavigationBar()
        self.title = "Sign In"
        setLeftBarBackItem()
        setTranspertNavigation()
        self.navigationController?.isNavigationBarHidden = false
        setupUI()
        
        self.viewBottomHeight.constant = 0
        self.viewBottom.isHidden = true
        self.view.updateConstraintsIfNeeded()
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    
    //MARK:- EXTRA METHOD
    func setupUI() {
        //        imgProfile.addCornerRadius(imgProfile.frame.size.width/2)
        //        imgProfile.layer.borderColor = UIColor.white.cgColor
        //        imgProfile.layer.borderWidth = 2
        viewEmail.addCornerRadius(10.0)
        viewPassword.addCornerRadius(10.0)
        btnTwitter.addCornerRadius(10.0)
        btnFacebook.addCornerRadius(10.0)
        viewRound.addCornerRadius(viewRound.frame.size.width/2)
        btnLogin.addCornerRadius(10.0)
        btnLogin.addShadow(color: UIColor.lightGray, opacity: 2, offset: CGSize.zero, radius: 10.0)
    }
    
    
    //MARK:- BUTTON LOGIN ACTION
    @IBAction func btnLoginAction(_ sender: Any){
        
        if(self.txtEmail.text == "")
        {
            displayAlert(APPNAME, andMessage: "Please Enter Email.")
        }
        else if(self.txtPassword.text == "")
        {
            displayAlert(APPNAME, andMessage: "Please Enter Password.")
        }
        else
        {
            Login_API()
        }
    }
    
    @IBAction func btnForgetPasswordAction(_ sender: Any){
        
        let VC = ForgotPassword_VC.instantiate(fromAppStoryboard: .Main)
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    
    //MARK:- Twitter Login Methods
    @IBAction func btnTwitterAction(_ sender: Any){
        
    }
    
    //MARK:- Facebook Login Methods
    @IBAction func btnFacebookAction(_ sender: Any){
        
        //        let fbLoginManager : LoginManager = LoginManager()
        //
        //        fbLoginManager.logIn(permissions: ["pages_show_list"], from: self)
        //        { (result, error) -> Void in
        //            if (error == nil && result != nil)
        //            {
        //                let fbloginresult : LoginManagerLoginResult = result!
        //                if (fbloginresult.grantedPermissions != nil)
        //                {
        //                    if(fbloginresult.grantedPermissions.contains("pages_show_list"))
        //                    {
        //                        self.getFBUserData()
        //                    }
        //                }
        //            }
        //        }
    }
    
    func getFBUserData()
    {
        //        let params = ["fields": "id, first_name, last_name, name, email, picture"]
        //        if((AccessToken.current) != nil){
        //            GraphRequest(graphPath: "me", parameters:params).start(completionHandler: { (connection, result, error) -> Void in
        //                if (error == nil)
        //                {
        //                    print("Result:",result!)
        //                    self.goToHome(animated: true)
        //                    //                    let responseData = JSON(result!)
        //                    //                    let FBUSERID = responseData["id"].stringValue
        //                    //                    let FBUSERNAME = responseData["name"].stringValue
        //                    //                    let FBUSEREMAIL = responseData["email"].stringValue
        //                }
        //            })
        //        }
    }
    
    
    // MARK: - API Calls
    func Login_API() {
        
        let url = API.BASE_URL + API.LOGIN
        let param : [String:String] = ["email" : self.txtEmail.text!,
                                       "password" : self.txtPassword.text!]
        
        if NetworkReachabilityManager()?.isReachable == true
        {
            AppDelegate.shared().ShowSpinnerView()
            Alamofire.request(url, method: .post, parameters: param, encoding: URLEncoding.httpBody, headers: nil).response { (response) in
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
                        //self.checkDictionary(dict!)
                        let status = dict?.value(forKeyPath: "status") as? String ?? ""
                        if(status == "error")
                        {
                            displayAlert(APPNAME, andMessage: dict?.value(forKeyPath: "message") as! String)
                        }
                        else
                        {
                            print(dict!)
                            if dict?.object(forKey: "data") is NSMutableDictionary
                            {
                                var dictUser:NSMutableDictionary = [:]
                                dictUser = dict?.value(forKeyPath: "data.user") as! NSMutableDictionary
                                UserDefaults.standard.set(dictUser, forKey: "UserAllData")
                                UserDefaults.standard.synchronize()
                                
                                let userToken = dict?.value(forKeyPath: "data.token") as! String
                                AppPrefs.shared.saveUserId(userId: userToken)
                                AppPrefs.shared.setIsUserLogin(isUserLogin: true)
                                AppPrefs.shared.setIsUserRememberLogin(isUserLogin: true)
                                
                                let strUserName:String = (dictUser.value(forKeyPath: "name") as? String)!
                                AppPrefs.shared.saveUserName(name: strUserName)
                                
                                let strProfile:String = (dictUser.value(forKeyPath: "image") as? String)!
                                AppPrefs.shared.saveUserProfile(url: strProfile)
                                
                                self.txtEmail.text = ""
                                self.txtPassword.text = ""
                                self.navigationController?.isNavigationBarHidden = true
                                self.goToHome(animated: true)
                            }
                            else
                            {
                                displayAlert(APPNAME, andMessage: "Invalid Response from Server")
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
