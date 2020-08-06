//
//  RatingPopup_VC.swift
//  SurfBoard
//
//  Created by esparkbiz on 2/11/20.
//  Copyright © 2020 esparkbiz. All rights reserved.
//

import UIKit
import Alamofire

class RatingPopup_VC: BaseViewController {
    
    var StrSessionID:Int!
    var StrID:String!
    var RateCount:String = "1"
    
    @IBOutlet weak var cosmosViewFull: CosmosView!
    
    @IBOutlet var btnSubmit: UIButton!
    @IBOutlet private weak var viewPopupUI:UIView!
    @IBOutlet private weak var viewMain:UIView!
    
    
    @IBOutlet var lblRatingTitle: UILabel!
    @IBOutlet var lblRatingQuote: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.StrID = String(StrSessionID)
        self.showViewWithAnimation()
        self.viewPopupUI.addShadow(color: .lightGray, opacity: 1.0, offset: CGSize(width: 1, height: 1), radius: 2)
        self.viewPopupUI.addCornerRadius(10)
        self.btnSubmit.addCornerRadius(10)
        
        cosmosViewFull.didTouchCosmos = didTouchCosmos
        cosmosViewFull.didFinishTouchingCosmos = didFinishTouchingCosmos
        self.updateRating()
        
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
        
        self.lblRatingTitle.text = "RATING_POPUP_TITLE".localize
        
        self.tabBarController?.tabBar.items![0].title = "TABBAR_ITEM_TITLE_0".localize
        self.tabBarController?.tabBar.items![1].title = "TABBAR_ITEM_TITLE_1".localize
        self.tabBarController?.tabBar.items![2].title = "TABBAR_ITEM_TITLE_2".localize
        self.tabBarController?.tabBar.items![3].title = "TABBAR_ITEM_TITLE_3".localize
        self.tabBarController?.tabBar.items![4].title = "TABBAR_ITEM_TITLE_4".localize
        
        self.lblRatingQuote.text = "RATING_POPUP_QUOTE".localize
        self.btnSubmit.setTitle("BTN_RATING_POPUP_SUBMIT".localize, for: .normal)
       
    }
    
    
    //MARK: - updateRating Method
    func updateRating() {
        let value = Double(RateCount)
        cosmosViewFull.rating = value!
        self.RateCount = self.formatValue(value!)
    }
    
    func didTouchCosmos(_ rating: Double) {
        self.RateCount = self.formatValue(Double(rating))
    }
    
    func didFinishTouchingCosmos(_ rating: Double) {
        self.RateCount = self.formatValue(Double(rating))
        print(self.RateCount)
    }
    
    func formatValue(_ value: Double) -> String {
        return String(format: "%.2f", value)
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
    
    
    //MARK: - btnCloseAction Method
    @IBAction func btnCloseAction(_ sender: Any) {
        self.hideViewWithAnimation()
    }
    
    //MARK: - btnSubmitAction Method
    @IBAction func btnSubmitAction(_ sender: Any) {
        self.GetPast_Session_API()
    }
    
    
    //MARK: - API Calls
    func GetPast_Session_API() {
        
        let url = API.BASE_URL + API.SUBMIT_RATING
        
        let param : [String:String] = ["rating" : self.RateCount,
                                       "session_id" : self.StrID
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
                            displayAlert(APPNAME, andMessage:"Submitted Successfully.")
                            self.hideViewWithAnimation()
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
