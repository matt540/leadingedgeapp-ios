//
//  CustomerWaiverPopup_VC.swift
//  SurfBoard
//
//  Created by esparkbiz on 2/3/20.
//  Copyright © 2020 esparkbiz. All rights reserved.
//

import UIKit
import Alamofire

class CustomerWaiverPopup_VC: BaseViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var picker:UIPickerView!
    var Genders = ["Select","Male","Female"]
    var SelectedGender:String!
    
    var strID:String!
    var flagExp:String = ""
    
    @IBOutlet private weak var viewPopupUI:UIView!
    @IBOutlet private weak var viewMain:UIView!
    
    @IBOutlet var lblWaiverText: UILabel!
    
    @IBOutlet var txtGender: UITextField!
    @IBOutlet var txtAge: UITextField!
    @IBOutlet var txtWeight: UITextField!
    @IBOutlet var txtWhatType: UITextField!
    
    @IBOutlet var btnYes: UIButton!
    @IBOutlet var btnNO: UIButton!
    @IBOutlet var btnApprove: UIButton!
    
    @IBOutlet var lblText: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.picker = UIPickerView()
        self.picker.delegate = self
        self.picker.dataSource = self
        self.txtGender.inputView = self.picker
        
        let numberToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 50))
        numberToolbar.barStyle = .default
        numberToolbar.items = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneClicked))]
        numberToolbar.sizeToFit()
        self.txtGender.inputAccessoryView = numberToolbar
        
        self.showViewWithAnimation()
        self.viewPopupUI.addShadow(color: .lightGray, opacity: 1.0, offset: CGSize(width: 1, height: 1), radius: 2)
        self.viewMain.addCornerRadius(10)
        
        self.btnApprove.addCornerRadius(5)
        self.txtWhatType.isHidden = true
        
        self.FETCH_WAIVER_SIGNOF()
    }
    
    //MARK: - doneClicked method
    @objc func doneClicked() -> Void
    {
        self.view.endEditing(true)
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
    
    //MARK: - btnApproveAction Method
    @IBAction func btnApproveAction(_ sender: Any) {
        
        if(self.txtGender.text == "" || self.txtAge.text == "" || self.txtWeight.text == "")
        {
            displayAlert(APPNAME, andMessage: "Please Enter All Details.")
        }
        else
        {
            if(self.flagExp != "")
            {
                if(self.flagExp == "yes")
                {
                    if(self.txtWhatType.text == "")
                    {
                        displayAlert(APPNAME, andMessage: "Please Enter Exp Details.")
                    }
                    else
                    {
                        self.Update_Waiver_API()
                    }
                }
                else
                {
                    self.Update_Waiver_API()
                }
            }
            else
            {
                displayAlert(APPNAME, andMessage: "Please Select Exp Details.")
            }
            
        }
        
    }
    
    @IBAction func btnYesAction(_ sender: Any) {
        
        self.flagExp = "yes"
        
        if(btnYes.isSelected == true)
        {
            btnYes.isSelected = false
            self.txtWhatType.isHidden = true
        }
        else
        {
            btnYes.isSelected = true
            self.txtWhatType.isHidden = false
            btnNO.isSelected = false
        }
        
    }
    
    @IBAction func btnNoAction(_ sender: Any) {
        
        self.flagExp = "no"
        
        if(btnNO.isSelected == true)
        {
            btnNO.isSelected = false
        }
        else
        {
            btnNO.isSelected = true
            btnYes.isSelected = false
        }
        
        self.txtWhatType.isHidden = true
    }
    
    //MARK: - UIPickerviewDelegate and Datasource methods -
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return self.Genders.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return SAFESTRING(str: Genders[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        self.txtGender.text = SAFESTRING(str: Genders[row])
        
        if(self.txtGender.text == "Select")
        {
            self.SelectedGender = ""
            self.txtGender.text = ""
        }
        else if(self.txtGender.text == "Male")
        {
            self.SelectedGender = "male"
        }
        else
        {
            self.SelectedGender = "female"
        }
        
    }
    
    
    //MARK: - API Calls
    func GET_DATA() {
        
        let url = API.BASE_URL + API.GET_CUSTOMER_WAVIER
        
        let param : [String:String] = ["location_id" : self.strID]
        
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
                            let arrData = dict?.value(forKey: "data") as? NSMutableArray
                            let dictData = arrData![0] as? NSMutableDictionary
                            self.lblWaiverText.text = dictData?.value(forKey: "customer_wavier") as? String ?? ""
                            
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
    
    func Update_Waiver_API() {
        
        let url = API.BASE_URL + API.UPDATE_WAIVER_DATA
        
//        let age = Int(self.txtAge.text!)
//        let weight = Int(self.txtWeight.text!)
        
        let param : [String:String] = ["wavier_accepted" : "yes",
                                       "gender" : self.SelectedGender,
                                       "age" : self.txtAge.text!,
                                       "weight" : self.txtWeight.text!,
                                       "previous_experience" : self.flagExp,
                                       "experience_description" : self.txtWhatType.text!,
                                       ]
        
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
                            UserDefaults.standard.removeObject(forKey: "UserAllData")
                            UserDefaults.standard.synchronize()

                            let dictUser = dict?.value(forKeyPath: "data") as! NSMutableDictionary
                            UserDefaults.standard.set(dictUser, forKey: "UserAllData")
                            UserDefaults.standard.synchronize()
                            
                            //displayAlert(APPNAME, andMessage: "Saved Successfully.")
                            
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
    
    func FETCH_WAIVER_SIGNOF () {
        
        let url = API.BASE_URL + API.FETCH_WAIVER_SIGNOF
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
                            let Text = dictData?.value(forKey: "value") as? String
                            self.lblText.text = Text!
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
