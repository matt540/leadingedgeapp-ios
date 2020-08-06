//
//  DashboardPopup_VC.swift
//  SurfBoard
//
//  Created by esparkbiz on 1/17/20.
//  Copyright © 2020 esparkbiz. All rights reserved.
//

import UIKit
import Alamofire

class DashboardPopup_VC: BaseViewController {
    
    var status:String = ""
    @IBOutlet private weak var viewPopupUI:UIView!
    @IBOutlet private weak var viewMain:UIView!
    @IBOutlet var btnDiscover: UIButton!
    @IBOutlet var btnCertificate: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.showViewWithAnimation()
        self.viewPopupUI.addShadow(color: .lightGray, opacity: 1.0, offset: CGSize(width: 1, height: 1), radius: 2)
        self.viewPopupUI.addCornerRadius(5)
        self.btnDiscover.addCornerRadius(5)
        self.btnCertificate.addCornerRadius(5)
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
    
    
    //MARK: - btnDiscoverAction Method 
    @IBAction func btnDiscoverAction(_ sender: Any) {
        
        status = "discovery_lession"
        StatusPath_API()
    }
    
    //MARK: - btnCertificateAction Method
    @IBAction func btnCertificateAction(_ sender: Any) {
        
        status = "certificate"
        StatusPath_API()
        
    }
    
    
    //MARK: - API Calls
    func StatusPath_API() {
        
        let url = API.BASE_URL + API.PATH_SET_API
        let param : [String:String] = ["path" : status]
        
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
                            UserDefaults.standard.removeObject(forKey: "UserAllData")
                            UserDefaults.standard.synchronize()
                            
                            var dictUser:NSMutableDictionary = [:]
                            dictUser = dict?.value(forKeyPath: "data") as! NSMutableDictionary
                            UserDefaults.standard.set(dictUser, forKey: "UserAllData")
                            UserDefaults.standard.synchronize()
                            print(dictUser)
                            
                            AppDelegate.shared().certificateStatus = dictUser.value(forKeyPath: "certificate_status") as? Int
                            AppDelegate.shared().discoverStatus = dictUser.value(forKeyPath: "discover_lesson_status") as? Int
                            AppDelegate.shared().progressionStatus = dictUser.value(forKeyPath: "progression_model_status") as? Int
                            
                            //displayAlert(APPNAME, andMessage: "Success")
                            self.tabBarController?.selectedIndex = 1
                        }
                    }
                    self.hideViewWithAnimation()
                }
            }
        }
        else
        {
            displayAlert(APPNAME, andMessage: "ERROR_NETWORK".localize)
            self.hideViewWithAnimation()
        }
    }
    
    
}
