//
//  BuyBoard_VC.swift
//  SurfBoard
//
//  Created by esparkbiz on 4/27/20.
//  Copyright © 2020 esparkbiz. All rights reserved.
//

import UIKit
import Alamofire

class BuyBoard_VC: BaseViewController,UITableViewDataSource, UITableViewDelegate {
    
    var arrLocationData:NSMutableArray = []
    var arrselectedArray:NSMutableArray = []
    var DictSelectedSession:NSMutableDictionary = [:]
    
    @IBOutlet private weak var viewPopupUI:UIView!
    @IBOutlet private weak var viewMain:UIView!
    
    @IBOutlet var tableView: UITableView!
    //@IBOutlet var tableViewHeight: NSLayoutConstraint!
    @IBOutlet var btnBook: UIButton!
    @IBOutlet var btnCancel: UIButton!
    
    
    @IBOutlet var viewNotFound: UIView!
    @IBOutlet var viewNotFoundHeight: NSLayoutConstraint!
    @IBOutlet var lblNotFound: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.separatorStyle = .none

        self.navigationController?.isNavigationBarHidden = false
        AppDelegate.shared().setupNavigationBar()
        setLeftBarBackItem()
        setTranspertNavigation()
        self.title = "Buy a Board"
        
        self.showViewWithAnimation()
        self.viewPopupUI.addShadow(color: .lightGray, opacity: 1.0, offset: CGSize(width: 1, height: 1), radius: 2)
        self.viewMain.addCornerRadius(10)
        
        self.viewNotFound.addCornerRadius(10)
        self.viewNotFound.layer.borderColor = #colorLiteral(red: 0.2784313725, green: 0.4549019608, blue: 0.5921568627, alpha: 1)
        self.viewNotFound.layer.borderWidth = 2
        
        self.viewNotFound.isHidden = false
        self.lblNotFound.isHidden = false
        self.viewNotFoundHeight.constant = 30
        //self.btnBook.isHidden = true
        
        //self.tableViewHeight.constant = 0
        self.view.updateConstraintsIfNeeded()
        
        self.btnBook.addCornerRadius(5)
        
        self.Get_Loc_Data()

        
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
    

    //MARK: -  btnBookAction Method
    @IBAction func btnBookAction(_ sender: Any) {
        
//        if(self.DictSelectedSession.count == 0){
//            
//            displayAlert(APPNAME, andMessage: "Please Select Location")
//            
//        }
//        else{
//            
//            let ID = self.DictSelectedSession.value(forKey: "id") as? Int
//            self.CHECK_BOOKING(BtnID: ID!)
//            
//        }
        
        guard let url = URL(string: "https://liftfoils.com/") else {
            return
        }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        else
        {
            print("URL Can't Open.")
        }

        
    }
    
    
    //MARK: -  btnCancelAction Method
    @IBAction func btnCancelAction(_ sender: Any) {
        self.hideViewWithAnimation()
    }
    
    
    //MARK: -  TableView DataSource - Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return self.arrLocationData.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BoardCell") as! BoardCell
        cell.selectionStyle = .none
        
        let Dict = self.arrLocationData[indexPath.row] as? NSMutableDictionary
        cell.lblLocName.text = Dict?.value(forKeyPath: "name") as? String
        let DiscountCode = Dict?.value(forKeyPath: "discount_code") as? String ?? ""
        
        if(DiscountCode != ""){
            cell.lblDiscountCode.text = "Discount Code : " + DiscountCode
        }
        else{
            cell.lblDiscountCode.text = "Discount Code : ---"
        }
        
//        let intId = String(Int(Dict?.object(forKey: "id") as! Int))
//        if self.arrselectedArray.contains(intId)
//        {
//            cell.imgCheck.image = UIImage(named: "Selected_Circle")
//        }
//        else
//        {
//            cell.imgCheck.image = UIImage(named: "Blank_Circle")
//        }
//
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        

        let Dict = self.arrLocationData[indexPath.row] as? NSMutableDictionary
        let DiscountCode = Dict?.value(forKeyPath: "discount_code") as? String ?? ""
        
        if(DiscountCode != ""){
            displayAlert("Discount Code", andMessage: DiscountCode)
        }
        else{
            displayAlert("Discount Code", andMessage: "Not available right now.")
        }
        
//            let Dict = self.arrLocationData[indexPath.row] as? NSMutableDictionary
//            let intId = String(Int(Dict!.object(forKey: "id") as! Int))
//
//            if(self.arrselectedArray.count > 0)
//            {
//                if(self.arrselectedArray.count == 1)
//                {
//                    self.arrselectedArray.remove(intId)
//                    self.DictSelectedSession = [:]
//                }
//                else
//                {
//                    self.arrselectedArray = []
//                    self.arrselectedArray.add(intId)
//                    self.DictSelectedSession = Dict!
//                }
//
//            }
//            else
//            {
//                self.arrselectedArray.add(intId)
//                self.DictSelectedSession = Dict!
//            }
//
//            self.tableView.reloadData()
//            print(self.DictSelectedSession)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      
        return 60
        
    }
    
    //MARK: - API Calls
    func Get_Loc_Data() {
        
        let url = API.BASE_URL + API.BUY_BOARD
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
                            print(dict!)
                            self.arrLocationData = (dict?.value(forKey: "data") as? NSMutableArray)!
                            if(self.arrLocationData.count > 0){
                                
                                self.tableView.reloadData()
                                //self.tableViewHeight.constant = CGFloat(self.arrLocationData.count * 60)
                                
                                self.viewNotFound.isHidden = true
                                self.lblNotFound.isHidden = true
                                self.viewNotFoundHeight.constant = 00
                                //self.btnBook.isHidden = false
                            }
                            else{
                                
                                self.viewNotFound.isHidden = false
                                self.lblNotFound.isHidden = false
                                self.viewNotFoundHeight.constant = 30
                                //self.btnBook.isHidden = true
                                //self.tableViewHeight.constant = 0
                                
                            }
                            self.view.updateConstraintsIfNeeded()
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
    
    func CHECK_BOOKING(BtnID : Int) {
        
        let url = API.BASE_URL + API.CHECK_BOOKING_STATUS
        let param : [String:String] = ["location" : "\(BtnID)"]
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
                            let dictData = dict?.value(forKey: "data") as? NSMutableDictionary
                            let Check_Flag = dictData?.value(forKey: "allowed") as? Bool
                            
                            if(Check_Flag == true)
                            {
                                self.hideViewWithAnimation()
                                var DictForPalce:NSMutableDictionary = [:]
                                

                                DictForPalce = self.DictSelectedSession
                                print(DictForPalce)
                                let nextNavVc = self.storyboard!.instantiateViewController(withIdentifier: "Session_Inner_VC") as! Session_Inner_VC
                                nextNavVc.DictData = DictForPalce
                                self.navigationController?.pushViewController(nextNavVc, animated: true)

                            }
                            else
                            {
                                displayAlert(APPNAME, andMessage: "Currently Booking Not Available For This Location.")
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
