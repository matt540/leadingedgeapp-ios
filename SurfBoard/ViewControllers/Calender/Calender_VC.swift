//
//  Calender_VC.swift
//  SurfBoard
//
//  Created by esparkbiz on 12/5/19.
//  Copyright © 2019 esparkbiz. All rights reserved.
//

import UIKit
import Alamofire

class Calender_VC: BaseViewController, CalendarViewDataSource, CalendarViewDelegate, UITableViewDataSource, UITableViewDelegate, CancelSession {
    
    var isFromMenu:Bool = false
    var arrSessions:NSMutableArray = []
    var arrSelectedDates = [String]()
    var arrTempDates = [String]()
    
    //
    var arrCalSelectedDates:[String] = []
    //
    @IBOutlet var segmentedControl: DGSegmentedControl!
    @IBOutlet var calenderView: CalendarView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var tableViewHeight: NSLayoutConstraint!
    
    @IBOutlet var viewSegment: UIView!
    @IBOutlet var viewSegmentHeight: NSLayoutConstraint!
    
    @IBOutlet var ViewUpcominSegment2: UIView!
    
    @IBOutlet var lblSessionError: UILabel!
    @IBOutlet var viewSessionError: UIView!
    @IBOutlet var viewSessionErrorHeight: NSLayoutConstraint!
    
    @IBOutlet var btnBookSession: UIButton!
    @IBOutlet var viewErrorHeight: NSLayoutConstraint!
    @IBOutlet var viewError: UIView!
    
    
    @IBOutlet var lblNoSessionTitle: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(isFromMenu == true)
        {
            self.navigationController?.isNavigationBarHidden = false
            AppDelegate.shared().setupNavigationBar()
            setLeftBarBackItem()
            self.title = "My Sessions"
            setTranspertNavigation()
        }
        else
        {
            self.navigationController?.isNavigationBarHidden = false
            AppDelegate.shared().setupNavigationBar()
            self.title = "My Sessions"//"Upcoming Sessions"
            setTranspertNavigation()
        }
        
        self.ViewUpcominSegment2.addCornerRadius(10)
        
        self.tableView.separatorStyle = .none
        
        self.viewSegmentHeight.constant = 0
        self.viewSegment.isHidden = true
        
        self.viewSessionErrorHeight.constant = 0
        self.viewErrorHeight.constant = 0
        self.viewError.isHidden = true
        self.viewSessionError.isHidden = true
        self.lblSessionError.isHidden = true
        self.btnBookSession.isHidden = true
        self.view.updateConstraintsIfNeeded()
        
        self.btnBookSession.addCornerRadius(10)
        
        self.viewSessionError.addCornerRadius(10)
        self.viewSessionError.layer.borderColor = #colorLiteral(red: 0.2784313725, green: 0.4549019608, blue: 0.5921568627, alpha: 1)
        self.viewSessionError.layer.borderWidth = 2
        
        CalendarView.Style.cellShape                = .round//.bevel(8.0)
        CalendarView.Style.cellColorDefault         = UIColor.clear
        CalendarView.Style.cellColorToday           = UIColor.black
        CalendarView.Style.cellSelectedBorderColor  = #colorLiteral(red: 0.2784313725, green: 0.4549019608, blue: 0.5921568627, alpha: 1)
        CalendarView.Style.cellSelectedColor        = #colorLiteral(red: 0.2784313725, green: 0.4549019608, blue: 0.5921568627, alpha: 1)
        CalendarView.Style.cellSelectedTextColor    = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        CalendarView.Style.cellEventColor           = UIColor.clear
        CalendarView.Style.headerTextColor          = UIColor.black
        CalendarView.Style.cellTextColorDefault     = UIColor.black
        CalendarView.Style.cellTextColorToday       = UIColor.orange
        
        CalendarView.Style.firstWeekday             = .monday
        CalendarView.Style.timeZone                 = TimeZone.current//TimeZone(abbreviation: "UTC")!
        
        let lang = DGLocalization.sharedInstance.getCurrentLanguage()
        if (lang.languageCode == "en"){
            CalendarView.Style.locale = Locale(identifier: "en_US")
        }
        else if (lang.languageCode == "es"){
            CalendarView.Style.locale = Locale(identifier: "es-ES")
        }
        else if (lang.languageCode == "de"){
            CalendarView.Style.locale = Locale(identifier: "de-DE")
        }
        else if (lang.languageCode == "fr"){
            CalendarView.Style.locale = Locale(identifier: "fr-FR")
        }
        else if (lang.languageCode == "it"){
            CalendarView.Style.locale = Locale(identifier: "it-IT")
        }
        else{
            CalendarView.Style.locale = Locale(identifier: "en_US")
        }
        //CalendarView.Style.locale                   = Locale(identifier: "en_US")
        
        CalendarView.Style.hideCellsOutsideDateRange = true
        CalendarView.Style.changeCellColorOutsideRange = false
        
        calenderView.dataSource = self
        calenderView.delegate = self
        calenderView.isUserInteractionEnabled = false
        
        calenderView.direction = .horizontal
        calenderView.multipleSelectionEnable = true
        calenderView.marksWeekends = false
        
        calenderView.backgroundColor = #colorLiteral(red: 0.7294117647, green: 0.8901960784, blue: 0.9764705882, alpha: 1)
        //        self.GetUpcoming_Session_API()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        self.viewSessionErrorHeight.constant = 0
        self.viewErrorHeight.constant = 0
        self.viewError.isHidden = true
        self.viewSessionError.isHidden = true
        self.lblSessionError.isHidden = true
        self.btnBookSession.isHidden = true
        self.view.updateConstraintsIfNeeded()
        
        
        self.viewSessionError.addCornerRadius(10)
        self.viewSessionError.layer.borderColor = #colorLiteral(red: 0.2784313725, green: 0.4549019608, blue: 0.5921568627, alpha: 1)
        self.viewSessionError.layer.borderWidth = 2
        
        let today = Date()
        
        //var tomorrowComponents = DateComponents()
        //tomorrowComponents.day = 1
        //let tomorrow = self.calenderView.calendar.date(byAdding: tomorrowComponents, to: today)!
        //self.calenderView.selectDate(tomorrow)
        
        
        #if KDCALENDAR_EVENT_MANAGER_ENABLED
        self.calenderView.loadEvents() { error in
            if error != nil {
                //                let message = "The calender could not load system events. It is possibly a problem with permissions."
                //                let alert = UIAlertController(title: "Events Loading Error", message: message, preferredStyle: .alert)
                //                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                //                self.present(alert, animated: true, completion: nil)
            }
        }
        #endif
        
        self.calenderView.setDisplayDate(today)
        //self.RemoveDateOnLoad()
        
        if AppDelegate.shared().NOTIFICATION_STATUS == true{
            
            self.GetPast_Session_API()
        }
        else{
            
            self.GetUpcoming_Session_API()
        }
        
        
        self.setupLang()
        self.setupSegments()
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
        
        self.title = "MY_SESSIONS_TITLE".localize
        
        self.tabBarController?.tabBar.items![0].title = "TABBAR_ITEM_TITLE_0".localize
        self.tabBarController?.tabBar.items![1].title = "TABBAR_ITEM_TITLE_1".localize
        self.tabBarController?.tabBar.items![2].title = "TABBAR_ITEM_TITLE_2".localize
        self.tabBarController?.tabBar.items![3].title = "TABBAR_ITEM_TITLE_3".localize
        self.tabBarController?.tabBar.items![4].title = "TABBAR_ITEM_TITLE_4".localize
        
        self.lblNoSessionTitle.text = "NO_SESSIONS".localize
        self.btnBookSession.setTitle("BTN_BOOK_SESSION".localize, for: .normal)
        
        self.tableView.reloadData()
    }
    
    
    private func setupSegments() {
        
        //self.segmentedControl.items = ["list","day","month","year"]
        self.segmentedControl.items = ["UPCOMING_SESSIONS".localize,"PREVIOUS_SESSIONS".localize]
        if AppDelegate.shared().NOTIFICATION_STATUS == true{
            self.segmentedControl.selectedIndex = 1
        }
        else{
            self.segmentedControl.selectedIndex = 0
        }
        self.segmentedControl.borderSize = 0
        self.segmentedControl.thumbColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.segmentedControl.selectedLabelColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.segmentedControl.thumUnderLineSize = 2
        self.segmentedControl.font = UIFont.systemFont(ofSize: 17)
        self.segmentedControl.addTarget(self, action:#selector(segmentValueChanged(segmentControl:)), for: .valueChanged)
        
    }
    
    //MARK:- Segment Actions
    @objc func segmentValueChanged(segmentControl: DGSegmentedControl)
    {
        if segmentControl.selectedIndex == 0 {
            
            self.RemoveDate()
            //self.GetUpcoming_Session_API()
            
        }
        
        if segmentControl.selectedIndex == 1 {
            
            self.RemoveDate()
            //self.GetPast_Session_API()
            
        }
    }
    
    // MARK: - KDCalendarDataSource
    func startDate() -> Date {
        
        let extractedExpr = DateComponents()
        var dateComponents = extractedExpr
        dateComponents.month = -3
        
        let today = Date()
        let threeMonthsAgo = self.calenderView.calendar.date(byAdding: dateComponents, to: today)!
        
        return threeMonthsAgo
    }
    
    func endDate() -> Date {
        
        var dateComponents = DateComponents()
        dateComponents.year = 2
        let today = Date()
        let twoYearsFromNow = self.calenderView.calendar.date(byAdding: dateComponents, to: today)!
        
        return twoYearsFromNow
    }
    
    //MARK: - Protocol Method
    func btnCancelAction(_ sender: Any?) {
        
        let refreshAlert = UIAlertController(title: APPNAME, message: "Please contact the Affiliate to receive a refund", preferredStyle: UIAlertController.Style.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Initiate Refund", style: .default, handler: { (action: UIAlertAction!) in
            
            let cell = sender as! CalenderCell
            let indexpath = self.tableView.indexPath(for: cell)
            let dict = self.arrSessions[(indexpath?.row)!] as? NSMutableDictionary
            let BtnID = dict!["id"] as? Int
            print(String(BtnID!))
            
            let ServerDate = dict!["date"] as? String
            let ServerTime = dict!["start_time"] as? String
            let ServerDateTime = ServerDate! + " " + ServerTime!
            print(ServerDateTime)
            
            let dateFormatter : DateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let date = Date()
            let dateString = dateFormatter.string(from: date)
            print(dateString)
            
            let dateString1 = dateString
            let dateString2 = ServerDateTime
            
            let Dateformatter = DateFormatter()
            Dateformatter.timeZone = TimeZone.current
            Dateformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            let date1 = Dateformatter.date(from: dateString1)
            let date2 = Dateformatter.date(from: dateString2)
            
            let distanceBetweenDates: TimeInterval? = date2?.timeIntervalSince(date1!)
            let secondsInAnHour: Double = 3600
            let secondsInDays: Double = 86400
            let secondsInWeek: Double = 604800
            
            let hoursBetweenDates = Int((distanceBetweenDates! / secondsInAnHour))
            let daysBetweenDates = Int((distanceBetweenDates! / secondsInDays))
            let weekBetweenDates = Int((distanceBetweenDates! / secondsInWeek))
            
            print(weekBetweenDates,"weeks")//0 weeks
            print(daysBetweenDates,"days")//5 days
            print(hoursBetweenDates,"hours")//120 hours
            
            if(hoursBetweenDates > 24){
                
                self.CancelSession(Session: String(BtnID!))
                
            }
            else
            {
                displayAlert(APPNAME, andMessage: "Your session is occurring within the 24 hours. Please contact the affiliate directly to cancel")
            }
            
            
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action: UIAlertAction!) in
            
            print("User Cancelled.")
            
        }))
        
        present(refreshAlert, animated: true, completion: nil)
        
    }
    
    func btnrescheduleAction(_ sender: Any?) {
        
        let Message = "Are you sure, you want to reschedule session?"
        
        let refreshAlert = UIAlertController(title: APPNAME, message: Message, preferredStyle: UIAlertController.Style.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            
            
            let cell = sender as! CalenderCell
            let indexpath = self.tableView.indexPath(for: cell)
            let dict = self.arrSessions[(indexpath?.row)!] as? NSMutableDictionary
            let SessionID = dict!["id"] as? Int
            let LocationID = dict!["location_id"] as? Int
            print(String(SessionID!))
            print(String(LocationID!))
            let strSessionID = String(SessionID!)
            self.GetLocationDetails(Session: strSessionID)
            
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            print("User Cancelled.")
        }))
        
        present(refreshAlert, animated: true, completion: nil)
        
    }
    
    
    //MARK: - KDCalendarDelegate
    func calendar(_ calendar: CalendarView, didSelectDate date : Date, withEvents events: [CalendarEvent]) {
        print("Did Select: \(date) with \(events.count) events")
    }
    
    func calendar(_ calendar: CalendarView, didScrollToMonth date : Date) {
        
    }
    
    func calendar(_ calendar: CalendarView, didLongPressDate date : Date, withEvents events: [CalendarEvent]?) {
        
        if let events = events {
            for event in events {
                print("\t\"\(event.title)\" - Starting at:\(event.startDate)")
            }
        }
    }
    
    //MARK: - Button Actions
    @IBAction func btnBookSessionAction(_ sender: Any) {
        
        self.tabBarController?.selectedIndex = 1
    }
    
    @IBAction func onValueChange(_ picker : UIDatePicker) {
        self.calenderView.setDisplayDate(picker.date, animated: true)
    }
    
    @IBAction func goToPreviousMonth(_ sender: Any) {
        self.calenderView.goToPreviousMonth()
        
        //self.RemoveSelectedDates()
        //        self.setupSegments()
        //        self.RemoveDate()
        //        self.GetUpcoming_Session_API()
    }
    
    @IBAction func goToNextMonth(_ sender: Any) {
        self.calenderView.goToNextMonth()
        
        //self.RemoveSelectedDates()
        //        self.setupSegments()
        //        self.RemoveDate()
        //        self.GetUpcoming_Session_API()
    }
    
    func RemoveDate()
    {
        AppDelegate.shared().AllowDateSelecetionInCalendar = true
        if(self.arrTempDates.count != 0)
        {
            for DateSet in arrTempDates
            {
                let dateFormatter = DateFormatter()
                dateFormatter.timeZone = TimeZone.current
                //dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
                dateFormatter.dateFormat = "yyyy-MM-dd"//"yyyy-MM-dd'T'HH:mm:ssZ"
                let date = dateFormatter.date(from:DateSet)!
                self.calenderView.selectDate(date)
            }
            self.arrSelectedDates = []
            self.arrCalSelectedDates = []
            self.arrTempDates = []
            
            if(self.segmentedControl.selectedIndex == 0)
            {
                self.GetUpcoming_Session_API()
            }
            else
            {
                self.GetPast_Session_API()
            }
        }
        else
        {
            if(self.segmentedControl.selectedIndex == 0)
            {
                self.GetUpcoming_Session_API()
            }
            else
            {
                self.GetPast_Session_API()
            }
        }
        AppDelegate.shared().AllowDateSelecetionInCalendar = false
    }
    
    
    
    
    
    //MARK: -  TableView DataSource - Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrSessions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(self.segmentedControl.selectedIndex == 0)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CalenderCell") as! CalenderCell
            cell.selectionStyle = .none
            cell.delegate = self
            
            let Dictdata = self.arrSessions[indexPath.row] as? NSMutableDictionary
            //let TimeSlot = Dictdata?.value(forKey: "time_slot") as? NSMutableDictionary
            
            let Fromtime = Dictdata?.value(forKey: "start_time") as? String
            let dateFormatter01 = DateFormatter()
            dateFormatter01.timeZone = TimeZone.current
            dateFormatter01.dateFormat = "HH:mm:ss"
            let Fromdate = dateFormatter01.date(from: Fromtime!)
            dateFormatter01.dateFormat = "h:mm a"
            
            let Totime = Dictdata?.value(forKey: "end_time") as? String
            let dateFormatter02 = DateFormatter()
            dateFormatter02.timeZone = TimeZone.current
            dateFormatter02.dateFormat = "HH:mm:ss"
            let Todate1 = dateFormatter02.date(from: Totime!)
            dateFormatter02.dateFormat = "h:mm a"
            
            let dateFormatter12 = DateFormatter()
            dateFormatter12.timeZone = TimeZone.current
            dateFormatter12.dateFormat = "h:mm a"
            let calendar = Calendar.current
            let From1 = calendar.dateComponents([.hour, .minute], from: Fromdate!)
            let To1 = calendar.dateComponents([.hour, .minute], from: Todate1!)
            let CostBasedOnTime = calendar.dateComponents([.minute], from: From1, to: To1).minute!
            
            let Date = Dictdata?.value(forKey: "date") as? String
            cell.lblDate.text = "SESSION_DATE".localize + Date!
            
            let DictLoc = Dictdata?.value(forKey: "location") as? NSMutableDictionary
            let strLoc = DictLoc?.value(forKey: "name") as? String
            cell.lblLoc.text = "SESSION_LOC".localize + strLoc!
            
            var type = Dictdata?.value(forKey: "type") as? String
            
            if(type == "discovery_enrollment")
            {
                type = "Discovery Enrollment"
            }
            else if(type == "discovery_lesson")
            {
                type = "Discovery Lesson"
            }
            else if(type == "cruiser")
            {
                type = "Cruiser"
            }
            else if(type == "explorer")
            {
                type = "Explorer"
            }
            else if(type == "sport")
            {
                type = "Sport"
            }
            else if(type == "pro")
            {
                type = "Pro"
            }
            else if(type == "certificate")
            {
                type = "Certificate"
            }
            else if(type == "normal")
            {
                type = "Normal Session"
            }
            else
            {
                type = "Session"
            }
            
            cell.lblType.text = "SESSION_TYPE".localize + type!
            
            if(type == "Normal Session")
            {
                let Cost = Dictdata?.value(forKey: "cost") as? String
                cell.lblCost.text = "SESSION_COST".localize + Cost!
                //cell.lblCost.text = "SESSION_COST".localize + String(CostBasedOnTime)
            }
            else
            {
                let Cost = Dictdata?.value(forKey: "cost") as? String
                cell.lblCost.text = "SESSION_COST".localize + Cost!
            }
            
            let SessionTime = Dictdata?.value(forKey: "start_time") as? String ?? ""
            cell.lblTime.text = "Session Time : ".localize + SessionTime
            
            cell.CellView.addCornerRadius(10)
            cell.CellView.layer.borderColor = #colorLiteral(red: 0.2784313725, green: 0.4549019608, blue: 0.5921568627, alpha: 1)
            cell.CellView.layer.borderWidth = 2
            
            //            let DateForCal = Date!// + "T04:00:00+0000"
            //            let dateFormatter = DateFormatter()
            //            dateFormatter.timeZone = TimeZone.current
            //            dateFormatter.dateFormat = "yyyy-MM-dd"//"yyyy-MM-dd'T'HH:mm:ssZ"
            //            let date = dateFormatter.date(from:DateForCal)!
            //
            //            AppDelegate.shared().AllowDateSelecetionInCalendar = true
            //
            //
            //            self.arrSelectedDates.append(DateForCal)
            //            print(self.arrSelectedDates)
            //
            //            for alldate in self.arrSelectedDates
            //            {
            //                if(self.arrTempDates.contains(alldate)){
            //
            //                }
            //                else{
            //                    self.arrTempDates.append(alldate)
            //                    self.calenderView.selectDate(date)
            //                }
            //            }
            
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PastSessionCell") as! PastSessionCell
            cell.selectionStyle = .none
            
            let Dictdata = self.arrSessions[indexPath.row] as? NSMutableDictionary
            
            let Status = Dictdata?.value(forKey: "status") as? Int
            if(Status == 3){
                cell.btnCancel.isHidden = false
                cell.lblSubmit.text = "Not Allowed"
            }
            else{
                cell.btnCancel.isHidden = true
                cell.lblSubmit.text = "Click to Submit"
            }
            //let TimeSlot = Dictdata?.value(forKey: "time_slot") as? NSMutableDictionary
            
            let Fromtime = Dictdata?.value(forKey: "start_time") as? String
            let dateFormatter01 = DateFormatter()
            dateFormatter01.timeZone = TimeZone.current
            dateFormatter01.dateFormat = "HH:mm:ss"
            let Fromdate = dateFormatter01.date(from: Fromtime!)
            dateFormatter01.dateFormat = "h:mm a"
            
            let Totime = Dictdata?.value(forKey: "end_time") as? String
            let dateFormatter02 = DateFormatter()
            dateFormatter02.timeZone = TimeZone.current
            dateFormatter02.dateFormat = "HH:mm:ss"
            let Todate1 = dateFormatter02.date(from: Totime!)
            dateFormatter02.dateFormat = "h:mm a"
            
            let dateFormatter12 = DateFormatter()
            dateFormatter12.timeZone = TimeZone.current
            dateFormatter12.dateFormat = "h:mm a"
            let calendar = Calendar.current
            let From1 = calendar.dateComponents([.hour, .minute], from: Fromdate!)
            let To1 = calendar.dateComponents([.hour, .minute], from: Todate1!)
            let CostBasedOnTime = calendar.dateComponents([.minute], from: From1, to: To1).minute!
            
            let Date = Dictdata?.value(forKey: "date") as? String
            cell.lblDate.text = "SESSION_DATE".localize + Date!
            
            let DictLoc = Dictdata?.value(forKey: "location") as? NSMutableDictionary
            let strLoc = DictLoc?.value(forKey: "name") as? String
            cell.lblLoc.text = "SESSION_LOC".localize + strLoc!
            
            var type = Dictdata?.value(forKey: "type") as? String
            
            
            if(type == "discovery_enrollment")
            {
                type = "Discovery Enrollment"
            }
            else if(type == "discovery_lesson")
            {
                type = "Discovery Lesson"
            }
            else if(type == "cruiser")
            {
                type = "Cruiser"
            }
            else if(type == "explorer")
            {
                type = "Explorer"
            }
            else if(type == "sport")
            {
                type = "Sport"
            }
            else if(type == "pro")
            {
                type = "Pro"
            }
            else if(type == "certificate")
            {
                type = "Certificate"
            }
            else if(type == "normal")
            {
                type = "Normal Session"
            }
            else
            {
                type = "Session"
            }
            
            cell.lblType.text = "SESSION_TYPE".localize + type!
            
            if(type == "Normal Session")
            {
                let Cost = Dictdata?.value(forKey: "cost") as? String
                cell.lblCost.text = "SESSION_COST".localize + Cost!
                //cell.lblCost.text = "SESSION_COST".localize + String(CostBasedOnTime)
            }
            else
            {
                let Cost = Dictdata?.value(forKey: "cost") as? String
                cell.lblCost.text = "SESSION_COST".localize + Cost!
            }
            
            cell.lblRatingTitle.text = "RATING".localize
            //cell.lblSubmit.text = "CLICK_TO_SUBMIT".localize
            
            cell.CellView.addCornerRadius(10)
            cell.CellView.layer.borderColor = #colorLiteral(red: 0.2784313725, green: 0.4549019608, blue: 0.5921568627, alpha: 1)
            cell.CellView.layer.borderWidth = 2
            
            //            let DateForCal = Date! //+ "T04:00:00+0000"
            //            let dateFormatter = DateFormatter()
            //            dateFormatter.timeZone = TimeZone.current
            //            //dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
            //            dateFormatter.dateFormat = "yyyy-MM-dd"//"yyyy-MM-dd'T'HH:mm:ssZ"
            //            let date = dateFormatter.date(from:DateForCal)!
            //
            //             AppDelegate.shared().AllowDateSelecetionInCalendar = true
            //
            //            self.arrSelectedDates.append(DateForCal)
            //            print(self.arrSelectedDates)
            //
            //            for alldate in self.arrSelectedDates
            //            {
            //                if(self.arrTempDates.contains(alldate)){
            //
            //                }
            //                else{
            //                    self.arrTempDates.append(alldate)
            //                    self.calenderView.selectDate(date)
            //                }
            //            }
            
            
            let resultNew = Dictdata?.value(forKey: "rating") as? [[String:Any]]
            if(resultNew?.count != 0)
            {
                let RatingStar = resultNew![0]["rating"] as! String
                cell.cosmosViewFull.isHidden = false
                cell.cosmosViewFull.rating = Double(RatingStar)!
                cell.lblSubmit.isHidden = true
                cell.lblSubmitWidth.constant = 0
            }
            else
            {
                cell.cosmosViewFull.isHidden = true
                cell.lblSubmit.isHidden = false
                cell.lblSubmitWidth.constant = 180
            }
            self.view.updateConstraintsIfNeeded()
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(self.segmentedControl.selectedIndex == 0)
        {
            //            let Dictdata = self.arrSessions[indexPath.row] as? NSMutableDictionary
            //            let SessionID = Dictdata?.value(forKey: "id") as? Int
            //            
            //            let nextNavVc = self.storyboard!.instantiateViewController(withIdentifier: "Chat_VC") as! Chat_VC
            //            nextNavVc.StrID = SessionID
            //            navigationController?.pushViewController(nextNavVc, animated: true)
        }
        else
        {
            let Dictdata = self.arrSessions[indexPath.row] as? NSMutableDictionary
            let status = Dictdata?.value(forKey: "status") as? Int
            if(status == 0)
            {
                displayAlert(APPNAME, andMessage:"INST_NOT_PROVIDE_COMNT".localize)
            }
            else
            {
                let resultNew = Dictdata?.value(forKey: "rating") as? [[String:Any]]
                if(resultNew?.count != 0)
                {
                    print("Rating Provided By Cust Already.")
                }
                else
                {
                    let Status = Dictdata?.value(forKey: "status") as? Int
                    if(Status == 3){
                        displayAlert(APPNAME, andMessage:"Rating Not Allowed on Cancelled Sesstion")
                    }
                    else{
                        let ID = Dictdata?.value(forKey: "id") as? Int
                        let popupVC = storyboard?.instantiateViewController(withIdentifier: "RatingPopup_VC") as! RatingPopup_VC
                        popupVC.StrSessionID = ID
                        view.addSubview(popupVC.view)
                        addChild(popupVC)
                    }
                    
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if(self.segmentedControl.selectedIndex == 0)
        {
            return 125
        }
        else
        {
            return 125
        }
    }
    
    //MARK: - SetAvailableDays Method
    func SetAvailableDays(){
        
        AppDelegate.shared().AllowDateSelecetionInCalendar = true
        
        if(arrTempDates.count != 0)
        {
            for availableDate in arrTempDates
            {
                let DateForCal = availableDate //+ "T04:00:00+0000"
                let dateFormatter = DateFormatter()
                dateFormatter.timeZone = TimeZone.current//TimeZone(abbreviation: "UTC")!
                dateFormatter.dateFormat = "yyyy-MM-dd"//"yyyy-MM-dd'T'HH:mm:ssZ"
                let date = dateFormatter.date(from:DateForCal)!
                
                self.calenderView.selectDate(date)
            }
        }
        else
        {
            print("All Dates Available for this Month.")
        }
        
        AppDelegate.shared().AllowDateSelecetionInCalendar = false
    }
    
    //MARK: - RemoveSelectedDates Method
    func RemoveSelectedDates(){
        
        AppDelegate.shared().AllowDateSelecetionInCalendar = true
        
        if(arrTempDates.count != 0)
        {
            for availableDate in arrTempDates
            {
                let DateForCal = availableDate //+ "T04:00:00+0000"
                let dateFormatter = DateFormatter()
                dateFormatter.timeZone = TimeZone.current//TimeZone(abbreviation: "UTC")!
                dateFormatter.dateFormat = "yyyy-MM-dd"//"yyyy-MM-dd'T'HH:mm:ssZ"
                let date = dateFormatter.date(from:DateForCal)!
                
                self.calenderView.selectDate(date)
            }
        }
        else
        {
            print("All Dates Removed for this Month.")
        }
    }
    
    
    //MARK: - API Calls
    func GetUpcoming_Session_API() {
        
        let url = API.BASE_URL + API.GET_UPCOMING_SESSION
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
                            
                            self.RemoveSelectedDates()
                            self.arrCalSelectedDates = []
                            self.arrTempDates = []
                            
                            print(dict!)
                            self.arrSessions = (dict?.value(forKey: "data") as? NSMutableArray)!
                            
                            if(self.arrSessions.count == 0)
                            {
                                self.viewSessionError.isHidden = false
                                self.btnBookSession.isHidden = false
                                self.lblSessionError.isHidden = false
                                self.viewError.isHidden = false
                                self.tableViewHeight.constant = 0
                                self.viewErrorHeight.constant = 90
                                self.viewSessionErrorHeight.constant = 40
                                
                                self.tableView.reloadData()
                                self.tableViewHeight.constant = 0
                            }
                            else
                            {
                                self.viewSessionError.isHidden = true
                                self.btnBookSession.isHidden = true
                                self.lblSessionError.isHidden = true
                                self.viewError.isHidden = true
                                self.viewErrorHeight.constant = 0
                                self.viewSessionErrorHeight.constant = 0
                                
                                for dict in self.arrSessions
                                {
                                    let DictData = dict as? NSMutableDictionary
                                    let date = DictData!.value(forKey: "date") as? String
                                    print(date!)
                                    
                                    self.arrCalSelectedDates.append(date!)
                                    
                                    for alldate in self.arrCalSelectedDates
                                    {
                                        if(self.arrTempDates.contains(alldate)){
                                            
                                        }
                                        else{
                                            self.arrTempDates.append(alldate)
                                        }
                                    }
                                }
                                print(self.arrTempDates)
                                self.SetAvailableDays()
                                
                                self.tableView.reloadData()
                                self.tableViewHeight.constant = CGFloat(self.arrSessions.count * 125)
                            }
                            self.view.updateConstraintsIfNeeded()
                            self.GetUser_API()
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
    
    func GetPast_Session_API() {
        
        let url = API.BASE_URL + API.GET_PAST_SESSION
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
                            self.RemoveSelectedDates()
                            self.arrCalSelectedDates = []
                            self.arrTempDates = []
                            
                            print(dict!)
                            self.arrSessions = (dict?.value(forKey: "data") as? NSMutableArray)!
                            
                            if(self.arrSessions.count == 0)
                            {
                                self.viewSessionError.isHidden = false
                                self.btnBookSession.isHidden = true
                                self.lblSessionError.isHidden = false
                                self.viewError.isHidden = false
                                self.tableViewHeight.constant = 0
                                self.viewErrorHeight.constant = 90
                                self.viewSessionErrorHeight.constant = 40
                                
                                self.tableView.reloadData()
                                self.tableViewHeight.constant = 0
                            }
                            else
                            {
                                self.viewSessionError.isHidden = true
                                self.btnBookSession.isHidden = true
                                self.lblSessionError.isHidden = true
                                self.viewError.isHidden = true
                                self.viewErrorHeight.constant = 0
                                self.viewSessionErrorHeight.constant = 0
                                
                                for dict in self.arrSessions
                                {
                                    let DictData = dict as? NSMutableDictionary
                                    let date = DictData!.value(forKey: "date") as? String
                                    print(date!)
                                    
                                    self.arrCalSelectedDates.append(date!)
                                    
                                    for alldate in self.arrCalSelectedDates
                                    {
                                        if(self.arrTempDates.contains(alldate)){
                                            
                                        }
                                        else{
                                            self.arrTempDates.append(alldate)
                                        }
                                    }
                                }
                                print(self.arrTempDates)
                                self.SetAvailableDays()
                                
                                self.tableView.reloadData()
                                self.tableViewHeight.constant = CGFloat(self.arrSessions.count * 125)
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
    
    func GetUser_API() {
        
        let url = API.BASE_URL + API.CURRENT_USER_PROFIE
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
            displayAlert(APPNAME, andMessage: "ERROR_NETWORK".localize)
        }
    }
    
    func CancelSession(Session:String) {
        
        let url = API.BASE_URL + API.CANCEL_SESSION
        
        let param : [String:String] = ["session" : Session]
        
        let header = ["Content-Type":"application/x-www-form-urlencoded",
                      "Authorization": "Bearer \(AppPrefs.shared.getUserId())"]
        
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
                            let dictData = dict?.value(forKey: "data") as? NSMutableDictionary
                            let Check_Flag = dictData?.value(forKey: "success") as? Bool
                            
                            if(Check_Flag == true)
                            {
                                displayAlertWithOneOptionAndAction(APPNAME, andMessage: "Your Session is Cancelled Sucessfully", no: {
                                    
                                    self.RemoveDate()
                                    self.GetUpcoming_Session_API()
                                    
                                })
                            }
                            else
                            {
                                displayAlert(APPNAME, andMessage: dictData?.value(forKey: "message") as? String ?? "Contact Your Affilate Directly To Cancel your Session.")
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
    
    func GetLocationDetails(Session:String) {
        
        let url = API.BASE_URL + API.GET_LOCATION_DETAILS_OF_SESSION
        
        let param : [String:String] = ["id" : Session]
        
        let header = ["Content-Type":"application/x-www-form-urlencoded",
                      "Authorization": "Bearer \(AppPrefs.shared.getUserId())"]
        
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
                            let dictData = dict?.value(forKey: "data") as? NSMutableDictionary
                            let dictLocation = dictData?.value(forKey: "location") as? NSMutableDictionary
                            print(dictLocation!)
                            
                            if(dictLocation!.count != 0){
                                
                                let nextNavVc = self.storyboard!.instantiateViewController(withIdentifier: "Session_Inner_VC") as! Session_Inner_VC
                                nextNavVc.DictData = dictLocation!
                                nextNavVc.DictBookedSessiondata = dictData!
                                nextNavVc.isFromReschedule = true
                                self.navigationController?.pushViewController(nextNavVc, animated: true)
                                
                            }
                            else{
                                displayAlert(APPNAME, andMessage: "please try after some time.")
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
