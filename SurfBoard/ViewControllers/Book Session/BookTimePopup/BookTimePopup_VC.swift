//
//  BookTimePopup_VC.swift
//  SurfBoard
//
//  Created by esparkbiz on 2/6/20.
//  Copyright © 2020 esparkbiz. All rights reserved.
//

import UIKit
import Alamofire

class BookTimePopup_VC: BaseViewController,UITableViewDataSource, UITableViewDelegate {
    
    var SelectDate:String = ""
    var LocID:String!
    var Sesstion_Type:String!
    var Amount:String!
    
    var SelectedDay:String!
    var TimeID:String!
    var DictData: NSMutableDictionary = [:]
    
    var arrTableData:NSMutableArray = []
    var arrMonday:NSMutableArray = []
    var arrTuesday:NSMutableArray = []
    var arrWednesday:NSMutableArray = []
    var arrThursday:NSMutableArray = []
    var arrFriday:NSMutableArray = []
    var arrSatueday:NSMutableArray = []
    var arrSunday:NSMutableArray = []
    
    var arrTimeSlots:[String]!
    
    @IBOutlet var lblSelectedDate: UILabel!
    @IBOutlet var btnClose: UIButton!
    @IBOutlet private weak var viewPopupUI:UIView!
    @IBOutlet private weak var viewMain:UIView!
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var viewNoSession: UIView!
    @IBOutlet var viewNoSessionHeight: NSLayoutConstraint!
    @IBOutlet var lblNoSession: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.separatorStyle = .none
        
        //TimeSlot
        self.arrTimeSlots = ["8:00 AM","9:00 AM","10:00 AM","11:00 AM","12:00 PM","1:00 PM","2:00 PM","3:00 PM","4:00 PM","5:00 PM","6:00 PM","7:00 PM","8:00 PM","9:00 PM","10:00 PM"]
    
        
        self.lblNoSession.isHidden = true
        self.viewNoSession.isHidden = true
        self.viewNoSessionHeight.constant = 0
        self.view.updateConstraintsIfNeeded()
        
        self.showViewWithAnimation()
        self.viewPopupUI.addShadow(color: .lightGray, opacity: 1.0, offset: CGSize(width: 1, height: 1), radius: 2)
        self.viewPopupUI.addCornerRadius(10)
        
        self.lblSelectedDate.text = "Selected Date : " + self.SelectDate
        
        self.GET_TIME_SLOT()
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
    
    //MARK: - getDayOfWeek Method
    func getDayOfWeek(_ today:String) -> Int? {
        let formatter  = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        guard let todayDate = formatter.date(from: today) else { return nil }
        let myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.weekday, from: todayDate)
        return weekDay
    }
    
//    //MARK: -  TableView DataSource - Delegate
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.arrTableSlotData.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Normal_SessionCell") as!
//        cell.selectionStyle = .none
    
//        
//    }
//    
    //MARK: -  TableView DataSource - Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrTableData.count
        //return self.arrTimeSlots.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        let cell = tableView.dequeueReusableCell(withIdentifier: "TimeSlotCell") as! TimeSlotCell
//        cell.selectionStyle = .none
//        cell.lblTimeCell.text = self.arrTimeSlots[indexPath.row]
//
//        if(indexPath.row == 0)
//        {
//            cell.lblOnlyAvalLeftCell.text = "Full Booked (Not Available)"
//            cell.lblOnlyAvalLeftCell.textColor = UIColor.red
//        }
//        else
//        {
//            cell.lblOnlyAvalLeftCell.text = "Only \(indexPath.row) left"
//            cell.lblOnlyAvalLeftCell.textColor = UIColor.black
//        }
//
//        let width = Int(cell.viewCell.frame.size.width - 30)
//        let Divide = indexPath.row + 1
//        let total = width / Divide
//
//        cell.viewBookIndicateWidth.constant = CGFloat(total)
//        self.view.updateConstraintsIfNeeded()
//
//        return cell
        
        
        if(self.Sesstion_Type == "normal_session")
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Normal_SessionCell") as! Normal_SessionCell
            cell.selectionStyle = .none

            let Dict = self.arrTableData[indexPath.row] as? NSMutableDictionary

            let Fromtime = Dict?.value(forKey: "from_time") as? String
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm:ss"
            let date = dateFormatter.date(from: Fromtime!)
            dateFormatter.dateFormat = "h:mm a"
            let From = dateFormatter.string(from: date!)

            let Totime = Dict?.value(forKey: "to_time") as? String
            let dateFormatter1 = DateFormatter()
            dateFormatter1.dateFormat = "HH:mm:ss"
            let date1 = dateFormatter1.date(from: Totime!)
            dateFormatter1.dateFormat = "h:mm a"
            let To = dateFormatter1.string(from: date1!)

            let dateFormatter12 = DateFormatter()
            dateFormatter12.dateFormat = "h:mm a"
            let calendar = Calendar.current
            let From1 = calendar.dateComponents([.hour, .minute], from: date!)
            let To1 = calendar.dateComponents([.hour, .minute], from: date1!)
            let CostBasedOnTime = calendar.dateComponents([.minute], from: From1, to: To1).minute!

            var Day = Dict?.value(forKey: "day") as? String
            if(Day == "sunday")
            {
                Day = "Sunday"
            }
            else if(Day == "monday")
            {
                Day = "Monday"
            }
            else if(Day == "tuesday")
            {
                Day = "Tuesday"
            }
            else if(Day == "wednesday")
            {
                Day = "Wednesday"
            }
            else if(Day == "thursday")
            {
                Day = "Thursday"
            }
            else if(Day == "friday")
            {
                Day = "Friday"
            }
            else
            {
                Day = "Saturday"
            }

            cell.lblDateCell.text = "Session Date : " + self.SelectDate
            cell.lblDescCell.text = "Session Time : " + From + " - " + To
            cell.lblAmountCell.text = "Session Day : " + Day!
            cell.lblNormalAmountCell.text = "Session Cost : $" + String(CostBasedOnTime)
            cell.imgCell.image = UIImage(named: "imgBook.png")

            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Session_InnerCell") as! Session_InnerCell
            cell.selectionStyle = .none

            let Dict = self.arrTableData[indexPath.row] as? NSMutableDictionary

            let Fromtime = Dict?.value(forKey: "from_time") as? String
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm:ss"
            let date = dateFormatter.date(from: Fromtime!)
            dateFormatter.dateFormat = "h:mm a"
            let From = dateFormatter.string(from: date!)

            let Totime = Dict?.value(forKey: "to_time") as? String
            let dateFormatter1 = DateFormatter()
            dateFormatter1.dateFormat = "HH:mm:ss"
            let date1 = dateFormatter1.date(from: Totime!)
            dateFormatter1.dateFormat = "h:mm a"
            let To = dateFormatter1.string(from: date1!)

            var Day = Dict?.value(forKey: "day") as? String
            if(Day == "sunday")
            {
                Day = "Sunday"
            }
            else if(Day == "monday")
            {
                Day = "Monday"
            }
            else if(Day == "tuesday")
            {
                Day = "Tuesday"
            }
            else if(Day == "wednesday")
            {
                Day = "Wednesday"
            }
            else if(Day == "thursday")
            {
                Day = "Thursday"
            }
            else if(Day == "friday")
            {
                Day = "Friday"
            }
            else
            {
                Day = "Saturday"
            }

            cell.lblDateCell.text = "Session Date : " + self.SelectDate
            cell.lblDescCell.text = "Session Time : " + From + " - " + To
            cell.lblAmountCell.text = "Session Day : " + Day!
            cell.imgCell.image = UIImage(named: "imgBook.png")

            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let Dict = self.arrTableData[indexPath.row] as? NSMutableDictionary
        let id = Dict!["id"] as? Int ?? 0
        self.TimeID = String(id)
        
        //self.hideViewWithAnimation()
        self.CHECK_BOOKING()
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        if(self.Sesstion_Type == "normal_session")
        {
            return 110
        }
        else
        {
            return 85
        }
    }
    
    
    //MARK: - API Calls
    func GET_TIME_SLOT() {
        
        let url = API.BASE_URL + API.GET_TIME_SLOT
        
        let param : [String:String] = ["location_id" : self.LocID]
        
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
                            self.arrMonday = (dict?.value(forKeyPath: "data.monday") as? NSMutableArray)!
                            self.arrTuesday = (dict?.value(forKeyPath: "data.tuesday") as? NSMutableArray)!
                            self.arrWednesday = (dict?.value(forKeyPath: "data.wednesday") as? NSMutableArray)!
                            self.arrThursday = (dict?.value(forKeyPath: "data.thursday") as? NSMutableArray)!
                            self.arrFriday = (dict?.value(forKeyPath: "data.friday") as? NSMutableArray)!
                            self.arrSatueday = (dict?.value(forKeyPath: "data.saturday") as? NSMutableArray)!
                            self.arrSunday = (dict?.value(forKeyPath: "data.sunday") as? NSMutableArray)!
                            
                            if let weekday = self.getDayOfWeek(self.SelectDate) {
                                
                                if(weekday == 1)
                                {
                                    self.SelectedDay = "sunday"
                                    self.arrTableData = self.arrSunday
                                }
                                else if(weekday == 2)
                                {
                                    self.SelectedDay = "monday"
                                    self.arrTableData = self.arrMonday
                                }
                                else if(weekday == 3)
                                {
                                    self.SelectedDay = "tuesday"
                                    self.arrTableData = self.arrTuesday
                                }
                                else if(weekday == 4)
                                {
                                    self.SelectedDay = "wednesday"
                                    self.arrTableData = self.arrWednesday
                                }
                                else if(weekday == 5)
                                {
                                    self.SelectedDay = "thursday"
                                    self.arrTableData = self.arrThursday
                                }
                                else if(weekday == 6)
                                {
                                    self.SelectedDay = "friday"
                                    self.arrTableData = self.arrFriday
                                }
                                else if(weekday == 7)
                                {
                                    self.SelectedDay = "saturday"
                                    self.arrTableData = self.arrSatueday
                                }
                                else
                                {
                                    
                                }
                                print(weekday)
                                print(self.SelectedDay)
                                
                            }
                            else
                            {
                                print("bad input")
                            }
                            
                            if(self.arrTableData.count != 0)
                            {
                                self.lblNoSession.isHidden = true
                                self.viewNoSession.isHidden = true
                                self.viewNoSessionHeight.constant = 0
                                
                            }
                            else
                            {
                                self.lblNoSession.isHidden = false
                                self.viewNoSession.isHidden = false
                                self.viewNoSessionHeight.constant = 40
                            }
                            self.tableView.reloadData()
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
                                let LocationID = self.DictData["id"] as? Int
                                self.DictData.setValue(self.SelectDate, forKey: "date")
                                self.DictData.setValue(self.Sesstion_Type, forKey: "type")
                                self.DictData.setValue(self.TimeID, forKey: "timeID")
                                
                                let nextNavVc = self.storyboard!.instantiateViewController(withIdentifier: "Payment_VC") as! Payment_VC
                                nextNavVc.dictData = self.DictData
                                nextNavVc.strID = LocationID
                                nextNavVc.Amount = self.Amount
                                self.navigationController?.pushViewController(nextNavVc, animated: true)
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
