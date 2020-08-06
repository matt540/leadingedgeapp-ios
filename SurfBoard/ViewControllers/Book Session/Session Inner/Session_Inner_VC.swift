//
//  Session_Inner_VC.swift
//  SurfBoard
//
//  Created by esparkbiz on 12/6/19.
//  Copyright © 2019 esparkbiz. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage

class Session_Inner_VC: BaseViewController ,UITableViewDataSource, UITableViewDelegate, CalendarViewDataSource, CalendarViewDelegate , DescbtnAction{
    
    //Reschedule Session
    var DictBookedSessiondata:NSMutableDictionary = [:]
    var isFromReschedule:Bool = false
    //Reschedule Session Comp
    
    var DictData:NSMutableDictionary = [:]
    var DictSelectedSession:NSMutableDictionary = [:]
    var arrSession:NSMutableArray = []
    var arrInstructor:NSMutableArray = []
    var arrFilterdate:[String] = []
    var arrAvailableDates:[String] = []
    var arrSelectedDates:[String] = []
    var arrTableData:NSMutableArray = []
    var arrSessionData:NSMutableArray = []
    var arrselectedArray:NSMutableArray = []
    
    var DateFlag:Bool = true
    var LocationID:Int!
    var SelectedDatesCounts:Int = 0
    var Counts:Int = 0
    var DeSelectCounts:Int = 0
    var LocID:String!
    var TimeID:String!
    var Amount:String!
    var Favflag:Int!
    var Sesstion_Type:String!
    var SelectedDay:String!
    var SelectedMonth:String!
    var SelectedYear:String!
    
    @IBOutlet var calenderView: CalendarView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var tableViewHeight: NSLayoutConstraint!
    @IBOutlet var tableViewSession: UITableView!
    @IBOutlet var tableViewSessionHeight: NSLayoutConstraint!
    @IBOutlet var imgSession: UIImageView!
    @IBOutlet var imgSessionViewHeight: NSLayoutConstraint!
    @IBOutlet var lblSessionDesc: UILabel!
    @IBOutlet var lblInstructorCount: UILabel!
    @IBOutlet var lblFoilsCount: UILabel!
    @IBOutlet var lblCallAffilate: UILabel!
    
    @IBOutlet var lblSelectAvalSession: UILabel!
    @IBOutlet var lblSelectAvailableDate: UILabel!
    
    
    @IBOutlet var btnCallAffilate: UIButton!
    
    @IBOutlet var btnAddToFav: UIButton!
    @IBOutlet var lblAddToFav: UILabel!
    @IBOutlet var lblSessionInfo: UILabel!
    @IBOutlet var lblSessionAmount: UILabel!
    
    @IBOutlet var viewNote: UIView!
    @IBOutlet var viewNote2: UIView!
    @IBOutlet var viewCircleBlue: UIView!
    
    @IBOutlet var lblCurentLevel: UILabel!
    @IBOutlet var viewCurrentLevel: UIView!
    
    @IBOutlet var lblDuration: UILabel!
    @IBOutlet var viewDuration: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.separatorStyle = .none
        tableViewSession.separatorStyle = .none
        tableViewSession.rowHeight = UITableView.automaticDimension
        tableViewSession.estimatedRowHeight = CGFloat(80.0)
        
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePicker.Mode.date
        datePickerView.minimumDate = Date()
        datePickerView.addTarget(self, action: #selector(self.datePickerValueChanged), for: UIControl.Event.valueChanged)
        
        print(DictData)
        self.tableViewHeight.constant = 0
        self.view.updateConstraintsIfNeeded()
        //self.lblAddToFav.text = "ADD TO FAVORITE"
        
        self.navigationController?.isNavigationBarHidden = false
        AppDelegate.shared().setupNavigationBar()
        setLeftBarBackItem()
        setTranspertNavigation()
        self.title = DictData.value(forKey: "name") as? String ?? ""
        
        self.imgSessionViewHeight.constant = UIScreen.main.bounds.size.width/1.5
        
        //Calendar
        CalendarView.Style.cellShape                = .round//.bevel(8.0)
        CalendarView.Style.cellColorDefault         = UIColor.clear
        CalendarView.Style.cellColorToday           = UIColor.black
        CalendarView.Style.cellSelectedBorderColor  = #colorLiteral(red: 0.2784313725, green: 0.4549019608, blue: 0.5921568627, alpha: 1)
        CalendarView.Style.cellSelectedTextColor    = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        CalendarView.Style.cellSelectedColor        = #colorLiteral(red: 0.2784313725, green: 0.4549019608, blue: 0.5921568627, alpha: 1)
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
        
        CalendarView.Style.hideCellsOutsideDateRange = true
        CalendarView.Style.changeCellColorOutsideRange = false
        
        calenderView.dataSource = self
        calenderView.delegate = self
        calenderView.isUserInteractionEnabled = true
        calenderView.direction = .horizontal
        calenderView.multipleSelectionEnable = true
        calenderView.marksWeekends = false
        calenderView.backgroundColor = #colorLiteral(red: 0.7294117647, green: 0.8901960784, blue: 0.9764705882, alpha: 1)
        //calendar
        
        self.viewNote.addCornerRadius(10)
        self.viewNote.layer.borderColor = #colorLiteral(red: 0.2784313725, green: 0.4549019608, blue: 0.5921568627, alpha: 1)
        self.viewNote.layer.borderWidth = 2
        
        self.viewNote2.addCornerRadius(10)
        self.viewNote2.layer.borderColor = #colorLiteral(red: 0.2784313725, green: 0.4549019608, blue: 0.5921568627, alpha: 1)
        self.viewNote2.layer.borderWidth = 2
        
        self.viewDuration.addCornerRadius(10)
        self.viewCurrentLevel.addCornerRadius(10)
        
        self.calenderView.addCornerRadius(10)
        self.viewCircleBlue.addCornerRadius(self.viewCircleBlue.frame.size.height/2)
        
        self.SetupData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if(self.isFromReschedule == true){
            self.lblSelectAvalSession.text = "RESCHEDULE FROM AVAILABLE SESSIONS"
            self.lblSelectAvailableDate.text = "RESCHEDULE FROM AVAILABLE DATES"
        }
        
        if(self.Sesstion_Type == "normal")
        {
            self.CHECK_MEMBERSHIP()
        }
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        let today = Date()
        
        #if KDCALENDAR_EVENT_MANAGER_ENABLED
        self.calenderView.loadEvents() { error in
            if error != nil {
            }
        }
        #endif
        
        self.calenderView.setDisplayDate(today)
        
        
    }
    
    //MARK: - attributedText Method
    func attributedText(withString string: String, boldString: String, font: UIFont) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: string,
                                                         attributes: [NSAttributedString.Key.font: font])
        let boldFontAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: font.pointSize)]
        let range = (string as NSString).range(of: boldString)
        attributedString.addAttributes(boldFontAttribute, range: range)
        return attributedString
    }
    
    //MARK: - datePickerValueChanged Method
    @objc func datePickerValueChanged(sender:UIDatePicker) {
        
    }
    
       //MARK: - btnCallAffilateAction Method
    @IBAction func btnCallAffilateAction(_ sender: Any) {
        
        let Number = DictData.value(forKey: "telephone") as? String ?? ""
        self.dialNumber(number: Number)
        
    }
    
    func dialNumber(number : String) {
        
        if let url = URL(string: "tel://\(number)"),
            UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler:nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        } else {
            displayAlert(APPNAME, andMessage: "Can't call right now.")
        }
    }
    
    
    //MARK: - getDayOfWeek Method
    func getDayOfWeek(_ today:String) -> Int? {
        let formatter  = DateFormatter()
        formatter.timeZone = TimeZone.current//TimeZone(abbreviation: "UTC")!
        formatter.dateFormat = "MM/dd/yyyy"
        guard let todayDate = formatter.date(from: today) else { return nil }
        let myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.weekday, from: todayDate)
        return weekDay
    }
    
    //MARK: - datesOfCurrentMonth Method
    func datesOfCurrentMonth(with weekday : Int) -> [String] {
        let calendar = Calendar.current
        
        let Date = self.calenderView.displayDate
        
        var components = calendar.dateComponents([.year, .month, .weekdayOrdinal], from: Date!)
        components.weekday = weekday
        var result = [String]()
        
        for ordinal in 1..<6 { // maximum 5 occurrences
            components.weekdayOrdinal = ordinal
            let date = calendar.date(from: components)!
            if calendar.component(.month, from: date) != components.month! { break }
            
            let dateFormatter : DateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.dateFormat = "MM/dd/yyyy"
            let dateString = dateFormatter.string(from: calendar.date(from: components)!)
            print(dateString)
            
            result.append(dateString)
        }
        return result
    }
    
 
    //MARK: - SetupData Method
    func SetupData() {
        
        if(DictData.count != 0)
        {
            self.LocationID = DictData["id"] as? Int
            self.LocID = String(self.LocationID)
            
//            self.Favflag = DictData.value(forKey: "favorite_location") as? Int
//            if(self.Favflag == 0)
//            {
//                self.btnAddToFav.isSelected = true
//                self.SetupfavBtn()
//            }
//            else
//            {
//                self.btnAddToFav.isSelected = false
//                self.SetupfavBtn()
//            }
            
            self.arrSession = DictData.value(forKey: "sessions") as? NSMutableArray ?? []
            if(self.arrSession.count != 0)
            {
            }
            else
            {
            }
            
            self.arrInstructor = (DictData.value(forKey: "instructor") as? NSMutableArray)!
            
            self.lblSessionDesc.text = DictData.value(forKey: "description") as? String
            let InstructorCount:Int = (DictData.value(forKey: "instructor_count") as? Int)!
            self.lblInstructorCount.text = String(InstructorCount)
            
            let Foils = DictData.value(forKey: "foils") as? Int ?? 0
            self.lblFoilsCount.text = String(Foils)
            
            let imageURL = DictData.value(forKey: "image") as? String
            self.imgSession?.sd_setImage(with: URL(string: imageURL!), placeholderImage: UIImage(named: "Hotel.png"), options: [.continueInBackground,.lowPriority], completed: {(image,error,cacheType,url) in
                
                if error == nil
                {
                    self.imgSession?.image = image
                }
                else
                {
                    self.imgSession?.image =  UIImage(named: "Hotel.png")
                }
            })
        }
        else
        {
            displayAlert(APPNAME, andMessage: MSG.SOMETHINGWRONG)
            self.navigationController?.popViewController(animated: true)
        }
        
        let today = Date()
        let formatingDate = getFormattedDate(date: today, format: "yyyy-MM-dd")
        let fullNameArr1 = formatingDate.components(separatedBy: "-")
        self.SelectedMonth = fullNameArr1[1]
        self.SelectedYear = fullNameArr1[0]
        
        self.GET_HOLIDAY_API()
        
    }
    
    //MARK: - SetupCalendarDates Method
    func SetupCalendarDates(){
        
        if(arrFilterdate.count != 0)
        {
            for availableDate in arrFilterdate
            {
                let inputFormatter = DateFormatter()
                inputFormatter.timeZone = TimeZone.current//TimeZone(abbreviation: "UTC")!
                inputFormatter.dateFormat = "MM/dd/yyyy"
                let showDate = inputFormatter.date(from: availableDate)
                inputFormatter.dateFormat = "yyyy-MM-dd"
                let resultString = inputFormatter.string(from: showDate!)
                
                let DateForCal = resultString //+ "T04:00:00+0000"
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
        
        if(arrSelectedDates.count != 0)
        {
            for availableDate in arrSelectedDates
            {
                
                let inputFormatter = DateFormatter()
                inputFormatter.timeZone = TimeZone.current//TimeZone(abbreviation: "UTC")!
                inputFormatter.dateFormat = "MM/dd/yyyy"
                let showDate = inputFormatter.date(from: availableDate)
                inputFormatter.dateFormat = "yyyy-MM-dd"
                let resultString = inputFormatter.string(from: showDate!)
                
                let DateForCal = resultString //+ "T04:00:00+0000"
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
    }
    
    //MARK: - SetAvailableDays Method
    func SetAvailableDays(){
        
        AppDelegate.shared().AllowDateSelecetionInCalendar = true
        
        if(arrAvailableDates.count != 0)
        {
            for availableDate in arrAvailableDates
            {
                
                let inputFormatter = DateFormatter()
                inputFormatter.timeZone = TimeZone.current//TimeZone(abbreviation: "UTC")!
                inputFormatter.dateFormat = "MM/dd/yyyy"
                let showDate = inputFormatter.date(from: availableDate)
                inputFormatter.dateFormat = "yyyy-MM-dd"
                let resultString = inputFormatter.string(from: showDate!)
                
                let DateForCal = resultString //+ "T04:00:00+0000"
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
    
    //MARK: - getFormattedDate Method
    func getFormattedDate(date: Date, format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.timeZone = TimeZone.current//TimeZone(abbreviation: "UTC")!
        dateformat.dateFormat = format
        return dateformat.string(from: date)
    }
    
    //MARK: - btnAddToFavAction Method
    @IBAction func btnAddToFavAction(_ sender: Any) {
        //AddToFav_API()
    }
    
    //MARK: - SetupfavBtn Method
//    func SetupfavBtn() {
//
//        if(btnAddToFav.isSelected == true)
//        {
//            btnAddToFav.isSelected = false
//            self.lblAddToFav.text = "ADD TO FAVORITE"
//        }
//        else
//        {
//            btnAddToFav.isSelected = true
//            self.lblAddToFav.text = "ADDED AS FAVORITE"
//        }
//    }
    
    //MARK: -  Protocol Methods
    func btnDescAction(_ sender: Any?) {
        
        let cell = sender as! SessionInnerCell
        let indexpath = self.tableViewSession.indexPath(for: cell)
        let dict = self.arrSessionData[(indexpath?.row)!] as? NSMutableDictionary
        let StringUrl = dict!.value(forKey: "description") as! String
        displayAlert("Description", andMessage: StringUrl)
        
    }
    
    //MARK: -  TableView DataSource - Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView == self.tableViewSession)
        {
            return self.arrSessionData.count
        }
        else
        {
            return self.arrTableData.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(tableView == self.tableViewSession)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SessionInnerCell") as! SessionInnerCell
            cell.selectionStyle = .none
            cell.delegate = self
            
            let Dict = self.arrSessionData[indexPath.row] as? NSMutableDictionary
            
            var Type = Dict!["type"] as? String
            if(Type == "cruiser" || Type == "explorer" || Type == "sport" || Type == "pro" || Type == "normal" || Type == "certificate")
            {
                
                if(Type == "cruiser"){
                    Type = "Cruiser"
                }
                else if(Type == "explorer"){
                    Type = "Explorer"
                }
                else if(Type == "sport"){
                    Type = "Sport"
                }
                else if(Type == "pro"){
                    Type = "Pro"
                }
                else if(Type == "normal"){
                    Type = "Normal"
                }
                else if(Type == "certificate"){
                    Type = "Certificate"
                }
                
                cell.lblSessionTitle.text =  "Session Type : " + Type!
                cell.lblSessionTime.text = Dict!["description"] as? String
                cell.btnDesc.isHidden = true
                
            }
                
            else{
                
                cell.lblSessionTitle.text = Dict?.value(forKey: "title") as? String
                let Time = Dict?.value(forKey: "duration") as? String
                cell.lblSessionTime.text = "Time : \(Time!) Minutes"
                
            }
            
            if(self.Sesstion_Type == "normal")
            {
                let CellAmount = Dict?.value(forKey: "price") as? String
                cell.lblSessionAmount.text = "Session Cost : $" + CellAmount! + " Per Minute"
            }
            else
            {
                let CellAmount = Dict?.value(forKey: "price") as? String
                cell.lblSessionAmount.text = "Session Cost : $" + CellAmount!
            }
            
            let intId = String(Int(Dict?.object(forKey: "id") as! Int))
            if self.arrselectedArray.contains(intId)
            {
                cell.imgCheck.image = UIImage(named: "Selected_Circle")
            }
            else
            {
                cell.imgCheck.image = UIImage(named: "Blank_Circle")
            }
            
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Session_InnerCell") as! Session_InnerCell
            cell.selectionStyle = .none
            
            let Dict = self.arrTableData[indexPath.row] as? NSMutableDictionary
            
            let Fromtime = Dict?.value(forKey: "from_time") as? String
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone.current//TimeZone(abbreviation: "UTC")!
            dateFormatter.dateFormat = "HH:mm:ss"
            let date = dateFormatter.date(from: Fromtime!)
            dateFormatter.dateFormat = "h:mm a"
            let From = dateFormatter.string(from: date!)
            
            let Totime = Dict?.value(forKey: "to_time") as? String
            let dateFormatter1 = DateFormatter()
            dateFormatter1.timeZone = TimeZone.current//TimeZone(abbreviation: "UTC")!
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
            
            cell.lblDescCell.text = From + " - " + To
            cell.lblAmountCell.text = Day!
            cell.imgCell.image = UIImage(named: "imgBook.png")
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(tableView == self.tableViewSession)
        {
            let Dict = self.arrSessionData[indexPath.row] as? NSMutableDictionary
            let intId = String(Int(Dict!.object(forKey: "id") as! Int))
            
            if(self.arrselectedArray.count > 0)
            {
                self.arrselectedArray = []
                self.arrselectedArray.add(intId)
            }
            else
            {
                self.arrselectedArray.add(intId)
            }
            
            self.tableViewSession.reloadData()
            self.DictSelectedSession = Dict!
            print(self.DictSelectedSession)
            
            let Type = Dict!["type"] as? String
            if(Type == "discovery_lesson"){
                
                let Time = Dict?.value(forKey: "duration") as? String
                self.lblDuration.text = "\(Time!) Minutes"
            }
        }
        else
        {
            let Dict = self.arrTableData[indexPath.row] as? NSMutableDictionary
            let id = Dict!["id"] as? Int ?? 0
            self.TimeID = String(id)
            
            if(self.DateFlag == true)
            {
                self.CHECK_BOOKING()
            }
            else
            {
                print(self.DateFlag)
                displayAlert(APPNAME, andMessage: "Date is not Available. \n Please Select Another Date.")
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(tableView == self.tableViewSession)
        {
            return UITableView.automaticDimension
        }
        else
        {
            return 85
        }
        
    }
    
    // MARK: - KDCalendarDataSource
    func startDate() -> Date {
        
        let extractedExpr = DateComponents()
        var dateComponents = extractedExpr
        dateComponents.month = -1
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
    
    func CheckDateFlag(SelectedDate:String) -> Bool {
        
        var flag:Bool = false
        for TempDate in self.arrFilterdate
        {
            if(TempDate == SelectedDate)
            {
                flag = true
                break
            }
            else{
                flag = false
                print("Date not Holiday")
            }
        }
        
        return flag
    }
    
    //MARK: - KDCalendarDelegate
    func calendar(_ calendar: CalendarView, didSelectDate date : Date, withEvents events: [CalendarEvent]) {
        
        print("Did Select: \(date) with \(events.count) events")

        //Remove User Clicked Date's Indications as Blue color
        self.Counts += 1
     
        if(self.Counts > self.arrFilterdate.count){
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone.current//TimeZone(abbreviation: "UTC")!
            dateFormatter.dateFormat = "yyyy-MM-dd"//"yyyy-MM-dd'T'HH:mm:ssZ"
            let newTimeString = dateFormatter.string(from: date)
            
            dateFormatter.dateFormat = "yyyy-MM-dd"//"yyyy-MM-dd'T'HH:mm:ssZ"
            let date = dateFormatter.date(from:newTimeString)!
            self.calenderView.selectDate(date)
        }
    }
    
    func calendar(_ calendar: CalendarView, didDeselectDate date: Date) {
        
    }
    
    func calendar(_ calendar: CalendarView, didScrollToMonth date : Date) {
        
    }
    
    
    
    func calendar(_ calendar: CalendarView, didLongPressDate date : Date, withEvents events: [CalendarEvent]?) {
        
        let dateformatter1 = DateFormatter()
        dateformatter1.timeZone = TimeZone.current//TimeZone(abbreviation: "UTC")!
        dateformatter1.dateFormat = "MM/dd/yyyy"
        let dateString1 = dateformatter1.string(from: date)
        let UserDate = dateString1
        print(UserDate)
        
        var status = false
        for strDate in arrAvailableDates
        {
            if(strDate == UserDate)
            {
                status = true
                break
            }
            else
            {
                status = false
            }
        }
        
        if(status == false)
        {
            displayAlert(APPNAME, andMessage: "Date is not Available. \n Please Select Another Date.")
        }
        else
        {
            let diff = Date.daysBetween(start: Date(), end: date)
            if (diff < 0) {
                displayAlert(APPNAME, andMessage: "Date is not Available. \n Please Select Another Date.")
            }
            else
            {
                if(self.Sesstion_Type == "discovery_lesson")
                {
                    if(self.DictSelectedSession.count != 0)
                    {
                        
                        let popupVC = storyboard?.instantiateViewController(withIdentifier: "BookSessionTimePopup_VC") as! BookSessionTimePopup_VC
                        //Reschedule Session
                        if(self.isFromReschedule == true){
                            
                            popupVC.isFromReschedule = true
                            popupVC.DictBookedSessiondata = self.DictBookedSessiondata
                        }
                        //Reschedule Session Comp
                        popupVC.SelectedDate = UserDate
                        popupVC.LocID = self.LocID
                        popupVC.Sesstion_Type = self.Sesstion_Type
                        popupVC.DictData = self.DictSelectedSession
                        
                        view.addSubview(popupVC.view)
                        addChild(popupVC)
                    }
                    else
                    {
                        displayAlert(APPNAME, andMessage: "Please Select Any Session From Available Session")
                    }
                    
                }
                
                if(self.Sesstion_Type == "cruiser" || self.Sesstion_Type == "explorer" || self.Sesstion_Type == "sport" || self.Sesstion_Type == "pro")
                {
                    if(self.DictSelectedSession.count != 0)
                    {
                        let popupVC = storyboard?.instantiateViewController(withIdentifier: "BookSessionTimePopup_VC") as! BookSessionTimePopup_VC
                        //Reschedule Session
                        if(self.isFromReschedule == true){
                            
                            popupVC.isFromReschedule = true
                            popupVC.DictBookedSessiondata = self.DictBookedSessiondata
                        }
                        //Reschedule Session Comp
                        popupVC.SelectedDate = UserDate
                        popupVC.LocID = self.LocID
                        popupVC.Sesstion_Type = self.Sesstion_Type
                        popupVC.DictData = self.DictSelectedSession
                        
                        view.addSubview(popupVC.view)
                        addChild(popupVC)
                    }
                    else
                    {
                        displayAlert(APPNAME, andMessage: "Please Select Any Session From Available Session")
                    }
                }
                
                if(self.Sesstion_Type == "normal")
                {
                    if(self.DictSelectedSession.count != 0)
                    {
                        let popupVC = storyboard?.instantiateViewController(withIdentifier: "BookSessionTimePopup_VC") as! BookSessionTimePopup_VC
                        //Reschedule Session
                        if(self.isFromReschedule == true){
                            
                            popupVC.isFromReschedule = true
                            popupVC.DictBookedSessiondata = self.DictBookedSessiondata
                        }
                        //Reschedule Session Comp
                        popupVC.SelectedDate = UserDate
                        popupVC.LocID = self.LocID
                        popupVC.Sesstion_Type = self.Sesstion_Type
                        popupVC.DictData = self.DictSelectedSession
                        
                        view.addSubview(popupVC.view)
                        addChild(popupVC)
                    }
                    else
                    {
                        displayAlert(APPNAME, andMessage: "Please Select Any Session From Available Session")
                    }
                }
                
                if(self.Sesstion_Type == "certificate")
                {
                    if(self.DictSelectedSession.count != 0)
                    {
                        let popupVC = storyboard?.instantiateViewController(withIdentifier: "BookSessionTimePopup_VC") as! BookSessionTimePopup_VC
                        //Reschedule Session
                        if(self.isFromReschedule == true){
                            
                            popupVC.isFromReschedule = true
                            popupVC.DictBookedSessiondata = self.DictBookedSessiondata
                        }
                        //Reschedule Session Comp
                        popupVC.SelectedDate = UserDate
                        popupVC.LocID = self.LocID
                        popupVC.Sesstion_Type = self.Sesstion_Type
                        popupVC.DictData = self.DictSelectedSession
                        
                        view.addSubview(popupVC.view)
                        addChild(popupVC)
                    }
                    else
                    {
                        displayAlert(APPNAME, andMessage: "Please Select Any Session From Available Session")
                    }
                }
            }
        }
    }
    
    //MARK: -  calendar btn Actions
    @IBAction func onValueChange(_ picker : UIDatePicker) {
        self.calenderView.setDisplayDate(picker.date, animated: true)
    }
    
    @IBAction func goToPreviousMonth(_ sender: Any) {
        self.calenderView.goToPreviousMonth()
        let displayDate = self.calenderView.displayDate
        
        let EndDateNext = displayDate?.endOfMonth()
        let startDateNext = displayDate?.startOfMonth()
        let datesBetweenArray = Date.dates(from: startDateNext!, to: EndDateNext!)
        
        self.arrFilterdate = []
        for day in datesBetweenArray{
            
            let dateFormatter : DateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.dateFormat = "MM/dd/yyyy"
            let dateString = dateFormatter.string(from: day)
            self.arrFilterdate.append(dateString)
        }
        print(self.arrFilterdate)
        
        let formatingDate = getFormattedDate(date: displayDate!, format: "yyyy-MM-dd")
        let fullNameArr1 = formatingDate.components(separatedBy: "-")
        self.SelectedMonth = fullNameArr1[1]
        self.SelectedYear = fullNameArr1[0]

        self.RemoveSelectedDates()
        GET_HOLIDAY_MONTHLY_API()
    }
    
    @IBAction func goToNextMonth(_ sender: Any) {
        self.calenderView.goToNextMonth()
        let displayDate = self.calenderView.displayDate
        
        let EndDateNext = displayDate?.endOfMonth()
        let startDateNext = displayDate?.startOfMonth()
        let datesBetweenArray = Date.dates(from: startDateNext!, to: EndDateNext!)
        
        self.arrFilterdate = []
        for day in datesBetweenArray{
            
            let dateFormatter : DateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.dateFormat = "MM/dd/yyyy"
            let dateString = dateFormatter.string(from: day)
            self.arrFilterdate.append(dateString)
        }
        print(self.arrFilterdate)
        
        let formatingDate = getFormattedDate(date: displayDate!, format: "yyyy-MM-dd")
        let fullNameArr1 = formatingDate.components(separatedBy: "-")
        self.SelectedMonth = fullNameArr1[1]
        self.SelectedYear = fullNameArr1[0]
        
        self.RemoveSelectedDates()
        GET_HOLIDAY_MONTHLY_API()
    }
    
    //MARK: -  API Calls
//    func AddToFav_API() {
//
//        var State:String!
//        if(String(self.Favflag) == "0")
//        {
//            State = "1"
//        }
//        else
//        {
//            State = "0"
//        }
//        let url = API.BASE_URL + API.ADD_TO_FAV
//        let param : [String:String] = ["location_id" : self.LocID,
//                                       "favorite" : State]
//
//        let header = ["Content-Type":"application/x-www-form-urlencoded",
//                      "Authorization": "Bearer \(AppPrefs.shared.getUserId())"
//        ]
//
//        if NetworkReachabilityManager()?.isReachable == true
//        {
//            AppDelegate.shared().ShowSpinnerView()
//            Alamofire.request(url, method: .post, parameters: param, encoding: URLEncoding.httpBody, headers: header).response { (response) in
//                AppDelegate.shared().HideSpinnerView()
//                do
//                {
//                    let dict = try? JSONSerialization.jsonObject(with: response.data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSMutableDictionary
//                    if dict?.count==0 || dict == nil
//                    {
//                        displayAlert(APPNAME, andMessage: MSG.NO_RESPONSE)
//                    }
//                    else
//                    {
//                        print(dict!)
//                        let status = dict?.value(forKeyPath: "status") as? String ?? ""
//                        if(status == "error")
//                        {
//                            displayAlert(APPNAME, andMessage: (dict?.value(forKeyPath: "message") as? String)!)
//                        }
//                        else
//                        {
//                            let arrdata = dict?.value(forKey: "data") as? NSMutableArray
//                            let dict1 = arrdata![0] as? NSMutableDictionary
//                            let fav = dict1?.value(forKey: "favorite_location") as? Int
//                            self.Favflag = fav
//
//                            if(self.Favflag == 0)
//                            {
//                                self.btnAddToFav.isSelected = true
//                                self.SetupfavBtn()
//                            }
//                            else
//                            {
//                                self.btnAddToFav.isSelected = false
//                                self.SetupfavBtn()
//                            }
//                        }
//                    }
//                }
//            }
//        }
//        else
//        {
//            displayAlert(APPNAME, andMessage: MSG.NO_NETWORK)
//        }
//    }
    
    
    func GET_HOLIDAY_API() {
        
        let url = API.BASE_URL + API.GET_HOLIDAYS
        
        let param : [String:String] = ["location_id" : self.LocID,
                                       "month" : self.SelectedMonth,
                                       "year" : self.SelectedYear
                                       ]
        
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
                            self.arrAvailableDates = (dict?.value(forKey: "data") as? [String])!
                            print("All Holidays")
                            print(self.arrAvailableDates)
                            
                            // WeekDays Select
                            
//                            let dates = self.datesOfCurrentMonth(with: 5) //[0 = fri , 1 = sat , 2 = sun , 3 = mon , 4 = tue]
//                            for Day in dates{
//                                self.arrFilterdate.append(Day)
//                            }
//                            print(self.arrFilterdate)
                            
                            // WeekDays Select Comp
                            
                            
                            // Month All Dates Select
                            let allDays = Date().getAllDays(DisplayDate: self.calenderView.displayDate!)
                            print(allDays)
                            
                            for day in allDays{
                                
                                let dateFormatter : DateFormatter = DateFormatter()
                                dateFormatter.timeZone = TimeZone.current
                                dateFormatter.dateFormat = "MM/dd/yyyy"
                                let dateString = dateFormatter.string(from: day)
                                self.arrFilterdate.append(dateString)
                            }
                            print(self.arrFilterdate)
                            // Month All Dates Select Comp
                            
                            AppDelegate.shared().AllowDateSelecetionInCalendar = true
                            self.SetupCalendarDates()
                            
                            // Remove Available Dates
                            self.SetAvailableDays()
                            // Remove Available Dates Comp
                            
                            for alldate in self.arrFilterdate
                            {
                                if(self.arrAvailableDates.contains(alldate)){
                                    
                                }
                                else{
                                    self.arrSelectedDates.append(alldate)
                                }
                            }
                            print(self.arrSelectedDates)
                            
                            self.GET_SESSION_API()
                            
                            
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
    
    func GET_HOLIDAY_MONTHLY_API() {
        
        let url = API.BASE_URL + API.GET_HOLIDAYS
        
        let param : [String:String] = ["location_id" : self.LocID,
                                       "month" : self.SelectedMonth,
                                       "year" : self.SelectedYear
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
                            self.arrAvailableDates = []
                            self.arrSelectedDates = []
                            self.Counts = 0
                            
                            self.arrAvailableDates = (dict?.value(forKey: "data") as? [String])!
                            print("All Holidays")
                            print(self.arrAvailableDates)
                            
                            // Month All Dates Select
//                            let allDays = Date().getAllDays(DisplayDate: self.calenderView.displayDate!)
//                            print(allDays)
//
//                            for day in allDays{
//
//                                let dateFormatter : DateFormatter = DateFormatter()
//                                dateFormatter.dateFormat = "MM/dd/yyyy"
//                                let dateString = dateFormatter.string(from: day)
//                                self.arrFilterdate.append(dateString)
//                            }
//                            print(self.arrFilterdate)
                            // Month All Dates Select Comp
                            
//                            print("All Holidays")
//                            print(self.arrFilterdate)
                            
//                            for Dates in ArrDates
//                            {
//                                let Month = Dates.components(separatedBy: "/")
//                                let MonthDate = Month[0]
//
//                                if(self.SelectedMonth == MonthDate)
//                                {
//                                    self.arrFilterdate.append(Dates)
//                                }
//                                else
//                                {
//                                    print(Dates)
//                                }
//                            }
                            
//                            let dates = self.datesOfCurrentMonth(with: 5) //[0 = fri , 1 = sat , 2 = sun , 3 = mon , 4 = tue]
//                            for Day in dates{
//                                self.arrFilterdate.append(Day)
//                            }
                            
                            // Month All Dates Select
//                            let allDays = Date().getAllDays()
//                            print(allDays)
//
//                            for day in allDays{
//
//                                let dateFormatter : DateFormatter = DateFormatter()
//                                dateFormatter.dateFormat = "MM/dd/yyyy"
//                                let dateString = dateFormatter.string(from: day)
//                                self.arrFilterdate.append(dateString)
//                            }
//                            print(self.arrFilterdate)
                            // Month All Dates Select Comp
                            
                            print(self.arrFilterdate)
                            self.SelectedDatesCounts = self.arrFilterdate.count
                            
                            AppDelegate.shared().AllowDateSelecetionInCalendar = true
                            self.SetupCalendarDates()
                            
                            // Remove Available Dates
                            self.SetAvailableDays()
                            // Remove Available Dates Comp
                            
                            for alldate in self.arrFilterdate
                            {
                                if(self.arrAvailableDates.contains(alldate)){
                                    
                                }
                                else{
                                    self.arrSelectedDates.append(alldate)
                                }
                            }
                            print(self.arrSelectedDates)
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
    
    func GET_SESSION_API() {
        
        let url = API.BASE_URL + API.GET_SESSION
        
        let param : [String:String] = ["location" : self.LocID]
        
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
                            self.Sesstion_Type = dictData?.value(forKey: "type") as? String
                            
                            //Discovery Lession
                            if(self.Sesstion_Type == "discovery_lesson")
                            {
                                self.arrSessionData = (dictData?.value(forKey: "session") as? NSMutableArray)!
                                print(self.arrSessionData)
                                
                                self.tableViewSessionHeight.constant = CGFloat.greatestFiniteMagnitude
                                self.tableViewSession.reloadData()
                                self.tableViewSession.layoutIfNeeded()
                                
                                UIView.animate(withDuration: 0, animations: {
                                    self.tableViewSession.layoutIfNeeded()
                                }) { (complete) in
                                    var heightOfTableView: CGFloat = 0.0
                                    
                                    heightOfTableView = self.tableViewSession.contentSize.height
                                    self.tableViewSessionHeight.constant = heightOfTableView
                                    self.view.updateConstraintsIfNeeded()
                                }
                            }
                            
                            //Discovery Enrollment
                            if(self.Sesstion_Type == "discovery_enrollment")
                            {
                                let alert = UIAlertController(title: APPNAME, message: "You are now eligible for \n progression enrollment. \n Book Now.", preferredStyle: UIAlertController.Style.alert)
                                
                                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
                                    
                                    let DictProg = dictData?.value(forKey: "session") as? NSMutableDictionary
                                    self.LocationID = DictProg!["location_id"] as? Int
                                    self.Amount = DictProg!["price"] as? String
                                    let SessionDesc = DictProg!["description"] as? String
                                    DictProg!.setValue(self.Sesstion_Type, forKey: "type")
                                    
                                    let nextNavVc = self.storyboard!.instantiateViewController(withIdentifier: "Progression_Booking_VC") as! Progression_Booking_VC
                                    nextNavVc.Sesstion_Type = self.Sesstion_Type
                                    nextNavVc.Sesstion_Desc = SessionDesc!
                                    nextNavVc.Sesstion_Amount = self.Amount
                                    nextNavVc.Sesstion_Loc = self.LocID
                                    nextNavVc.StrLocForAPI = self.LocID
                                    nextNavVc.isFromLoc = true
                                    self.navigationController?.pushViewController(nextNavVc, animated: true)
                                    
                                }))
                                self.present(alert, animated: true, completion: nil)
                            }
                            
                            //Progression Model
                            if(self.Sesstion_Type == "cruiser" || self.Sesstion_Type == "explorer" || self.Sesstion_Type == "sport" || self.Sesstion_Type == "pro")
                            {
                                let DictCruiser = dictData?.value(forKey: "session") as? NSMutableDictionary
                                self.arrSessionData.add(DictCruiser!)
                                print(self.arrSessionData)
                                
                                self.tableViewSessionHeight.constant = CGFloat.greatestFiniteMagnitude
                                self.tableViewSession.reloadData()
                                self.tableViewSession.layoutIfNeeded()
                                
                                UIView.animate(withDuration: 0, animations: {
                                    self.tableViewSession.layoutIfNeeded()
                                }) { (complete) in
                                    var heightOfTableView: CGFloat = 0.0
                                    
                                    heightOfTableView = self.tableViewSession.contentSize.height
                                    self.tableViewSessionHeight.constant = heightOfTableView
                                    self.view.updateConstraintsIfNeeded()
                                }
                            }
                            
                            //normal sessiom
                            if(self.Sesstion_Type == "normal")
                            {
                                
                                let DictCruiser = dictData?.value(forKey: "session") as? NSMutableDictionary
                                self.arrSessionData.add(DictCruiser!)
                                print(self.arrSessionData)
                                
                                self.tableViewSessionHeight.constant = CGFloat.greatestFiniteMagnitude
                                self.tableViewSession.reloadData()
                                self.tableViewSession.layoutIfNeeded()
                                
                                UIView.animate(withDuration: 0, animations: {
                                    self.tableViewSession.layoutIfNeeded()
                                }) { (complete) in
                                    var heightOfTableView: CGFloat = 0.0
                                    
                                    heightOfTableView = self.tableViewSession.contentSize.height
                                    self.tableViewSessionHeight.constant = heightOfTableView
                                    self.view.updateConstraintsIfNeeded()
                                }
                                self.CHECK_MEMBERSHIP()
                            }
                            
                            //certificate sessiom
                            if(self.Sesstion_Type == "certificate")
                            {
                                let DictCruiser = dictData?.value(forKey: "session") as? NSMutableDictionary
                                self.arrSessionData.add(DictCruiser!)
                                print(self.arrSessionData)
                                
                                self.tableViewSessionHeight.constant = CGFloat.greatestFiniteMagnitude
                                self.tableViewSession.reloadData()
                                self.tableViewSession.layoutIfNeeded()
                                
                                UIView.animate(withDuration: 0, animations: {
                                    self.tableViewSession.layoutIfNeeded()
                                }) { (complete) in
                                    var heightOfTableView: CGFloat = 0.0
                                    
                                    heightOfTableView = self.tableViewSession.contentSize.height
                                    self.tableViewSessionHeight.constant = heightOfTableView
                                    self.view.updateConstraintsIfNeeded()
                                }
                            }
                            
                            if(self.Sesstion_Type == "discovery_lesson"){
                                self.lblCurentLevel.text = "Discovery Lesson"
                                self.lblDuration.text = "Variable Time"
                            }
                            else if(self.Sesstion_Type == "cruiser"){
                                self.lblCurentLevel.text = "Cruiser"
                                self.lblDuration.text = "2 Hours"
                            }
                            else if(self.Sesstion_Type == "explorer"){
                                self.lblCurentLevel.text = "Explorer"
                                self.lblDuration.text = "2 Hours"
                            }
                            else if(self.Sesstion_Type == "sport"){
                                self.lblCurentLevel.text = "Sport"
                                self.lblDuration.text = "2 Hours"
                            }
                            else if(self.Sesstion_Type == "pro"){
                                self.lblCurentLevel.text = "Pro"
                                self.lblDuration.text = "2 Hours"
                            }
                            else if(self.Sesstion_Type == "normal"){
                                self.lblCurentLevel.text = "Normal Session"
                                self.lblDuration.text = "Variable Time"
                            }
                            else if(self.Sesstion_Type == "certificate"){
                                self.lblCurentLevel.text = "Certificate Session"
                                self.lblDuration.text = "2 Hours"
                            }
                            else{
                                self.lblCurentLevel.text = "Progression Enrollment"
                                self.lblDuration.text = "0 Hrs"
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
                                self.LocationID = self.DictData["id"] as? Int
                                self.DictData.setValue(self.Sesstion_Type, forKey: "type")
                                self.DictData.setValue(self.TimeID, forKey: "timeID")
                                
                                let nextNavVc = self.storyboard!.instantiateViewController(withIdentifier: "Payment_VC") as! Payment_VC
                                nextNavVc.dictData = self.DictData
                                nextNavVc.strID = self.LocationID
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
    
    func CHECK_MEMBERSHIP() {
        
        let url = API.BASE_URL + API.CHECK_MEMBERSHIP
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
                            let Check_Flag = dictData?.value(forKey: "membership") as? Bool
                            
                            if(Check_Flag == true)
                            {
                                print("User is Member Now.")
                            }
                            else
                            {
                                displayAlertWithOption(APPNAME, andMessage: "For Normal Sessions Booking User Need to Purchase Membership Subscription. Do you want to continue?", yes: {
                                    
                                    let nextNavVc = self.storyboard!.instantiateViewController(withIdentifier: "Create_PM_VC") as! Create_PM_VC
                                    self.navigationController?.pushViewController(nextNavVc, animated: true)
                                    
                                }, no: {
                                    self.navigationController?.popViewController(animated: true)
                                })
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


extension Date
{
    mutating func addDays(n: Int)
    {
        var cal = Calendar.current
        cal.timeZone = TimeZone.current
        self = cal.date(byAdding: .day, value: n, to: self)!
    }
    
    func firstDayOfTheMonth() -> Date {
        return Calendar.current.date(from:
            Calendar.current.dateComponents([.year,.month], from: self))!
    }
    
    func getAllDays(DisplayDate:Date) -> [Date]
    {
        var days = [Date]()
        
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current
        
        let range = calendar.range(of: .day, in: .month, for: self)!
        
        var day = firstDayOfTheMonth()
        
        for _ in 1...range.count
        {
            print()
            days.append(day)
            day.addDays(n: 1)
        }
        
        return days
    }
}

extension Date {
    static func dates(from fromDate: Date, to toDate: Date) -> [Date] {
        var dates: [Date] = []
        var date = fromDate
        
        while date <= toDate {
            dates.append(date)
            guard let newDate = Calendar.current.date(byAdding: .day, value: 1, to: date) else { break }
            date = newDate
        }
        return dates
    }
}
