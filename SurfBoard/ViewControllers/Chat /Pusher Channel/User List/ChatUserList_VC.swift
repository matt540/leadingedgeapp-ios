//
//  ChatUserList_VC.swift
//  SurfBoard
//
//  Created by esparkbiz on 4/10/20.
//  Copyright © 2020 esparkbiz. All rights reserved.
//

import UIKit
import Alamofire
import PusherSwift

//protocol AddMessage: NSObjectProtocol
//{
//    func AddMessageMethod(MsgDict:NSDictionary)
//}

class ChatUserList_VC: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    var pusher: Pusher!
    
    //weak var delegate: AddMessage?
    
    var isFromSerchUser:Bool = false
    var arrRooms:NSMutableArray = []
    var RoomKeys = [String]()
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var tableViewHeight: NSLayoutConstraint!
    
    @IBOutlet var viewNoChat: UIView!
    @IBOutlet var lblNoChat: UILabel!
    @IBOutlet var viewNoChatHeight: NSLayoutConstraint!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.viewNoChat.isHidden = true
        self.lblNoChat.isHidden = true
        self.viewNoChatHeight.constant = 0
        
        self.tableView.separatorStyle = .none
        
        self.navigationController?.isNavigationBarHidden = false
        AppDelegate.shared().setupNavigationBar()
        setLeftBarBackItem()
        setTranspertNavigation()
        self.title = "Affiliate Contacts"
        
        var rightBarMenuItem = UIBarButtonItem()
        rightBarMenuItem = UIBarButtonItem(image: UIImage(named: "Add"), style: .plain, target: self, action: #selector(addUserTapped))
        self.navigationItem.rightBarButtonItem = rightBarMenuItem
        
        self.viewNoChat.addCornerRadius(10)
        self.viewNoChat.layer.borderColor = #colorLiteral(red: 0.2784313725, green: 0.4549019608, blue: 0.5921568627, alpha: 1)
        self.viewNoChat.layer.borderWidth = 2
        
        self.view.updateConstraintsIfNeeded()

        self.FetchRooms_API()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 04) { [unowned self] in
            if self.arrRooms.count != 0{
                if AppDelegate.shared().NOTIFICATION_STATUS == true{
                    self.gotoChatRoom()
                }
            }
            else{
                //displayAlert(APPNAME, andMessage: MSG.SOMETHINGWRONG)
            }
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
         self.FetchRooms_API()
        
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        hideLeftBarItem()
//    }
//    override func viewDidDisappear(_ animated: Bool) {
//        hideLeftBarItem()
//    }
    
    //MARK: -  Protocol Method
//    func AddMessageMethod(Dict:NSDictionary)
//    {
//        print(Dict)
//        self.delegate?.AddMessageMethod(MsgDict: Dict)
//    }

    
    //MARK: -  addUserTapped
    @objc func addUserTapped() {
        
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "ChatUserSearch_VC") as! ChatUserSearch_VC
        self.navigationController?.pushViewController(VC, animated: true)
        
    }
    

    //MARK: -  TableView DataSource - Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrRooms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoomCell") as! RoomCell
        cell.selectionStyle = .none
        
        let DictData = self.arrRooms[indexPath.row] as? NSMutableDictionary
        let arrUser = DictData!["users"] as? NSMutableArray
        let arrLastMsg = DictData!["messages"] as? NSMutableArray
        let UserDictData = arrUser![0] as? NSMutableDictionary
        
        var LastMsgDictData:NSMutableDictionary = [:]
        if(arrLastMsg?.count != 0){
            LastMsgDictData = (arrLastMsg![0] as? NSMutableDictionary)!
            cell.lblMsg.text = LastMsgDictData.value(forKey: "message") as? String
        }
        else{
            cell.lblMsg.text = ""
        }
        
        cell.lblName.text = UserDictData?.value(forKey: "name") as? String
        let image = UserDictData?.value(forKey: "image") as? String
        
        cell.imgUser.makeRounded()
        
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
        
        let DictData = self.arrRooms[indexPath.row] as? NSMutableDictionary
        let RoomID = DictData?.value(forKey: "id") as? String
        let arrMsg = DictData?.value(forKey: "messages") as? NSMutableArray
        let arrUser = DictData?.value(forKey: "users") as? NSMutableArray
        
        var DictMsg:NSMutableDictionary = [:]
        if(arrMsg?.count == 0){
            
        }
        else{
            DictMsg = (arrMsg![0] as? NSMutableDictionary)!
        }
        
        let DictUser = arrUser![0] as? NSMutableDictionary
        let LastMsgID = DictMsg.value(forKey: "id") as? Int ?? 0
        let StrLastID = String(LastMsgID)
        let UserName  = DictUser?.value(forKey: "name") as? String
        print(DictData!)
        print(RoomID!)
        
        let ChatVC = self.storyboard?.instantiateViewController(withIdentifier: "Chat1_VC") as! Chat1_VC
        ChatVC.UserChat = UserName!
        ChatVC.SelectedRoom = RoomID!
        ChatVC.LastMsgId = StrLastID
        ChatVC.SelectedRoomDict = DictData!
        ChatVC.LastMsg = DictMsg
        ChatVC.AllRoom = self.RoomKeys
        
        self.isFromSerchUser = true
        
        self.navigationController?.pushViewController(ChatVC, animated: true)
        

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 60
        
    }
    
    //MARK: -  SetupRoomSubScribe Method
    func SetupRoomSubScribe(){
        
        //Live : 05264e54724e00dac390 : us2
        //Test : 2ee8cbc973b01e744920 : mt1
        
        pusher = Pusher(
            key: "05264e54724e00dac390",
            options: PusherClientOptions(
                authMethod: AuthMethod.authRequestBuilder(authRequestBuilder: AuthRequestBuilder()),
                host: .cluster("us2")
            )
        )
        
        
        for RoomID in self.RoomKeys
        {
            
            print(RoomID)
            let channel = pusher.subscribeToPresenceChannel(
                channelName: "presence-chat.\(RoomID)",
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
                }
                 self.FetchRooms_API()
            })
        }

        
        pusher.connect()
    }
    
    //MARK: -  EXTRA METHODS
    func gotoChatRoom()
    {
        print(self.arrRooms)
        for dictdata in self.arrRooms{
            
            let dict = dictdata as? NSMutableDictionary
            let rID = dict?.value(forKey: "id") as! String
            
            if rID == AppDelegate.shared().CHATROOM_ID {
                
                let DictData = dict
                let RoomID = DictData?.value(forKey: "id") as? String
                let arrMsg = DictData?.value(forKey: "messages") as? NSMutableArray
                let arrUser = DictData?.value(forKey: "users") as? NSMutableArray
                
                var DictMsg:NSMutableDictionary = [:]
                if(arrMsg?.count == 0){
                    
                }
                else{
                    DictMsg = (arrMsg![0] as? NSMutableDictionary)!
                }
                
                let DictUser = arrUser![0] as? NSMutableDictionary
                let LastMsgID = DictMsg.value(forKey: "id") as? Int ?? 0
                let StrLastID = String(LastMsgID)
                let UserName  = DictUser?.value(forKey: "name") as? String
                print(DictData!)
                print(RoomID!)
                
                let ChatVC = self.storyboard?.instantiateViewController(withIdentifier: "Chat1_VC") as! Chat1_VC
                ChatVC.UserChat = UserName!
                ChatVC.SelectedRoom = RoomID!
                ChatVC.LastMsgId = StrLastID
                ChatVC.SelectedRoomDict = DictData!
                ChatVC.LastMsg = DictMsg
                ChatVC.AllRoom = self.RoomKeys
                
                self.isFromSerchUser = true
                
                self.navigationController?.pushViewController(ChatVC, animated: true)
            }
        }
    }
    
    
    //MARK: -  FetchRooms_API
    func FetchRooms_API() {
        
        let url = API.BASE_URL + API.FETCH_ROOMS
        let header = ["Content-Type":"application/x-www-form-urlencoded",
                      "Authorization": "Bearer \(AppPrefs.shared.getUserId())"
        ]
        
        if NetworkReachabilityManager()?.isReachable == true
        {
            //AppDelegate.shared().ShowSpinnerView()
            Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.httpBody, headers: header).response { (response) in
               //AppDelegate.shared().HideSpinnerView()
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
                            let Dictdata = (dict?.value(forKey: "data") as? NSMutableDictionary ?? [:])!
                            if(Dictdata.count == 0)
                            {
                                print("No Rooms")
                                self.viewNoChat.isHidden = false
                                self.lblNoChat.isHidden = false
                                self.viewNoChatHeight.constant = 40
                                self.tableViewHeight.constant = 0
                                
                            }
                            else
                            {
                                
                                self.viewNoChat.isHidden = true
                                self.lblNoChat.isHidden = true
                                self.viewNoChatHeight.constant = 0
                                
                                self.RoomKeys = Dictdata.allKeys as! [String]
                                let values = Dictdata.allValues
                                
                                self.arrRooms = []
                                for Temp in values{
                                    let dict = Temp as? NSMutableDictionary
                                    self.arrRooms.add(dict!)
                                }
                                
                                print(self.arrRooms)
                                
                                self.tableView.reloadData()
                                self.tableViewHeight.constant = CGFloat(self.arrRooms.count * 60)
                            }
                            self.view.updateConstraintsIfNeeded()
                            
                            
                            if(self.isFromSerchUser == true){
                                print("FromSerchUser")
                            }
                            else{
                                self.SetupRoomSubScribe()
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


class AuthRequestBuilder: AuthRequestBuilderProtocol {
    func requestFor(socketID: String, channelName: String) -> URLRequest? {
        var request = URLRequest(url: URL(string: API.PUSHER_SERVER_AUTH)!)
        request.httpMethod = "POST"
        request.addValue("Bearer \(AppPrefs.shared.getUserId())", forHTTPHeaderField: "Authorization")
        request.httpBody = "socket_id=\(socketID)&channel_name=\(channelName)".data(using: String.Encoding.utf8)
        return request
    }
}
