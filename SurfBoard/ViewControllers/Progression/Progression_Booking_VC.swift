//
//  Progression_Booking_VC.swift
//  SurfBoard
//
//  Created by esparkbiz on 1/21/20.
//  Copyright © 2020 esparkbiz. All rights reserved.
//

import UIKit
import Alamofire

class Progression_Booking_VC: BaseViewController {
    
    var isFromLoc:Bool = false
    var Sesstion_Loc:String!
    var Sesstion_Type:String!
    var Sesstion_Desc:String!
    var Sesstion_Amount:String!
    var TodayDate:String!
    var TodayTime:String!
    var StrLocForAPI:String!
    
    var arrPrice = [String]()
    
    @IBOutlet var lblProgDesc: UILabel!
    @IBOutlet var lblProgAmount: UILabel!
    @IBOutlet var lblLevel1: UILabel!
    @IBOutlet var lblLevel2: UILabel!
    @IBOutlet var lblLevel3: UILabel!
    @IBOutlet var lblLevel4: UILabel!
    
    
    
    @IBOutlet var btnBookNow: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        AppDelegate.shared().setupNavigationBar()
        setTranspertNavigation()
        
        if(Sesstion_Type == "progression_enrollment")
        {
            self.title = "Progression Model"
        }
        else if(Sesstion_Type == "progression_level_1")
        {
            self.title = "Progression Level 1"
        }
        else if(Sesstion_Type == "progression_level_2")
        {
            self.title = "Progression Level 2"
        }
        else if(Sesstion_Type == "progression_level_3")
        {
            self.title = "Progression Level 3"
        }
        else if(Sesstion_Type == "progression_level_4")
        {
            self.title = "Progression Level 4"
        }
        else
        {
            self.title = "Progression"
        }
        
        
        if(isFromLoc == true)
        {
            self.lblProgDesc.text = self.Sesstion_Desc
            self.lblProgAmount.text = self.title! + " Fees : $" + self.Sesstion_Amount!
            TodayDate = Date().string(format: "MM/dd/yyyy")
            TodayTime = Date().string(format: "HH:mm:ss")
            
            print(self.lblProgDesc.text!)
            print(self.lblProgAmount.text!)
            print(self.TodayDate)
            print(self.TodayTime)
        }
            
        else
        {
            self.lblProgAmount.isHidden = true
            self.lblProgDesc.isHidden = true
            self.btnBookNow.isHidden = true
        }
        
        self.GET_PROGRESSION_FEES_API()
    }
    
    
    @IBAction func btnBookNowAction(_ sender: Any) {
        self.CHECK_BOOKING()
    }
    
    func GET_PROGRESSION_FEES_API() {
        
        let url = API.BASE_URL + API.GET_PROGRESSION_LEVEL_FEES
        
        let param : [String:String] = ["location_id" : self.StrLocForAPI]
        
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
                            print(dict!)
                            let arrData = dict?.value(forKey: "data") as? NSMutableArray
                            if(arrData?.count != 0)
                            {
                                for dictData1 in arrData!
                                {
                                    let Dict1 = dictData1 as? NSMutableDictionary
                                    let value = Dict1?.value(forKey: "price") as! String
                                    self.arrPrice.append(value)
                                }
                            }
                            else
                            {
                                
                            }
                            
                            let L1 = self.arrPrice[0]
                            let L2 = self.arrPrice[1]
                            let L3 = self.arrPrice[2]
                            let L4 = self.arrPrice[3]
                            self.lblLevel1.text = "Level 1: $" + L1
                            self.lblLevel2.text = "Level 2: $" + L2
                            self.lblLevel3.text = "Level 3: $" + L3
                            self.lblLevel4.text = "Level 4: $" + L4
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
                            print(dict!)
                            let dictData = dict?.value(forKey: "data") as? NSMutableDictionary
                            let Check_Flag = dictData?.value(forKey: "allowed") as? Bool
                            
                            if(Check_Flag == true)
                            {
                                let nextNavVc = self.storyboard!.instantiateViewController(withIdentifier: "Payment_VC") as! Payment_VC
                                nextNavVc.TodayDate = self.TodayDate
                                nextNavVc.TodayTime = self.TodayTime
                                nextNavVc.Prog_Type = self.Sesstion_Type
                                nextNavVc.Prog_Loc = self.Sesstion_Loc
                                nextNavVc.Amount = self.Sesstion_Amount
                                nextNavVc.isFromProg = true
                                self.navigationController?.pushViewController(nextNavVc, animated: true)
                            }
                            else
                            {
                                //displayAlert(APPNAME, andMessage: "Either you have already booked this session or Instructor has not provided review on your previous session yet.")
                                displayAlert(APPNAME, andMessage: dictData?.value(forKey: "message") as? String ?? "Either you have already booked this session or Instructor has not provided review on your previous session yet.")
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

extension Date {
    func string(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
