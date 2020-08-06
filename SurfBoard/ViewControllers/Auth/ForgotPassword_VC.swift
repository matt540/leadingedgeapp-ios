//
//  ForgotPassword_VC.swift
//  SurfBoard
//
//  Created by HariKrishna Kundariya on 20/12/19.
//  Copyright © 2019 esparkbiz. All rights reserved.
//

import UIKit
import Alamofire

class ForgotPassword_VC: BaseViewController {

    //MARK:- IBOUTLET AND VARIABLES
    
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var viewEmail: UIView!
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var btnSubmit: UIButton!
    @IBOutlet var scrollview: UIScrollView!
    @IBOutlet var viewInsideScroll: UIView!
    
    //MARK:- LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()

        AppDelegate.shared().setupNavigationBar()
        self.title = "Reset Password"
        setLeftBarBackItem()
        setTranspertNavigation()
        self.navigationController?.isNavigationBarHidden = false
        setupUI()
        // Do any additional setup after loading the view.
    }
    

    //MARK:- EXTRA METHOD
        func setupUI() {
            viewEmail.addCornerRadius(10.0)
            btnSubmit.addCornerRadius(10.0)
            btnSubmit.addShadow(color: UIColor.lightGray, opacity: 2, offset: CGSize.zero, radius: 10.0)
        }
    //MARK:- BUTTON LOGIN ACTION
    @IBAction func btnSubmitAction(_ sender: Any){
        
        if(self.txtEmail.text! != ""){
            ForgotPassword_API()
        }
        else{
            displayAlert(APPNAME, andMessage: "Please Enter Email.")
        }
        
    }
    
    // MARK: - API Calls
    func ForgotPassword_API() {
        
        let url = API.BASE_URL + API.FORGET_PASSWORD
        let param : [String:String] = ["email" : self.txtEmail.text!]

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
                        let status = dict?.value(forKeyPath: "status") as? String ?? ""
                        if(status == "error")
                        {
                            displayAlert(APPNAME, andMessage: dict?.value(forKeyPath: "message") as! String)
                        }
                        else
                        {
                            displayAlertWithOneOptionAndAction(APPNAME, andMessage: dict?.value(forKeyPath: "message") as? String ?? "Mail sent") {
                                self.navigationController?.popViewController(animated: true)
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
