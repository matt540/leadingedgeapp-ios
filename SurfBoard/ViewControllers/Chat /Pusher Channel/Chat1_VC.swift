//
//  Chat1_VC.swift
//  SurfBoard
//
//  Created by esparkbiz on 4/15/20.
//  Copyright © 2020 esparkbiz. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import PusherSwift

class Chat1_VC: BaseViewController,UITableViewDataSource, UITableViewDelegate {
    
    var pusher: Pusher!
    
    var StrID:Int!
    var SessionID:String!
    var UserImageUrl:String!
    var timer = Timer()
    var count : Int! = 0
    var FetchMsgCount : Int! = 0
    
    var UserChat:String!
    var SelectedRoom:String!
    var LastMsgId:String!
    var SelectedRoomDict:NSMutableDictionary = [:]
    var LastMsg:NSMutableDictionary = [:]
    var AllRoom = [String]()
    
    var arrChatData:NSMutableArray = []
    var arrChatFinalData:NSMutableArray = []
    
    //Refreshing
    var isRefreshed:Bool = false
    var refreshControl: UIRefreshControl!
    //Refreshing
    
    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var txtUserMsg: UITextField!
    @IBOutlet var btnSend: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        //Refreshing
        tableView.alwaysBounceVertical = true
        tableView.bounces  = true
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Loading old Messages..")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(refreshControl)
        //Refreshing
        
        self.navigationController?.isNavigationBarHidden = false
        AppDelegate.shared().setupNavigationBar()
        setLeftBarBackItem()
        setTranspertNavigation()
        
        self.title = self.UserChat!
        
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = CGFloat(70.0)
        
        //Live : 05264e54724e00dac390 : us2
        //Test : 2ee8cbc973b01e744920 : mt1
        pusher = Pusher(
            key: "05264e54724e00dac390",
            options: PusherClientOptions(
                authMethod: AuthMethod.authRequestBuilder(authRequestBuilder: AuthRequestBuilder()),
                host: .cluster("us2")
            )
        )
        
        let channel = pusher.subscribeToPresenceChannel(
            channelName: "presence-chat.\(self.SelectedRoom!)",
            onMemberAdded: { member in
                print(member)
        },
            onMemberRemoved: { member in
                print(member)
        }
        )
        
        let _ = channel.bind(eventName: "message.new", callback: { (data: Any?) -> Void in
            
            if let data1 = data as? [String: AnyObject] {
                let values = data1.values
                var MsgDict :NSDictionary!
                
                for Temp in values{
                    MsgDict = Temp as? NSDictionary
                    print(MsgDict!)
                }
                self.arrChatFinalData.add(MsgDict!)
                print(self.arrChatFinalData)
                
                self.tableView.reloadData()
                self.scrollToBottom()
        
            }
        })
        
        pusher.connect()
        self.GetMsg_API()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    //Refreshing
    //MARK: - refresh Method
    @objc func refresh(_ sender: Any) {
        self.isRefreshed = true
        print("Scroll")
        self.GetMsg_API()
    }
    //Refreshing
    

    //MARK: - btnSendAction Method
    @IBAction func btnSendAction(_ sender: Any) {
        
        if(self.txtUserMsg.text! == "")
        {
            displayAlert(APPNAME, andMessage: "Please type a Message.")
        }
        else
        {
            self.SendMsg_API()
        }
        
    }
    
    //MARK: -  TableView DataSource - Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrChatFinalData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let result = UserDefaults.standard.value(forKey: "UserAllData") as? NSDictionary
        let custID = result?.value(forKeyPath: "id") as? Int
        
        let Dictdata = self.arrChatFinalData[indexPath.row] as? NSDictionary
        let MsgBy = Dictdata?.value(forKey: "sender_id") as? Int
        
        let ImageURL = ""

        if(MsgBy == custID)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChatUserCell") as! ChatUserCell
            cell.selectionStyle = .none
            let Msg = Dictdata?.value(forKey: "message") as? String ?? ""
            
            let today = Date()
            let formatingDate = getFormattedDate(date: today, format: "yyyy-MM-dd")
            
            let timeResult = Dictdata?.value(forKey: "created_at") as? Double
            let date = Date(timeIntervalSince1970: timeResult!)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            dateFormatter.timeZone = TimeZone.current
            let localDate = dateFormatter.string(from: date)
            
            var DispDate:String = ""
            
            if(localDate == formatingDate){
                
                let timeResult = Dictdata?.value(forKey: "created_at") as? Double
                let date = Date(timeIntervalSince1970: timeResult!)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "hh:mm a"
                dateFormatter.timeZone = TimeZone.current
                DispDate = dateFormatter.string(from: date)
                
            }
            
            else{
                
                let timeResult = Dictdata?.value(forKey: "created_at") as? Double
                let date = Date(timeIntervalSince1970: timeResult!)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMM d, yyyy hh:mm a"
                dateFormatter.timeZone = TimeZone.current
                DispDate = dateFormatter.string(from: date)
                
            }
            
            cell.lblUserMsg.text = Msg
            cell.lblUserMsgTime.text = DispDate
            
            cell.imgUser.makeRounded()
  
            let result = UserDefaults.standard.value(forKey: "UserAllData") as? NSDictionary
            let image = result?.value(forKeyPath: "image") as? String
            
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
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChatAdminCell") as! ChatAdminCell
            
            cell.selectionStyle = .none
            let Msg = Dictdata?.value(forKey: "message") as? String ?? ""
            
            let today = Date()
            let formatingDate = getFormattedDate(date: today, format: "yyyy-MM-dd")
            
            let timeResult = Dictdata?.value(forKey: "created_at") as? Double
            let date = Date(timeIntervalSince1970: timeResult!)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            dateFormatter.timeZone = TimeZone.current
            let localDate = dateFormatter.string(from: date)
            
            var DispDate:String = ""
            
            if(localDate == formatingDate){
                
                let timeResult = Dictdata?.value(forKey: "created_at") as? Double
                let date = Date(timeIntervalSince1970: timeResult!)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "hh:mm a"
                dateFormatter.timeZone = TimeZone.current
                DispDate = dateFormatter.string(from: date)
                
            }
                
            else{
                
                let timeResult = Dictdata?.value(forKey: "created_at") as? Double
                let date = Date(timeIntervalSince1970: timeResult!)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMM d, yyyy hh:mm a"
                dateFormatter.timeZone = TimeZone.current
                DispDate = dateFormatter.string(from: date)
                
            }
            
            
            cell.lblAdminMsg.text = Msg
            cell.lblAdminMsgTime.text = DispDate

            cell.imgAdmin.makeRounded()
            
            cell.imgAdmin?.sd_setImage(with: URL(string: ImageURL), placeholderImage: UIImage(named: "Register_Icon.png"), options: [.continueInBackground,.lowPriority,.delayPlaceholder], completed: {(image,error,cacheType,url) in
                
                if error == nil
                {
                    cell.imgAdmin.image = image
                }
                else
                {
                    cell.imgAdmin.image =  UIImage(named: "Register_Icon.png")
                }
            })
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        let result = UserDefaults.standard.value(forKey: "UserAllData") as? NSDictionary
        let custID = result?.value(forKeyPath: "id") as? Int
        
        let Dictdata = self.arrChatFinalData[indexPath.row] as? NSDictionary
        let MsgBy = Dictdata?.value(forKey: "sender_id") as? Int
        
        if(MsgBy == custID)
        {
             return true
        }
        else
        {
             return false
        }
        
       
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            print("Delete")
            
            let Dictdata = self.arrChatFinalData[indexPath.row] as? NSDictionary
            let MsgID = Dictdata?.value(forKey: "id") as? Int
            
            self.tableView.beginUpdates()
            self.arrChatFinalData.removeObject(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            self.tableView.endUpdates()
            
            self.DeleteMsg_API(MsgID: MsgID!)
            
        }
    }
    
    //MARK: - scrollToBottom tableView Method
    func scrollToBottom(){
        if(self.arrChatFinalData.count > 3){
            DispatchQueue.main.async {
                let indexPath = IndexPath(row: self.arrChatFinalData.count-1, section: 0)
                self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        }
    }
    
    //MARK: - getFormattedDate Method
    func getFormattedDate(date: Date, format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.timeZone = TimeZone.current//TimeZone(abbreviation: "UTC")!
        dateformat.dateFormat = format
        return dateformat.string(from: date)
    }
    
    //MARK: - scrollToTop tableView Method
    func scrollToTop(){
        DispatchQueue.main.async {
            self.tableView.setContentOffset(.zero, animated: true)
        }
    }
    
    
    
    //MARK: - API Calls
    func GetMsg_API() {
        
        let url = API.BASE_URL + API.GET_MSG_API
        let param : [String:String] = ["room" : self.SelectedRoom,
                                       "last_id" : self.LastMsgId
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
                        self.timer.invalidate()
                        self.count = 0
                    }
                    else
                    {
                        print(dict!)
                        self.FetchMsgCount = self.FetchMsgCount + 1
                        
                        let status = dict?.value(forKeyPath: "status") as? String ?? ""
                        if(status == "error")
                        {
                            displayAlert(APPNAME, andMessage: (dict?.value(forKeyPath: "message") as? String)!)
                        }
                        else
                        {
                            self.arrChatData = (dict?.value(forKey: "data") as? NSMutableArray)!
                            if(self.arrChatData.count == 0)
                            {
                                print("End of MSg")
                                if(self.isRefreshed)
                                {
                                    self.refreshControl?.endRefreshing()
                                    self.isRefreshed = false
                                }
                                
                                if(self.FetchMsgCount == 1){
                                    self.arrChatFinalData = []
                                    if(self.LastMsg.count != 0){
                                        self.arrChatFinalData.add(self.LastMsg)
                                    }
                                    
                                }
                                
                            }
                            else
                            {
                                
                                let reverseArr:NSMutableArray = []
                                
                                //For getting Last Msg Id
                                for item in self.arrChatData {
                                    
                                    let dict  = item as? NSDictionary
                                    let Last = dict?.value(forKey: "id") as! Int
                                    self.LastMsgId = String(Last)
                                    print(self.LastMsgId)
                                    
                                }
                                
                                //For Revering Array to display Msg
                                for item in self.arrChatData.reversed() {
                                    reverseArr.add(item)
                                }
                                
                                if(self.FetchMsgCount > 1){
                                    
                                    for item in self.arrChatFinalData {
                                        reverseArr.add(item)
                                    }
                                    
                                    self.arrChatFinalData = []
                                    self.arrChatFinalData = reverseArr
                                }
                                else{
                                    self.arrChatFinalData = []
                                    self.arrChatFinalData = reverseArr
                                    self.arrChatFinalData.add(self.LastMsg)
                                }
                                
                                
                                //                                self.tableViewHeight.constant = CGFloat.greatestFiniteMagnitude
                                //                                self.tableView.reloadData()
                                //                                self.tableView.layoutIfNeeded()
                                //
                                //                                UIView.animate(withDuration: 0, animations: {
                                //                                    self.tableView.layoutIfNeeded()
                                //                                }) { (complete) in
                                //                                    var heightOfTableView: CGFloat = 0.0
                                //
                                //                                    heightOfTableView = self.tableView.contentSize.height
                                //                                    self.tableViewHeight.constant = heightOfTableView
                                //                                }
                                //
                                //                                if(self.arrChatFinalData.count > 0)
                                //                                {
                                //                                    self.scrollToBottom()
                                //                                }
                                
                                if(self.isRefreshed)
                                {
                                    self.refreshControl?.endRefreshing()
                                    self.isRefreshed = false
                                }
                                else{
                                    self.scrollToBottom()
                                }
                            }
                            
                            if(self.arrChatFinalData.count > 0){
                                self.tableView.reloadData()
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
    func SendMsg_API() {
        
        let url = API.BASE_URL + API.SEND_MSG_API
        let param : [String:String] = ["room" : self.SelectedRoom,
                                       "message" : self.txtUserMsg.text!
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
                        //                        self.timer.invalidate()
                        //                        self.count = 0
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
                            self.txtUserMsg.text = ""
                            self.scrollToBottom()
                            //self.GetMsg_API()
                            
                            //                            let dictData = dict?.value(forKey: "data") as? NSMutableDictionary
                            //                            //self.arrChatData.add(dictData!)
                            //                            self.arrChatData.adding(dictData!)
                            //
                            
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
    
    func DeleteMsg_API(MsgID:Int) {
        
        let ID = String(MsgID)
        let url = API.BASE_URL + API.DELETE_MSG_API
        let param : [String:String] = ["id" : ID]
        
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
                            let dictData = dict?.value(forKey: "data") as? NSMutableDictionary
                            let Check_Flag = dictData?.value(forKey: "success") as? Bool
                            if(Check_Flag == true)
                            {
                                displayAlert(APPNAME, andMessage: "Message Deleted")
                            }
                            else{
                                displayAlert(APPNAME, andMessage: MSG.SOMETHINGWRONG)
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
