//
//  ChatUserSearch_VC.swift
//  SurfBoard
//
//  Created by esparkbiz on 4/10/20.
//  Copyright © 2020 esparkbiz. All rights reserved.
//

import UIKit
import Alamofire

class ChatUserSearch_VC: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    var strSearch:String = ""
    var CreateRoomID:String = ""
    var arrData:NSMutableArray = []
    
    @IBOutlet var txtSearch: UITextField!
    @IBOutlet var btnSearch: UIButton!
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var tableViewHeight: NSLayoutConstraint!
    
    @IBOutlet var viewUserNotFound: UIView!
    @IBOutlet var viewUserNotFoundHeight: NSLayoutConstraint!
    @IBOutlet var lblUserNotFound: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.separatorStyle = .none

        self.navigationController?.isNavigationBarHidden = false
        AppDelegate.shared().setupNavigationBar()
        setLeftBarBackItem()
        setTranspertNavigation()
        self.title = "Affiliate Contacts"
        
        self.btnSearch.addCornerRadius(10)
        
        self.viewUserNotFound.isHidden = true
        self.lblUserNotFound.isHidden = true
        self.viewUserNotFoundHeight.constant = 0
        
        self.viewUserNotFound.addCornerRadius(10)
        self.viewUserNotFound.layer.borderColor = #colorLiteral(red: 0.2784313725, green: 0.4549019608, blue: 0.5921568627, alpha: 1)
        self.viewUserNotFound.layer.borderWidth = 2
        
        self.view.updateConstraintsIfNeeded()
    }
    

    //MARK: -  btnSearchAction
    @IBAction func btnSearchAction(_ sender: Any) {
        
        if(self.txtSearch.text! == ""){
            displayAlert(APPNAME, andMessage: "Enter Text to Search")
        }
        else{
            self.strSearch = self.txtSearch.text!
            self.Search_Contact_Chat()
        }
        
    }
    
    //MARK: -  TableView DataSource - Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchUserCell") as! SearchUserCell
        cell.selectionStyle = .none
        
        let DictData = self.arrData[indexPath.row] as? NSMutableDictionary
        
        cell.lblName.text = DictData?.value(forKey: "name") as? String
        
        cell.imgUser.makeRounded()
        
        let image = DictData?.value(forKey: "image") as? String
        cell.imgUser?.sd_setImage(with: URL(string: image!), placeholderImage: UIImage(named: "Register_Icon.png"), options: [.continueInBackground,.lowPriority], completed: {(image,error,cacheType,url) in
            
            if error == nil
            {
                cell.imgUser.image = image
            }
            else
            {
                cell.imgUser.image =  UIImage(named: "Register_Icon.png")
            }
        })
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let DictData = self.arrData[indexPath.row] as? NSMutableDictionary
        print(DictData!)
        
        let ID = DictData?.value(forKey: "id") as? Int
        self.CreateRoomID = String(ID!)
        
        if(self.CreateRoomID != ""){
            self.Create_Room()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 60
        
    }
    
    
    //MARK: -  API Calls
    func Search_Contact_Chat() {
        
        let url = API.BASE_URL + API.SEARCH_CONTACT
        
        let param : [String:String] = ["search" : self.strSearch]
        
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
                            self.txtSearch.text = ""
                            self.arrData = (dict?.value(forKey: "data") as? NSMutableArray)!
                            print(self.arrData)
                            
                            if(self.arrData.count == 0)
                            {
                                self.viewUserNotFound.isHidden = false
                                self.lblUserNotFound.isHidden = false
                                self.viewUserNotFoundHeight.constant = 30
                                self.tableViewHeight.constant = 0
                                
                            }
                            else
                            {
                                self.viewUserNotFound.isHidden = true
                                self.lblUserNotFound.isHidden = true
                                self.viewUserNotFoundHeight.constant = 0
                                
                                self.tableView.reloadData()
                                self.tableViewHeight.constant = CGFloat(self.arrData.count * 60)
                            }
                            
                            self.view.updateConstraintsIfNeeded()
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
    
    func Create_Room() {
        
        let url = API.BASE_URL + API.CREATE_ROOMS
        
        let param : [String:String] = ["user" : self.CreateRoomID]
        
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
                            let DictCreate = (dict?.value(forKey: "data") as? NSMutableDictionary ?? [:])!
                            if(DictCreate.count != 0)
                            {
                                let alert = UIAlertController(title: APPNAME, message: "Added Successfully", preferredStyle: UIAlertController.Style.alert)
                                
                                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
                                    
//                                    let VC = self.storyboard?.instantiateViewController(withIdentifier: "ChatUserList_VC") as! ChatUserList_VC
//                                    VC.isFromSerchUser = true
//                                    self.navigationController?.popToViewController(VC, animated: true)
                                   self.navigationController?.popViewController(animated: true)
                                    
                                }))
                                self.present(alert, animated: true, completion: nil)
                                
                            }else{
                                print("Error in Creating Room")
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
