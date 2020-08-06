//
//  ResetPassword_VC.swift
//  SurfBoard
//
//  Created by esparkbiz on 1/1/20.
//  Copyright © 2020 esparkbiz. All rights reserved.
//

import UIKit
import Alamofire

class ResetPassword_VC: BaseViewController {
    
    @IBOutlet var txtOldPassword: UITextField!
    @IBOutlet var txtNewPassword: UITextField!
    @IBOutlet var txtConfirmPassword: UITextField!
    @IBOutlet var btnSubmit: UIButton!
    
    @IBOutlet var viewOldPass: UIView!
    @IBOutlet var viewNewPass: UIView!
    @IBOutlet var viewConfirmPass: UIView!
    
    @IBOutlet var lblResetPass: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        AppDelegate.shared().setupNavigationBar()
        self.title = "Reset Password"
        setLeftBarBackItem()
        setTranspertNavigation()
        
        viewOldPass.addCornerRadius(10.0)
        viewNewPass.addCornerRadius(10.0)
        viewConfirmPass.addCornerRadius(10.0)
        btnSubmit.addCornerRadius(10.0)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setupLang()
        
    }
    
    func setupLang(){
        
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
        
        self.title = "RESET_PASS_TITLE".localize
        
        self.tabBarController?.tabBar.items![0].title = "TABBAR_ITEM_TITLE_0".localize
        self.tabBarController?.tabBar.items![1].title = "TABBAR_ITEM_TITLE_1".localize
        self.tabBarController?.tabBar.items![2].title = "TABBAR_ITEM_TITLE_2".localize
        self.tabBarController?.tabBar.items![3].title = "TABBAR_ITEM_TITLE_3".localize
        self.tabBarController?.tabBar.items![4].title = "TABBAR_ITEM_TITLE_4".localize
        
        self.txtOldPassword.placeholder = "OLD_PASS_PLACEHOLDER".localize
        self.txtNewPassword.placeholder = "NEW_PASS_PLACEHOLDER".localize
        self.txtConfirmPassword.placeholder = "CONFIRM_PASS_PLACEHOLDER".localize
        self.lblResetPass.text = "RESET_PASS_TITLE".localize
        self.btnSubmit.setTitle("BTN_SUBMIT".localize, for: .normal)
    }
    
    
    // MARK: - btnSubmitAction Method
    @IBAction func btnSubmitAction(_ sender: Any) {
        
        if(self.txtOldPassword.text == "")
        {
            displayAlert(APPNAME, andMessage: "Please Enter Old Password.")
        }
        else if(self.txtNewPassword.text == "")
        {
            displayAlert(APPNAME, andMessage: "Please Enter New Password.")
        }
        else if(self.txtConfirmPassword.text == "")
        {
            displayAlert(APPNAME, andMessage: "Please Enter Confirm New Password.")
        }
        else if(self.txtNewPassword.text != self.txtConfirmPassword.text)
        {
            displayAlert(APPNAME, andMessage: "Passwords Does Not Match.")
        }
        else
        {
            ResetPassword_API()
        }
        
    }

    
    // MARK: - API Calls
    func ResetPassword_API() {
        
        let url = API.BASE_URL + API.RESET_PASSWORD
        let param : [String:String] = ["old-password" : self.txtOldPassword.text!,
                                       "password" : self.txtNewPassword.text!,
                                       "password_confirmation" : self.txtConfirmPassword.text!]
        
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
                            displayAlert(APPNAME, andMessage: dict?.value(forKeyPath: "message") as! String)
                        }
                        else
                        {
                            print(dict!)
                            self.txtOldPassword.text = ""
                            self.txtNewPassword.text = ""
                            self.txtConfirmPassword.text = ""
                            displayAlert(APPNAME, andMessage: dict?.value(forKeyPath: "message") as! String)
                            self.navigationController?.popViewController(animated: true)
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
