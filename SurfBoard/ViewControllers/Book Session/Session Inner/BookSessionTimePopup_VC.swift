//
//  BookSessionTimePopup_VC.swift
//  SurfBoard
//
//  Created by esparkbiz on 3/20/20.
//  Copyright © 2020 esparkbiz. All rights reserved.
//

import UIKit
import Alamofire

class BookSessionTimePopup_VC: BaseViewController,UIPickerViewDelegate, UIPickerViewDataSource,UITextFieldDelegate {
    
    //Reschedule Session
    var DictBookedSessiondata:NSMutableDictionary = [:]
    var isFromReschedule:Bool = false
    //Reschedule Session Comp
    
    var SelectedDate:String = ""
    var Sesstion_Type:String = ""
    var SelectedDay:String = ""
    var strStartTime:String = ""
    var strEndTime:String = ""
    var strUserStartTime:String = ""
    var strUserEndTime:String = ""
    var LocID:String!
    var NormalSessionPrice:String!
    
    var DictData: NSMutableDictionary = [:]
    var DictInstructor: NSMutableDictionary = [:]
    var DictBoard: NSMutableDictionary = [:]
    var arrInstructors: NSMutableArray = []
    var arrBoards: NSMutableArray = []
    
    var picker:UIPickerView!
    var picker1:UIPickerView!
    var pickerDuration:UIPickerView!
    
    var Duration:String = "30"
    var Durations = ["30","60","90","120","150","180","210","240"]
    
    
    @IBOutlet var lblBookSessionTimeTitle: UILabel!
    @IBOutlet var lblSelectedDate: UILabel!
    @IBOutlet var lblAvalFromTime: UILabel!
    @IBOutlet var lblAvalToTime: UILabel!
    @IBOutlet var txtStartTime: UITextField!
    @IBOutlet var txtEndTime: UITextField!
    @IBOutlet var btnContinue: UIButton!
    @IBOutlet var btnClose: UIButton!
    
    @IBOutlet private weak var viewPopupUI:UIView!
    @IBOutlet private weak var viewMain:UIView!
    
    @IBOutlet var viewFromTime: UIView!
    @IBOutlet var viewToTime: UIView!
    
    @IBOutlet var lblTimeSlotError: UILabel!
    
    // Hid View
    @IBOutlet var viewInstructBoard: UIView!
    @IBOutlet var viewInstructorBoardHeight: NSLayoutConstraint!
    @IBOutlet var txtInstructor: UITextField!
    @IBOutlet var txtBoard: UITextField!
    @IBOutlet var btnSubmit: UIButton!
    @IBOutlet var lblInstructor: UILabel!
    @IBOutlet var lblBoard: UILabel!
    
    // Hid Duration View
    @IBOutlet var viewDuration: UIView!
    @IBOutlet var viewDurationHeight: NSLayoutConstraint!
    @IBOutlet var txtDuration: UITextField!
    @IBOutlet var lblDuration: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.showViewWithAnimation()

        if(self.isFromReschedule == true){
            let Duration = self.DictBookedSessiondata.value(forKey: "duration") as? Int
            
            self.txtDuration.text = "\(String(Duration!)) Minutes"
            self.Duration = String(Duration!)
            self.txtDuration.isUserInteractionEnabled = false
            self.txtDuration.backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.9490196078, blue: 0.937254902, alpha: 1)
            
            self.lblBookSessionTimeTitle.text = "RESCHEDULE YOUR SESSION TIME"
        }
        else{
            self.txtDuration.text = "30 Minutes"
            self.lblBookSessionTimeTitle.text = "BOOK YOUR SESSION TIME"
        }
        
        self.viewPopupUI.addShadow(color: .lightGray, opacity: 1.0, offset: CGSize(width: 1, height: 1), radius: 2)
        self.viewMain.addCornerRadius(10)
        
        self.lblTimeSlotError.isHidden = true
        
        self.lblSelectedDate.text = "Selected Date : " + self.SelectedDate
        
        self.viewFromTime.addCornerRadius(10)
        self.viewToTime.addCornerRadius(10)
        self.btnContinue.addCornerRadius(10)
        self.btnSubmit.addCornerRadius(10)
        
        self.txtStartTime.delegate = self
        
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.locale = Locale.init(identifier: "en_us")
        datePickerView.datePickerMode = .time
        datePickerView.minuteInterval = 30
        self.txtStartTime.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(self.datePickerValueChanged), for: UIControl.Event.valueChanged)
        
        let numberToolbar11 = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 50))
        numberToolbar11.barStyle = .default
        numberToolbar11.items = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneClickedForDate))]
        numberToolbar11.sizeToFit()
        self.txtStartTime.inputAccessoryView = numberToolbar11
        

        let datePickerView1:UIDatePicker = UIDatePicker()
        datePickerView1.locale = Locale.init(identifier: "en_us")
        datePickerView1.datePickerMode = .time
        self.txtEndTime.inputView = datePickerView1
        datePickerView1.addTarget(self, action: #selector(self.datePickerValueChanged1), for: UIControl.Event.valueChanged)
        
        if let weekday = getDayOfWeek(self.SelectedDate) {
            if(weekday == 1)
            {
                self.SelectedDay = "sunday"
            }
            else if(weekday == 2)
            {
                self.SelectedDay = "monday"
            }
            else if(weekday == 3)
            {
                self.SelectedDay = "tuesday"
            }
            else if(weekday == 4)
            {
                self.SelectedDay = "wednesday"
            }
            else if(weekday == 5)
            {
                self.SelectedDay = "thursday"
            }
            else if(weekday == 6)
            {
                self.SelectedDay = "friday"
            }
            else if(weekday == 7)
            {
                self.SelectedDay = "saturday"
            }
            else
            {
                
            }
            print(self.SelectedDay)
        }
        
        //Hid View
        self.HideView()
        
        if(self.Sesstion_Type == "normal"){
            self.DisplayDurationView()
            self.txtInstructor.isUserInteractionEnabled = false
            self.txtInstructor.placeholder = "Not Required"
            self.txtInstructor.backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.9490196078, blue: 0.937254902, alpha: 1)
        }
        else{
            self.HideDurationView()
        }

        self.picker = UIPickerView()
        self.picker.delegate = self
        self.picker.dataSource = self
        self.txtInstructor.inputView = self.picker
        
        let numberToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 50))
        numberToolbar.barStyle = .default
        numberToolbar.items = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneClickedInstructor))]
        numberToolbar.sizeToFit()
        self.txtInstructor.inputAccessoryView = numberToolbar
        
        self.picker1 = UIPickerView()
        self.picker1.delegate = self
        self.picker1.dataSource = self
        self.txtBoard.inputView = self.picker1
        
        let numberToolbar1 = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 50))
        numberToolbar1.barStyle = .default
        numberToolbar1.items = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneClicked))]
        numberToolbar1.sizeToFit()
        self.txtBoard.inputAccessoryView = numberToolbar1
        
        self.pickerDuration = UIPickerView()
        self.pickerDuration.delegate = self
        self.pickerDuration.dataSource = self
        self.txtDuration.inputView = self.pickerDuration
        
        let numberToolbar2 = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 50))
        numberToolbar2.barStyle = .default
        numberToolbar2.items = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneClicked1))]
        numberToolbar2.sizeToFit()
        self.txtDuration.inputAccessoryView = numberToolbar2
        
        self.GET_ACTIVE_HOURS()
        
    }
    
    //MARK: - doneClickedInstructor Method
    @objc func doneClickedInstructor() -> Void
    {
        self.view.endEditing(true)
        
        if(self.txtInstructor.text == ""){
            
            let dictdata = self.arrInstructors[0] as? NSDictionary
            self.DictInstructor = dictdata as! NSMutableDictionary
            let state = dictdata?.value(forKey: "name") as? String
            self.txtInstructor.text = state
            
        }
    }
    
    //MARK: - doneClicked Method
    @objc func doneClicked() -> Void
    {
        self.view.endEditing(true)
        
        if(self.txtBoard.text == ""){
            
            let dictdata = self.arrBoards[0] as? NSDictionary
            self.DictBoard = dictdata as! NSMutableDictionary
            let state = dictdata?.value(forKey: "model") as? String
            self.txtBoard.text = state
            
        }
        
        let result = UserDefaults.standard.value(forKey: "UserAllData") as? NSDictionary
        let WavierAccepted = result?.value(forKeyPath: "wavier_accepted") as? String
        
        if(WavierAccepted == "")
        {
            let popupVC = self.storyboard?.instantiateViewController(withIdentifier: "CustomerWaiverPopup_VC") as! CustomerWaiverPopup_VC
            popupVC.strID = self.LocID
            self.view.addSubview(popupVC.view)
            self.addChild(popupVC)
            self.CHECK_CUSTOMER_WAVIER()
        }
        else
        {
            print("popupVC not require.")
            self.CHECK_CUSTOMER_WAVIER()
        }

        
    }
    
    //MARK: - doneClicked Method
    @objc func doneClicked1() -> Void
    {
        self.view.endEditing(true)
        
    }
    
    //MARK: - doneClickedForDate Method
    @objc func doneClickedForDate() -> Void
    {
        self.view.endEditing(true)
        
        if(self.txtStartTime.text == ""){
            
            let original = Date()
            let rounded = Date(timeIntervalSinceReferenceDate:
                (original.timeIntervalSinceReferenceDate / 1800.0).rounded(.toNearestOrEven) * 1800.0)
            
            self.HideView()
            
//            let formatter = DateFormatter()
//            formatter.timeStyle = .short
//            self.txtStartTime.text = formatter.string(from: rounded)
            
            let dateFormatter7 = DateFormatter()
            dateFormatter7.dateFormat = "h:mm a"
            dateFormatter7.timeZone = TimeZone.current
            self.txtStartTime.text = dateFormatter7.string(from: rounded)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            let newTimeString = dateFormatter.string(from: rounded)
            
            var UserAssignedTime:Date!
            if(self.Sesstion_Type == "cruiser" || self.Sesstion_Type == "explorer" || self.Sesstion_Type == "sport" || self.Sesstion_Type == "pro" || self.Sesstion_Type == "certificate")
            {
                let AddMinutes = "120"
                let intMinute = Int(AddMinutes)
                let Final = intMinute! * 60
                let UserSelectedTime = dateFormatter.date(from: newTimeString)!
                UserAssignedTime = UserSelectedTime.addingTimeInterval(TimeInterval(Final))
            }
            else if(self.Sesstion_Type == "normal")
            {
                let Price = self.DictData["price"] as? String
                let AddMinutes = self.Duration
                let intMinute = Int(AddMinutes)
                let intPrice = Double(Price!)
                let FinalAmount = Double(intMinute!) * intPrice!
                self.NormalSessionPrice = String(Int(FinalAmount))
                let Final = intMinute! * 60
                let UserSelectedTime = dateFormatter.date(from: newTimeString)!
                UserAssignedTime = UserSelectedTime.addingTimeInterval(TimeInterval(Final))
                self.btnSubmit.setTitle("Continue To Pay $\(self.NormalSessionPrice!)", for: .normal)
            }
            else
            {
                let AddMinutes = self.DictData["duration"] as? String
                let intMinute = Int(AddMinutes!)
                let Final = intMinute! * 60
                let UserSelectedTime = dateFormatter.date(from: newTimeString)!
                UserAssignedTime = UserSelectedTime.addingTimeInterval(TimeInterval(Final))
            }
            
            if(self.isFromReschedule == true){
                self.btnSubmit.setTitle("Reschedule", for: .normal)
            }
            
            let dateFormatter1 = DateFormatter()
            dateFormatter1.dateFormat = "h:mm a"
            dateFormatter1.timeZone = TimeZone.current
            let FinalEndTime = dateFormatter1.string(from: UserAssignedTime)
            self.txtEndTime.text = FinalEndTime
            
            let dateMaker = DateFormatter()
            dateMaker.dateFormat = "HH:mm:ss"
            dateMaker.timeZone = TimeZone.current
            let start = dateMaker.date(from: self.strStartTime)!
            let end = dateMaker.date(from: self.strEndTime)!
            
            func isBetweenMyTwoDates(date: NSDate) -> Bool {
                if start.compare(date as Date) == .orderedAscending && end.compare(date as Date) == .orderedDescending {
                    return true
                }
                return false
            }
            
            let Status = isBetweenMyTwoDates(date: dateMaker.date(from: newTimeString + ":01")! as NSDate)
            if(Status == true)
            {
                
                let dateFormatter1 = DateFormatter()
                dateFormatter1.dateFormat = "HH:mm:ss"
                let date1 = dateFormatter1.date(from: self.strEndTime)
                
                
                let UserEndTime : NSDate = UserAssignedTime as NSDate
                let AvailableEndTime : NSDate = date1! as NSDate
                
                let compareResult = UserEndTime.compare(AvailableEndTime as Date)
                if compareResult == ComparisonResult.orderedDescending {
                    print("\(UserEndTime) is Greater than \(AvailableEndTime)")
                    self.lblTimeSlotError.isHidden = false
                    self.btnContinue.isUserInteractionEnabled = false
                }
                else
                {
                    print("Allowed")
                    
                    
                    let dateFormatter : DateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "MM/dd/yyyy HH:mm:ss"
                    let date = Date()
                    let dateString = dateFormatter.string(from: date)
                    print(dateString)
                    
                    let fullNameArr1 = dateString.components(separatedBy: " ")
                    let SelectDate = fullNameArr1[0]
                    
                    if(self.SelectedDate == SelectDate)
                    {
                        
                        let calender = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
                        calender!.locale = NSLocale.current
                        calender!.timeZone = TimeZone.current
                        
                        let timeToday = newTimeString + ":01"
                        let timeArray = timeToday.components(separatedBy: ":")
                        let timeTodayHours = Int(timeArray[0])
                        let timeTodayMin = Int(timeArray[1])
                        let timeTodayDate = calender!.date(bySettingHour: timeTodayHours!, minute: timeTodayMin!, second: 00, of: NSDate() as Date, options: NSCalendar.Options())
                        
                        let now = NSDate()
                        if now.compare(timeTodayDate!) == .orderedDescending {
                            print(" 'time' has passed!!! ")
                            self.lblTimeSlotError.text = " Selected time has passed!!! "
                            self.lblTimeSlotError.isHidden = false
                            self.btnContinue.isUserInteractionEnabled = false
                        }
                        else
                        {
                            self.lblTimeSlotError.isHidden = true
                            self.btnContinue.isUserInteractionEnabled = true
                        }
                    }
                    else
                    {
                        self.lblTimeSlotError.isHidden = true
                        self.btnContinue.isUserInteractionEnabled = true
                    }
                }
            }
            else
            {
                print("Not Allowed")
                self.lblTimeSlotError.isHidden = false
                self.btnContinue.isUserInteractionEnabled = false
            }
            
        }
        else{
            
            
        }
        
        
        
    }
    
    //MARK: - datePickerValueChanged Method
    @objc func datePickerValueChanged(sender:UIDatePicker) {
        
        self.HideView()
        
//        let formatter = DateFormatter()
//        formatter.timeStyle = .short
//        self.txtStartTime.text = formatter.string(from: sender.date)
        
        let dateFormatter7 = DateFormatter()
        dateFormatter7.dateFormat = "h:mm a"
        dateFormatter7.timeZone = TimeZone.current
        self.txtStartTime.text = dateFormatter7.string(from: sender.date)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let newTimeString = dateFormatter.string(from: sender.date)
        
        var UserAssignedTime:Date!
        if(self.Sesstion_Type == "cruiser" || self.Sesstion_Type == "explorer" || self.Sesstion_Type == "sport" || self.Sesstion_Type == "pro" || self.Sesstion_Type == "certificate")
        {
            let AddMinutes = "120"
            let intMinute = Int(AddMinutes)
            let Final = intMinute! * 60
            let UserSelectedTime = dateFormatter.date(from: newTimeString)!
            UserAssignedTime = UserSelectedTime.addingTimeInterval(TimeInterval(Final))
        }
        else if(self.Sesstion_Type == "normal")
        {
            let Price = self.DictData["price"] as? String
            let AddMinutes = self.Duration
            let intMinute = Int(AddMinutes)
            let intPrice = Double(Price!)
            let FinalAmount = Double(intMinute!) * intPrice!
            self.NormalSessionPrice = String(Int(FinalAmount))
            let Final = intMinute! * 60
            let UserSelectedTime = dateFormatter.date(from: newTimeString)!
            UserAssignedTime = UserSelectedTime.addingTimeInterval(TimeInterval(Final))
            self.btnSubmit.setTitle("Continue To Pay $\(self.NormalSessionPrice!)", for: .normal)
        }
        else
        {
            let AddMinutes = self.DictData["duration"] as? String
            let intMinute = Int(AddMinutes!)
            let Final = intMinute! * 60
            let UserSelectedTime = dateFormatter.date(from: newTimeString)!
            UserAssignedTime = UserSelectedTime.addingTimeInterval(TimeInterval(Final))
        }
        
        if(self.isFromReschedule == true){
            self.btnSubmit.setTitle("Reschedule", for: .normal)
        }
        
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "h:mm a"
        dateFormatter1.timeZone = TimeZone.current
        let FinalEndTime = dateFormatter1.string(from: UserAssignedTime)
        self.txtEndTime.text = FinalEndTime

        let dateMaker = DateFormatter()
        dateMaker.dateFormat = "HH:mm:ss"
        dateMaker.timeZone = TimeZone.current
        let start = dateMaker.date(from: self.strStartTime)!
        let end = dateMaker.date(from: self.strEndTime)!
        
        func isBetweenMyTwoDates(date: NSDate) -> Bool {
            if start.compare(date as Date) == .orderedAscending && end.compare(date as Date) == .orderedDescending {
                return true
            }
            return false
        }
        
        let Status = isBetweenMyTwoDates(date: dateMaker.date(from: newTimeString + ":01")! as NSDate)
        if(Status == true)
        {
            
            let dateFormatter1 = DateFormatter()
            dateFormatter1.dateFormat = "HH:mm:ss"
            let date1 = dateFormatter1.date(from: self.strEndTime)
            
            
            let UserEndTime : NSDate = UserAssignedTime as NSDate
            let AvailableEndTime : NSDate = date1! as NSDate
            
            let compareResult = UserEndTime.compare(AvailableEndTime as Date)
            if compareResult == ComparisonResult.orderedDescending {
                print("\(UserEndTime) is Greater than \(AvailableEndTime)")
                self.lblTimeSlotError.isHidden = false
                self.btnContinue.isUserInteractionEnabled = false
            }
            else
            {
                print("Allowed")
                
                
                let dateFormatter : DateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM/dd/yyyy HH:mm:ss"
                let date = Date()
                let dateString = dateFormatter.string(from: date)
                print(dateString)
                
                let fullNameArr1 = dateString.components(separatedBy: " ")
                let SelectDate = fullNameArr1[0]

                if(self.SelectedDate == SelectDate)
                {

                    let calender = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
                    calender!.locale = NSLocale.current
                    calender!.timeZone = TimeZone.current
                    
                    let timeToday = newTimeString + ":01"
                    let timeArray = timeToday.components(separatedBy: ":")
                    let timeTodayHours = Int(timeArray[0])
                    let timeTodayMin = Int(timeArray[1])
                    let timeTodayDate = calender!.date(bySettingHour: timeTodayHours!, minute: timeTodayMin!, second: 00, of: NSDate() as Date, options: NSCalendar.Options())
                    
                    let now = NSDate()
                    if now.compare(timeTodayDate!) == .orderedDescending {
                        print(" 'time' has passed!!! ")
                        self.lblTimeSlotError.text = " Selected time has passed!!! "
                        self.lblTimeSlotError.isHidden = false
                        self.btnContinue.isUserInteractionEnabled = false
                    }
                    else
                    {
                        self.lblTimeSlotError.isHidden = true
                        self.btnContinue.isUserInteractionEnabled = true
                    }
                }
                else
                {
                    self.lblTimeSlotError.isHidden = true
                    self.btnContinue.isUserInteractionEnabled = true
                }
            }
        }
        else
        {
            print("Not Allowed")
            self.lblTimeSlotError.isHidden = false
            self.btnContinue.isUserInteractionEnabled = false
        }
        
        
        
    }
    
    @objc func datePickerValueChanged1(sender:UIDatePicker) {
        
        self.HideView()
        
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        self.txtEndTime.text = formatter.string(from: sender.date)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        let newTimeString = dateFormatter.string(from: sender.date)
        
        var UserAssignedTime:Date!
        let AddMinutes = "0"
        let intMinute = Int(AddMinutes)
        let Final = intMinute! * 60
        let UserSelectedTime = dateFormatter.date(from: newTimeString)!
        UserAssignedTime = UserSelectedTime.addingTimeInterval(TimeInterval(Final))
        
        let dateMaker = DateFormatter()
        dateMaker.dateFormat = "HH:mm:ss"
        let start = dateMaker.date(from: self.strStartTime)!
        let end = dateMaker.date(from: self.strEndTime)!
        
        func isBetweenMyTwoDates(date: NSDate) -> Bool {
            if start.compare(date as Date) == .orderedAscending && end.compare(date as Date) == .orderedDescending {
                return true
            }
            return false
        }
        
        let Status = isBetweenMyTwoDates(date: dateMaker.date(from: newTimeString)! as NSDate)
        if(Status == true)
        {
            
            let dateFormatter1 = DateFormatter()
            dateFormatter1.dateFormat = "HH:mm:ss"
            let date1 = dateFormatter1.date(from: self.strEndTime)
            
            
            let UserEndTime : NSDate = UserAssignedTime as NSDate
            let AvailableEndTime : NSDate = date1! as NSDate
            
            let compareResult = UserEndTime.compare(AvailableEndTime as Date)
            if compareResult == ComparisonResult.orderedDescending {
                print("\(UserEndTime) is Greater than \(AvailableEndTime)")
                self.lblTimeSlotError.isHidden = false
                self.btnContinue.isUserInteractionEnabled = false
            }
            else
            {
                print("Allowed")
                self.lblTimeSlotError.isHidden = true
                self.btnContinue.isUserInteractionEnabled = true
                
                let Fromtime = self.AMPM_To_Hour24(StrDate: self.txtStartTime.text!)
                let dateFormatter1 = DateFormatter()
                dateFormatter1.dateFormat = "HH:mm:ss"
                let date = dateFormatter1.date(from: Fromtime)

                let Totime = newTimeString
                let dateFormatter2 = DateFormatter()
                dateFormatter2.dateFormat = "HH:mm:ss"
                let date1 = dateFormatter2.date(from: Totime)
                
                let dateFormatter12 = DateFormatter()
                dateFormatter12.dateFormat = "h:mm a"
                let calendar = Calendar.current
                let From1 = calendar.dateComponents([.hour, .minute], from: date!)
                let To1 = calendar.dateComponents([.hour, .minute], from: date1!)
                let CostBasedOnTime = calendar.dateComponents([.minute], from: From1, to: To1).minute!
                print(CostBasedOnTime)
                
                self.btnSubmit.setTitle("Continue To Pay $\(CostBasedOnTime)", for: .normal)
            }
        }
        else
        {
            print("Not Allowed")
            self.lblTimeSlotError.isHidden = false
            self.btnContinue.isUserInteractionEnabled = false
        }
        
        if(self.isFromReschedule == true){
            self.btnSubmit.setTitle("Reschedule", for: .normal)
        }
       
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
    
    
    //MARK: - textField Delegate Method
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
    
    //MARK: - btnContinueAction Method
    @IBAction func btnContinueAction(_ sender: Any) {
        
        if(self.txtStartTime.text! == "" || self.txtEndTime.text! == "")
        {
            displayAlert(APPNAME, andMessage: "Please Select Start Time & End Time")
        }
        else
        {
            print("Continue Clicked")
            self.Check_Avaibility()
        }
    }
    
    //MARK: - btnSubmitAction Method
    @IBAction func btnSubmitAction(_ sender: Any) {
        if(self.Sesstion_Type == "normal"){
            if(self.txtBoard.text! == "")
            {
                displayAlert(APPNAME, andMessage: "Please Select Board")
            }
            else
            {
                print("Submitted")
                if(self.isFromReschedule == true){
                    
                    self.RescheduleSession()
                    
                }
                else{
                    
                    self.CHECK_BOOKING()
                    
                }
                
            }
        }
        else
        {
            if(self.txtInstructor.text! == "" || self.txtBoard.text! == "")
            {
                displayAlert(APPNAME, andMessage: "Please Select Instructor & Board")
            }
            else
            {
                print("Submitted")
                if(self.isFromReschedule == true){
                    
                    self.RescheduleSession()
                    
                }
                else{
                    
                    self.CHECK_BOOKING()
                    
                }
            }
        }
       
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
    
    //MARK: - Hide View Methods
    func HideView(){
        
        self.viewInstructBoard.isHidden = true
        self.viewInstructorBoardHeight.constant = 0
        self.lblInstructor.isHidden = true
        self.lblBoard.isHidden = true
        self.txtInstructor.isHidden = true
        self.txtBoard.isHidden = true
        self.btnSubmit.isHidden = true
        
    }
    
    func HideDurationView(){
        
        self.viewDuration.isHidden = true
        self.viewDurationHeight.constant = 0
        self.lblDuration.isHidden = true
        self.txtDuration.isHidden = true
     }
    
    func DisplayDurationView(){
        self.viewDuration.isHidden = false
        self.viewDurationHeight.constant = 50
        self.lblDuration.isHidden = false
        self.txtDuration.isHidden = false
        self.view.updateConstraintsIfNeeded()
    }
    
    
    func DisplayView(){
        
        if(self.Sesstion_Type == "normal")
        {
            self.viewInstructBoard.isHidden = false
            self.viewInstructorBoardHeight.constant = 120
            self.lblInstructor.isHidden = false
            self.txtInstructor.isHidden = false
            self.lblBoard.isHidden = false
            self.txtBoard.isHidden = false
            self.btnSubmit.isHidden = false
        }
        else
        {
            self.viewInstructBoard.isHidden = false
            self.viewInstructorBoardHeight.constant = 120
            self.lblInstructor.isHidden = false
            self.lblBoard.isHidden = false
            self.txtInstructor.isHidden = false
            self.txtBoard.isHidden = false
            self.btnSubmit.isHidden = false
        }
    }
    
    //MARK: - AMPM_To_Hour24 Methods
    func AMPM_To_Hour24( StrDate : String) -> String
    {
//        let StrTime:String!
//
//        if StrDate.contains("AM") || StrDate.contains("PM"){
//            print("exists")
//            StrTime = StrDate
//        }
//        else{
//            var arr = StrDate.components(separatedBy: ":")
//            let Hour = arr[0]
//            let IntHour = Int(Hour)!
//
//            if(IntHour >= 12){
//                StrTime = StrDate + " PM"
//            }
//            else{
//                StrTime = StrDate + " AM"
//            }
//            print(StrTime)
//        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        let date = dateFormatter.date(from: StrDate)
        dateFormatter.dateFormat = "HH:mm:ss"
        let FormattedTime = dateFormatter.string(from: date!)
        return FormattedTime
    }
    
    func Hour24_To_AMPM( StrDate : String) -> String
    {
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "HH:mm:ss"
        let date1 = dateFormatter1.date(from: StrDate)
        dateFormatter1.dateFormat = "h:mm a"
        let FormattedTime = dateFormatter1.string(from: date1!)
        return FormattedTime
    }
    
    
    //MARK: - UIPickerviewDelegate and Datasource methods -
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        if(pickerView == self.picker)
        {
            return self.arrInstructors.count
        }
        else if(pickerView == self.pickerDuration)
        {
            return self.Durations.count
        }
        else
        {
            return self.arrBoards.count
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        if(pickerView == self.picker)
        {
            let dictdata = self.arrInstructors[row] as? NSDictionary
            let Name = dictdata?.value(forKey: "name") as? String
            return Name
        }
        else if(pickerView == self.pickerDuration)
        {
            return SAFESTRING(str: Durations[row])
        }
        else
        {
            let dictdata = self.arrBoards[row] as? NSDictionary
            //let Name = dictdata?.value(forKey: "model") as? String
            let Name = dictdata!["model"] as? String
            return Name
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if(pickerView == self.picker)
        {
            let dictdata = self.arrInstructors[row] as? NSDictionary
            self.DictInstructor = dictdata as! NSMutableDictionary
            let state = dictdata?.value(forKey: "name") as? String
            self.txtInstructor.text = state
        }
        else if(pickerView == self.pickerDuration)
        {
            self.txtDuration.text = "\(Durations[row]) " + "Minutes"
            self.Duration = "\(Durations[row])"
            
            self.txtStartTime.text = ""
            self.txtEndTime.text = ""
        }
        else
        {
            let dictdata = self.arrBoards[row] as? NSDictionary
            self.DictBoard = dictdata as! NSMutableDictionary
            let state = dictdata?.value(forKey: "model") as? String
            self.txtBoard.text = state
        }
        
    }
    
    //MARK: - API Calls
    func GET_ACTIVE_HOURS() {
        
        let url = API.BASE_URL + API.GET_ACTIVE_HOURS
        
        let param : [String:String] = ["location" : self.LocID,
                                       "day" : self.SelectedDay]
        
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
                            displayAlert(APPNAME, andMessage: (dict?.value(forKeyPath: "message") as? String ?? "Invalid Data.")!)
                        }
                        else
                        {
                            print(dict!)
                            let Data = dict?.value(forKeyPath: "data") as? NSMutableDictionary
                            
                            let Available = Data?.value(forKey: "available") as? Int
                            if(Available == 1)
                            {
                                self.strStartTime = (Data?.value(forKey: "start_time") as? String)!
                                self.lblAvalFromTime.text = self.Hour24_To_AMPM(StrDate: self.strStartTime)
                                
                                self.strEndTime = (Data?.value(forKey: "end_time") as? String)!
                                self.lblAvalToTime.text = self.Hour24_To_AMPM(StrDate: self.strEndTime)
                            }
                            else
                            {
                                displayAlertWithOneOptionAndAction(APPNAME, andMessage: "Booking is not Available. \n Please Select Another Day.", no: {
                                    self.hideViewWithAnimation()
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
    
    func Check_Avaibility() {
        
        let From = self.AMPM_To_Hour24(StrDate: self.txtStartTime.text!)
        let To = self.AMPM_To_Hour24(StrDate: self.txtEndTime.text!)
        
        let url = API.BASE_URL + API.CHECK_AVAIBILITY
        let param : [String:String] = ["location" : self.LocID,
                                       "day" : self.SelectedDay,
                                       "date" : self.SelectedDate,
                                       "start_time" : From,
                                       "end_time" : To,
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
                        let status = dict?.value(forKeyPath: "status") as? String ?? ""
                        if(status == "error")
                        {
                            displayAlert(APPNAME, andMessage: (dict?.value(forKeyPath: "message") as? String ?? "Invalid Data.")!)
                        }
                        else
                        {
                            print(dict!)
                            let Dictdata1 = dict?.value(forKey: "data") as? NSMutableDictionary
                            let Booking = Dictdata1?.value(forKey: "booking") as? Bool
                            if(Booking == true)
                            {
                                self.DisplayView()
                                if(self.Sesstion_Type == "normal")
                                {
                                    //self.arrInstructors = (Dictdata1?.value(forKey: "instructors") as? NSMutableArray)!
                                    self.arrBoards = (Dictdata1?.value(forKey: "boards") as? NSMutableArray)!
                                    if(self.arrBoards.count == 0)
                                    {
                                        displayAlert(APPNAME, andMessage: "Board is Not Available For Your Selected Time Slot. Please Select Another Time.")
                                    }
                                    else
                                    {
                                        print("Available I/B")
                                    }
                                    
                                }
                                else
                                {
                                    self.arrInstructors = (Dictdata1?.value(forKey: "instructors") as? NSMutableArray)!
                                    self.arrBoards = (Dictdata1?.value(forKey: "boards") as? NSMutableArray)!
                                    if(self.arrInstructors.count == 0 || self.arrBoards.count == 0)
                                    {
                                        displayAlert(APPNAME, andMessage: "Instructor or Board is Not Available For Your Selected Time Slot. Please Select Another Time.")
                                    }
                                    else
                                    {
                                        print("Available I/B")
                                    }
                                }
                            }
                            else
                            {
                                displayAlert(APPNAME, andMessage: Dictdata1?.value(forKey: "message") as? String ?? "Booking Not Available For Selected Time Slot.")
                                self.HideView()
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
                                let From = self.AMPM_To_Hour24(StrDate: self.txtStartTime.text!)
                                let To = self.AMPM_To_Hour24(StrDate: self.txtEndTime.text!)
                                
                                let LocationID = self.DictData["location_id"] as? Int
                                var Session_Amount:String = ""
                                if(self.Sesstion_Type == "normal"){
                                    Session_Amount = self.NormalSessionPrice//self.Duration
                                }
                                else
                                {
                                    Session_Amount = (self.DictData["price"] as? String)!
                                }
                                
                                self.DictData.setValue(From, forKey: "user_start_time")
                                self.DictData.setValue(To, forKey: "user_end_time")
                                self.DictData.setValue(self.Sesstion_Type, forKey: "type")
                                self.DictData.setValue(self.SelectedDate, forKey: "date")
                                
                     
                                    let nextNavVc = self.storyboard!.instantiateViewController(withIdentifier: "Payment_VC") as! Payment_VC
                                    nextNavVc.dictData = self.DictData
                                    nextNavVc.strID = LocationID
                                    nextNavVc.Amount = Session_Amount
                                    nextNavVc.dictInstructor = self.DictInstructor
                                    nextNavVc.dictBoard = self.DictBoard
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
    
    func RescheduleSession() {
        
        let url = API.BASE_URL + API.RESCHEDULE_SESSION
        
        let From = self.AMPM_To_Hour24(StrDate: self.txtStartTime.text!)
        let To = self.AMPM_To_Hour24(StrDate: self.txtEndTime.text!)

        self.DictData.setValue(From, forKey: "user_start_time")
        self.DictData.setValue(To, forKey: "user_end_time")
        self.DictData.setValue(self.Sesstion_Type, forKey: "type")
        self.DictData.setValue(self.SelectedDate, forKey: "date")
        
        let date = self.SelectedDate
        let StartTime = self.DictData.value(forKey: "user_start_time") as? String
        let endTime = self.DictData.value(forKey: "user_end_time") as? String
        var Inst:String!
        var Board:String!
        let SessionID = self.DictBookedSessiondata.value(forKey: "id") as? Int
        let strSessionID = String(SessionID!)
        
        var param : [String:String] = ["":""]
        
        let Session_Type = self.Sesstion_Type
        if(Session_Type == "discovery_lesson" || Session_Type == "cruiser" || Session_Type == "explorer" || Session_Type == "sport" || Session_Type == "pro" || Session_Type == "certificate")
        {
            Inst = String(self.DictInstructor["id"] as! Int)
            Board = String(self.DictBoard["id"] as! Int)
            
            param = ["date" : date,
                     "start_time" : StartTime!,
                     "end_time" : endTime!,
                     "board" : Board,
                     "instructor" : Inst,
                     "id" : strSessionID,
                     "type" : Session_Type,
            ]
            
        }
        
        if(Session_Type == "normal")
        {
            Inst = ""
            Board = String(self.DictBoard["id"] as! Int)
            
            param = ["date" : date,
                     "start_time" : StartTime!,
                     "end_time" : endTime!,
                     "board" : Board,
                     "id" : strSessionID,
                     "type" : Session_Type,
            ]
            
        }
        
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
                            print(dict!)
                            
                            let Dictdata1 = dict?.value(forKey: "data") as? NSMutableDictionary
                            let Updated = Dictdata1?.value(forKey: "updated") as? Bool
                            if(Updated == true)
                            {
                             
                                //self.hideViewWithAnimation()
                                let alert = UIAlertController(title: APPNAME, message: "Your Session rescheduled Successfully.", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(status) in
                                    
                                    self.tabBarController?.selectedIndex = 2
                                    (self.tabBarController?.selectedViewController as! UINavigationController).popToRootViewController(animated: false)
                                   //self.tabBarController?.selectedIndex = 0
                                    
                                }))
                                self.present(alert, animated: true, completion: nil)
                                
                            }
                            else{
                                displayAlert(APPNAME, andMessage: "Error while rescheduling your Session. Please try after some time.")
                                
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
    
    func CHECK_CUSTOMER_WAVIER() {
        
        let url = API.BASE_URL + API.CHECK_WAIVER
        
        let param : [String:String] = ["location_id" : self.LocID]
        
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
                            let Check_Flag = dictData?.value(forKey: "show") as? Bool
                            
                            if(Check_Flag == true)
                            {
                                let Type = dictData?.value(forKey: "type") as? String ?? ""
                                if(Type == "text"){
                                    
                                    let Desc = dictData?.value(forKey: "wavier") as? String ?? ""
                                    
                                    let popupVC = self.storyboard?.instantiateViewController(withIdentifier: "LocationWiseWavier_VC") as! LocationWiseWavier_VC
                                    popupVC.strID = self.LocID
                                    popupVC.strDesc = Desc
                                    self.view.addSubview(popupVC.view)
                                    self.addChild(popupVC)
                                    
                                }
                                    
                                else{
                                    
                                    let URLink = dictData?.value(forKey: "wavier") as? String ?? ""
                                    
                                    let popupVC = self.storyboard?.instantiateViewController(withIdentifier: "LocationWiseWavierForURL_VC") as! LocationWiseWavierForURL_VC
                                    popupVC.strID = self.LocID
                                    popupVC.StrURL = URLink
                                    self.view.addSubview(popupVC.view)
                                    self.addChild(popupVC)
                                    
                                }
                                
                                
                            }
                            else
                            {
                                print("Loc popupVC not require.")
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
