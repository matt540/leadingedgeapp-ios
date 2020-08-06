//
//  LocationWiseWavier_VC.swift
//  SurfBoard
//
//  Created by esparkbiz on 4/23/20.
//  Copyright © 2020 esparkbiz. All rights reserved.
//

import UIKit
import Alamofire

class LocationWiseWavier_VC: BaseViewController {
    
    var strID:String!
    var strDesc:String!
    
    @IBOutlet private weak var viewPopupUI:UIView!
    @IBOutlet private weak var viewMain:UIView!
     @IBOutlet private weak var viewMainInside:UIView!
    @IBOutlet var lblDesc: UILabel!
    @IBOutlet var btnSubmt: UIButton!

    @IBOutlet var txtName: UITextField!
    @IBOutlet var txtLastName: UITextField!
    @IBOutlet var txtMinorName: UITextField!
    @IBOutlet var txtMinorLastName: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.lblDesc.text = self.strDesc
        
        self.showViewWithAnimation()
        self.viewPopupUI.addShadow(color: .lightGray, opacity: 1.0, offset: CGSize(width: 1, height: 1), radius: 2)
        self.viewMain.addCornerRadius(10)
        self.viewMainInside.addCornerRadius(10)
        self.btnSubmt.addCornerRadius(5)
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
    
    //MARK: - btnSubmitAction Method
    @IBAction func btnSubmitAction(_ sender: Any) {
        
        if(self.txtName.text! == "" || self.txtLastName.text! == ""){
            displayAlert(APPNAME, andMessage: "Please Enter First & Last Name")
        }else{
            self.SUBMIT_WAVIER()
        }
     }
    
    
    //MARK: - API Calls
    func SUBMIT_WAVIER() {
        
        let url = API.BASE_URL + API.SUBMIT_WAIVER
        
        let param : [String:String] = ["location" : self.strID,
                                       "firstname" : self.txtName.text!,
                                       "lastname" : self.txtLastName.text!,
                                       "minor_firstname" : self.txtMinorName.text!,
                                       "minor_lastname" : self.txtMinorLastName.text!]
        
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
                            let dictData = dict?.value(forKey: "data") as? NSMutableDictionary
                            let Check_Flag = dictData?.value(forKey: "success") as? Bool
                            
                            if(Check_Flag == true)
                            {
                                displayAlert(APPNAME, andMessage: "Saved Successfully")
                                self.hideViewWithAnimation()
                            }
                            else
                            {
                                 displayAlert(APPNAME, andMessage: (dict?.value(forKeyPath: "message") as? String)!)
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
