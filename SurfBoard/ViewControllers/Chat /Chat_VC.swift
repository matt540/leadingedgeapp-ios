//
//  Chat_VC.swift
//  SurfBoard
//
//  Created by esparkbiz on 2/4/20.
//  Copyright © 2020 esparkbiz. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import PusherSwift

class Chat_VC: BaseViewController,UITableViewDataSource, UITableViewDelegate {
    
    var pusher: Pusher!
    
    var StrID:Int!
    var SessionID:String!
    var UserImageUrl:String!
    var timer = Timer()
    var count : Int! = 0
    var FetchMsgCount : Int! = 0
    //var heightAtIndexPath:NSMutableDictionary = [:]
    
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
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var tableViewHeight: NSLayoutConstraint!
    @IBOutlet var viewChatHeight: NSLayoutConstraint!
    
    @IBOutlet var txtUserMsg: UITextField!
    @IBOutlet var btnSend: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Refreshing
        scrollView.alwaysBounceVertical = true
        scrollView.bounces  = true
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Refreshing")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        scrollView.addSubview(refreshControl)
        //Refreshing
        
        self.navigationController?.isNavigationBarHidden = false
        AppDelegate.shared().setupNavigationBar()
        setLeftBarBackItem()
        setTranspertNavigation()
        
        self.title = self.UserChat!
        self.viewChatHeight.constant = UIScreen.main.bounds.size.height
        //self.SessionID = String(StrID)
        
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = CGFloat(70.0)
        
        
        //self.scheduledTimerWithTimeInterval()
        
        //tableViewHeight.constant = CGFloat(1000)
        //self.GetMsg_API()
        
        //self.SetupRoomSubScribe()
        
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

                self.tableViewHeight.constant = CGFloat.greatestFiniteMagnitude
                self.tableView.reloadData()
                self.tableView.layoutIfNeeded()
                
                UIView.animate(withDuration: 0, animations: {
                    self.tableView.layoutIfNeeded()
                }) { (complete) in
                    var heightOfTableView: CGFloat = 0.0
                    
                    heightOfTableView = self.tableView.contentSize.height
                    self.tableViewHeight.constant = heightOfTableView
                }
                
//                if(self.arrChatFinalData.count > 0)
//                {
//                    self.scrollToBottom()
//                }
            }
        })
        
        pusher.connect()
        self.GetMsg_API()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        //self.GetMsg_API()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
//        timer.invalidate()
//        count = 0
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        UIView.animate(withDuration: 0, animations: {
            self.tableView.layoutIfNeeded()
        }) { (complete) in
            var heightOfTableView: CGFloat = 0.0
            // Get visible cells and sum up their heights
            let cells = self.tableView.visibleCells
            for cell in cells {
                heightOfTableView += cell.frame.height
            }
            // Edit heightOfTableViewConstraint's constant to update height of table view
            self.tableViewHeight.constant = heightOfTableView
        }
    }
    
    //Refreshing
    @objc func refresh(_ sender: Any) {
        self.isRefreshed = true
        print("Scroll")
        self.GetMsg_API()

        //self.Get_SELL_API()
    }
    //Refreshing
    
//    func SetupRoomSubScribe(){
//
//        pusher = Pusher(
//            key: "2ee8cbc973b01e744920",
//            options: PusherClientOptions(
//                authMethod: AuthMethod.authRequestBuilder(authRequestBuilder: AuthRequestBuilder()),
//                host: .cluster("mt1")
//            )
//        )
//
//
//        for RoomID in self.AllRoom
//        {
//
//            print(RoomID)
//            let channel = pusher.subscribeToPresenceChannel(
//                channelName: "presence-chat.\(RoomID)",
//                onMemberAdded: { member in
//                    print(member)
//            },
//                onMemberRemoved: { member in
//                    print(member)
//            }
//            )
//
//            let _ = channel.bind(eventName: "message.new", callback: { (data: Any?) -> Void in
//
//                if let data1 = data as? [String: AnyObject] {
//                    print(data1)
//                }
//            })
//        }
//
//        pusher.connect()
//
//
//    }
    
//    @objc func showSpinningWheel(_ notification: NSNotification) {
//
//        if let dict = notification.userInfo {
//            let Dict  = dict as? NSDictionary
//            print(Dict!)
//            //self.arrChatData.add(Dict!)
//            self.arrChatData.adding(Dict!)
//            print(self.arrChatData)
//
//            self.tableViewHeight.constant = CGFloat.greatestFiniteMagnitude
//            self.tableView.reloadData()
//            self.tableView.layoutIfNeeded()
//
//            UIView.animate(withDuration: 0, animations: {
//                self.tableView.layoutIfNeeded()
//            }) { (complete) in
//                var heightOfTableView: CGFloat = 0.0
//
//                heightOfTableView = self.tableView.contentSize.height
//                self.tableViewHeight.constant = heightOfTableView
//            }
//
//            if(self.arrChatData.count > 0)
//            {
//                self.scrollToBottom()
//            }
//
//        }
//    }
    
    //MARK: - Protocol Method
//    func AddMessageMethod(MsgDict: NSDictionary) {
//        print(MsgDict)
//    }
    
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
        
//        let DictChat = Dictdata?.value(forKey: "user") as? NSMutableDictionary
//        let ImageURL = DictChat?.value(forKey: "image") as? String ?? ""
//        let Name = DictChat?.value(forKey: "name") as? String ?? ""
        
        if(MsgBy == custID)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChatUserCell") as! ChatUserCell
            cell.selectionStyle = .none
            let Msg = Dictdata?.value(forKey: "message") as? String ?? ""
            cell.lblUserMsg.text = Msg
            
            cell.imgUser.makeRounded()
            //cell.imgUser.downloaded(from: ImageURL)
            
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
            cell.lblAdminMsg.text = Msg
            
            //self.title = Name
            
            cell.imgAdmin.makeRounded()
            //cell.imgAdmin.downloaded(from: ImageURL)
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
    
    
    //MARK: - scrollToBottom tableView Method
    func scrollToBottom(){
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.arrChatData.count-1, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    //MARK: - scrollToBottom tableView Method
    func scheduledTimerWithTimeInterval(){
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateCounting), userInfo: nil, repeats: true)
    }
    
    @objc func updateCounting(){
        count = count + 1
        if Int(count) == 5
        {
            timer.invalidate()
            count = 0
            self.GetMsg_API()
            self.scheduledTimerWithTimeInterval()
        }
        else
        {
            print(count)
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
            //AppDelegate.shared().ShowSpinnerView()
            Alamofire.request(url, method: .post, parameters: param, encoding: URLEncoding.httpBody, headers: header).response { (response) in
                //AppDelegate.shared().HideSpinnerView()
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
                                
 
                                self.tableViewHeight.constant = CGFloat.greatestFiniteMagnitude
                                self.tableView.reloadData()
                                self.tableView.layoutIfNeeded()
                                
                                UIView.animate(withDuration: 0, animations: {
                                    self.tableView.layoutIfNeeded()
                                }) { (complete) in
                                    var heightOfTableView: CGFloat = 0.0
                                    
                                    heightOfTableView = self.tableView.contentSize.height
                                    self.tableViewHeight.constant = heightOfTableView
                                }
                                
                                if(self.arrChatFinalData.count > 0)
                                {
                                    self.scrollToBottom()
                                }
                                
                                if(self.isRefreshed)
                                {
                                    self.refreshControl?.endRefreshing()
                                    self.isRefreshed = false
                                }
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
    
}


