//
//  GetCertified_VC.swift
//  SurfBoard
//
//  Created by esparkbiz on 1/29/20.
//  Copyright © 2020 esparkbiz. All rights reserved.
//

import UIKit
import Alamofire

class GetCertified_VC: BaseViewController {
    
    
    @IBOutlet var btnBookNow: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.isNavigationBarHidden = false
        AppDelegate.shared().setupNavigationBar()
        self.title = "Certification"
        setLeftBarBackItem()
        setTranspertNavigation()
        
        GetUser_API()
    }


    @IBAction func btnBookNowAction(_ sender: Any) {
        
      self.CHECK_BOOKING()
    
    }
    
    
    //MARK: - API Calls
    func GetUser_API() {
        
        let url = API.BASE_URL + API.CURRENT_USER_PROFIE
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
            displayAlert(APPNAME, andMessage: MSG.NO_NETWORK)
        }
    }
    
    func CHECK_BOOKING() {
        
        let url = API.BASE_URL + API.CHECK_BOOKING
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
                            let Check_Flag = dictData?.value(forKey: "allowed") as? Bool
                            
                            if(Check_Flag == true)
                            {
                                let result = UserDefaults.standard.value(forKey: "UserAllData") as? NSDictionary
                                let Certificatestatus = result?.value(forKeyPath: "certificate_status") as? Int
                                
                                if(Certificatestatus == 1)
                                {
                                    let nextNavVc = self.storyboard!.instantiateViewController(withIdentifier: "Location_VC") as! Location_VC
                                    self.navigationController?.pushViewController(nextNavVc, animated: true)
                                }
                                else
                                {
                                    displayAlert(APPNAME, andMessage: "You can not book Certification Session.")
                                }
                            }
                            else
                            {
                                
                                displayAlert(APPNAME, andMessage: dictData?.value(forKey: "message") as? String ?? "Either you have already booked this session or Instructor has not provided review on your previous session yet.")
                                
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
