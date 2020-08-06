//
//  AffiliatePopup_VC.swift
//  SurfBoard
//
//  Created by esparkbiz on 6/16/20.
//  Copyright © 2020 esparkbiz. All rights reserved.
//

import UIKit
import Alamofire

class AffiliatePopup_VC: UIViewController {
    
    var strLoc:String!
    
    @IBOutlet private weak var viewPopupUI:UIView!
    @IBOutlet private weak var viewMain:UIView!
    
    @IBOutlet var btnClose: UIButton!
    @IBOutlet var btnRequest: UIButton!
    @IBOutlet var txtEmail: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.showViewWithAnimation()
        
        self.btnRequest.addCornerRadius(5)
        self.viewPopupUI.addShadow(color: .lightGray, opacity: 1.0, offset: CGSize(width: 1, height: 1), radius: 2)
        self.viewMain.addCornerRadius(10)
        
        if(self.strLoc == "" || self.strLoc == nil){
            displayAlert(APPNAME, andMessage: "Invalid Location")
        }
    }


    //MARK: - Animation Method
    private func showViewWithAnimation() {
        
        self.view.alpha = 0
        self.viewPopupUI.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        
        UIView.animate(withDuration: 0.3) {
            self.viewPopupUI.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.view.alpha = 1
        }
    }
    
    private func hideViewWithAnimation() {
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.viewPopupUI.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            self.view.alpha = 0
            
        }, completion: {
            (value: Bool) in
            
            self.removeFromParent()
            self.view.removeFromSuperview()
        })
    }
    
    @IBAction func btnCloseAction(_ sender: Any) {
        self.hideViewWithAnimation()
    }
    
    
    @IBAction func btnRequestAction(_ sender: Any) {
        
        if(self.txtEmail.text! == "" || self.txtEmail.text?.isValidEmail == false){
            displayAlert(APPNAME, andMessage: "Please Enter valid Email")
        }else{
            self.SUBMIT_REQUEST()
        }
        
    }
    
    //MARK: - API Calls
    func SUBMIT_REQUEST() {
        
        let url = API.BASE_URL + API.SUBMIT_REQUEST
        
        let param : [String:String] = ["name" : self.strLoc,
                                       "email" : self.txtEmail.text!
                                       ]
        
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
                            displayAlert(APPNAME, andMessage: "Requested Successfully")
                            self.hideViewWithAnimation()
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
