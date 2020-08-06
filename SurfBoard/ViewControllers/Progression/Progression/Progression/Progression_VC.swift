//
//  Progression_VC.swift
//  SurfBoard
//
//  Created by esparkbiz on 12/23/19.
//  Copyright © 2019 esparkbiz. All rights reserved.
//

import UIKit
import Alamofire

class Progression_VC: BaseViewController,UITableViewDataSource, UITableViewDelegate {
    
    var arrDataEnrollment:NSMutableArray = []
    var arrDataProg1:NSMutableArray = []
    var arrDataProg2:NSMutableArray = []
    var arrDataProg3:NSMutableArray = []
    var arrDataProg4:NSMutableArray = []
    
    var StatusProg1:Int = 00
    var StatusProg2:Int = 00
    var StatusProg3:Int = 00
    var StatusProg4:Int = 00
    
    var FlagProg1:Bool = false
    var FlagProg2:Bool = false
    var FlagProg3:Bool = false
    var FlagProg4:Bool = false
    
    var FlagInitialProg1:Bool = false
    var FlagInitialProg2:Bool = false
    var FlagInitialProg3:Bool = false
    var FlagInitialProg4:Bool = false
    
    var FlagPendingProg1:Bool = false
    var FlagPendingProg2:Bool = false
    var FlagPendingProg3:Bool = false
    var FlagPendingProg4:Bool = false
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var tableViewHeight: NSLayoutConstraint!
    
    @IBOutlet var tableView2: UITableView!
    @IBOutlet var tableViewHeight2: NSLayoutConstraint!
    
    @IBOutlet var tableView3: UITableView!
    @IBOutlet var tableViewHeight3: NSLayoutConstraint!
    
    @IBOutlet var tableView4: UITableView!
    @IBOutlet var tableViewHeight4: NSLayoutConstraint!
    
    @IBOutlet var tableView5: UITableView!
    @IBOutlet var tableViewHeight5: NSLayoutConstraint!
    
    @IBOutlet var tableView6: UITableView!
    @IBOutlet var tableViewHeight6: NSLayoutConstraint!
    
    @IBOutlet var viewMember: UIView!
    @IBOutlet var lblMemberStatus: UILabel!
    @IBOutlet var imgMember: UIImageView!
    
    @IBOutlet var lblDisTitle: UILabel!
    @IBOutlet var lblCruTitle: UILabel!
    @IBOutlet var lblExpTitle: UILabel!
    @IBOutlet var lblSpoTitle: UILabel!
    @IBOutlet var lblProTitle: UILabel!
    @IBOutlet var lblMemTitle: UILabel!
    @IBOutlet var lblMemberShipTitle: UILabel!
    
    @IBOutlet var viewCruiser: UIView!
    @IBOutlet var lblCruiser: UILabel!
    @IBOutlet var viewCruiserHeight: NSLayoutConstraint!
    
    @IBOutlet var viewExplorer: UIView!
    @IBOutlet var lblExplorer: UILabel!
    @IBOutlet var viewExplorerHeight: NSLayoutConstraint!
    
    @IBOutlet var viewSport: UIView!
    @IBOutlet var lblSport: UILabel!
    @IBOutlet var viewSportHeight: NSLayoutConstraint!
    
    @IBOutlet var viewPro: UIView!
    @IBOutlet var lblPro: UILabel!
    @IBOutlet var viewProHeight: NSLayoutConstraint!
    
    @IBOutlet var viewMemberHeader: UIView!
    @IBOutlet var lblMember: UILabel!
    @IBOutlet var viewMemberHeight: NSLayoutConstraint!
    
    //Membership View
    @IBOutlet var viewMemberShip: UIView!
    @IBOutlet var lblMemberShipHeader: UILabel!
    @IBOutlet var viewMembershipHeight: NSLayoutConstraint!
//    @IBOutlet var viewMembershipHeader: UIView!
//    @IBOutlet var viewInsideMembership: UIView!
//    @IBOutlet var lblMembershipTitle: UILabel!
//    @IBOutlet var lblMembershipText: UILabel!
//    @IBOutlet var viewMembershipHeaderHeight: NSLayoutConstraint!
//    @IBOutlet var viewMembershipInsideViewHeight: NSLayoutConstraint!
    
    //Membership View Comp
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.navigationController?.isNavigationBarHidden = false
        AppDelegate.shared().setupNavigationBar()
        setTranspertNavigation()
        self.title = "Progression"
        
        self.tableView.separatorStyle  = .none
        self.tableView2.separatorStyle = .none
        self.tableView3.separatorStyle = .none
        self.tableView4.separatorStyle = .none
        self.tableView5.separatorStyle = .none
        self.tableView6.separatorStyle = .none
        
        self.tableView.addObserver(self, forKeyPath: "contentSize", options: [], context: nil)
        self.tableView.separatorStyle = .none
        
        self.viewMember.addCornerRadius(10)
        self.viewMember.layer.borderColor = #colorLiteral(red: 0.2784313725, green: 0.4549019608, blue: 0.5921568627, alpha: 1)
        self.viewMember.layer.borderWidth = 2
        
        //Membership View
        self.viewMemberShip.isHidden = true
        self.lblMemberShipHeader.isHidden = true
        self.viewMemberHeight.constant = 0
        self.tableViewHeight6.constant = 0
        //Membership View Comp
        
        self.view.updateConstraintsIfNeeded()
        
        Get_ProgressionData_API()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //self.setupLang()
        Get_ProgressionData_API()
    }
    
    //MARK: -  observeValue
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        self.tableViewHeight.constant = tableView.contentSize.height
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
        
        self.title = "PROGRESSION_TITLE".localize
        
        self.tabBarController?.tabBar.items![0].title = "TABBAR_ITEM_TITLE_0".localize
        self.tabBarController?.tabBar.items![1].title = "TABBAR_ITEM_TITLE_1".localize
        self.tabBarController?.tabBar.items![2].title = "TABBAR_ITEM_TITLE_2".localize
        self.tabBarController?.tabBar.items![3].title = "TABBAR_ITEM_TITLE_3".localize
        self.tabBarController?.tabBar.items![4].title = "TABBAR_ITEM_TITLE_4".localize
        
        self.lblDisTitle.text = "DISCOVERY".localize
        self.lblCruTitle.text = "CRUISER".localize
        self.lblExpTitle.text = "EXPLORER".localize
        self.lblSpoTitle.text = "SPORT".localize
        self.lblProTitle.text = "PRO".localize
        self.lblMemTitle.text = "MEMBER".localize
        self.lblMemberShipTitle.text = "MEMBERSHIP".localize
        
    }
    
    //MARK: -  TableView DataSource - Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(tableView == self.tableView)
        {
            return self.arrDataEnrollment.count
        }
        else if(tableView == self.tableView2)
        {
            return self.arrDataProg1.count
        }
        else if(tableView == self.tableView3)
        {
            return self.arrDataProg2.count
        }
        else if(tableView == self.tableView4)
        {
            return self.arrDataProg3.count
        }
        else if(tableView == self.tableView5)
        {
            return self.arrDataProg4.count
        }
        else if(tableView == self.tableView6)
        {
            return 1
        }
        else
        {
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProgressionCell") as! ProgressionCell
        cell.selectionStyle = .none
        
        
        if(tableView == self.tableView)
        {
            let Dict = self.arrDataEnrollment[indexPath.row] as? NSMutableDictionary
            var type = Dict?.value(forKey: "type") as? String
            
            if(type == "progression_enrollment")
            {
                type = "Progression Enrollment"
            }
            else if(type == "progression_level_1")
            {
                type = "Progression Level 1"
            }
            else if(type == "progression_level_2")
            {
                type = "Progression Level 2"
            }
            else if(type == "progression_level_3")
            {
                type = "Progression Level 3"
            }
            else if(type == "progression_level_4")
            {
                type = "Progression Level 4"
            }
            else if(type == "discovery_lesson")
            {
                type = "Discovery Lesson"
            }
            else
            {
                type = "Progression"
            }
            
            let status = Dict?.value(forKey: "status") as? Int
            
            cell.lblProgType.text = "DISCOVERY_ENROLLMENT".localize
            cell.imgProgBook.isHidden = true
            
            if(status == 0)
            {
                cell.lblProgStatus.text = "PENDING".localize
                cell.lblProgStatus.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                cell.imgCell.isHidden = true
            }
            else if(status == 1)
            {
                cell.lblProgStatus.text = "COMPLETED".localize
                cell.lblProgStatus.textColor = #colorLiteral(red: 0.06274509804, green: 0.6392156863, blue: 0.2274509804, alpha: 1)
                cell.imgCell.isHidden = false
                cell.imgCell.image = UIImage(named: "Done")
            }
            else if(status == 2)
            {
                cell.lblProgStatus.text = "FAILED".localize
                cell.lblProgStatus.textColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
                cell.imgCell.isHidden = true
            }
            else if(status == 3)
            {
                cell.lblProgStatus.text = "Cancelled"
                cell.lblProgStatus.textColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
                cell.imgCell.isHidden = true
            }
            else
            {
                
            }
            cell.viewCell.addCornerRadius(10)
            cell.viewCell.layer.borderColor = #colorLiteral(red: 0.2784313725, green: 0.4549019608, blue: 0.5921568627, alpha: 1)
            cell.viewCell.layer.borderWidth = 2
        }
        else if(tableView == self.tableView2)
        {
            let Dict = self.arrDataProg1[indexPath.row] as? NSMutableDictionary
            var type = Dict?.value(forKey: "type") as? String
            
            if(type == "progression_enrollment")
            {
                type = "Progression Enrollment"
            }
            else if(type == "progression_level_1")
            {
                type = "Progression Level 1"
            }
            else if(type == "progression_level_2")
            {
                type = "Progression Level 2"
            }
            else if(type == "progression_level_3")
            {
                type = "Progression Level 3"
            }
            else if(type == "progression_level_4")
            {
                type = "Progression Level 4"
            }
            else
            {
                type = "Progression"
            }
            
            let status = Dict?.value(forKey: "status") as? Int
            cell.imgProg2Book.tintColor = #colorLiteral(red: 0.2784313725, green: 0.4549019608, blue: 0.5921568627, alpha: 1)
            cell.imgProg2Book.image = cell.imgProg2Book.image?.withRenderingMode(.alwaysTemplate)
            cell.lblProgType2.text = "CRUISER".localize
            //cell.lblProgType2.text = type!
            if(status == 0)
            {
                cell.lblProgStatus2.text = "PENDING".localize
                cell.lblProgStatus2.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                cell.imgCell2.isHidden = true
                cell.imgProg2Book.isHidden = false
            }
            else if(status == 1)
            {
                cell.lblProgStatus2.text = "COMPLETED".localize
                cell.lblProgStatus2.textColor = #colorLiteral(red: 0.06274509804, green: 0.6392156863, blue: 0.2274509804, alpha: 1)
                cell.imgCell2.isHidden = false
                cell.imgCell2.image = UIImage(named: "Done")
                cell.imgProg2Book.isHidden = true
            }
            else if(status == 2)
            {
                cell.lblProgStatus2.text = "FAILED".localize
                cell.lblProgStatus2.textColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
                cell.imgCell2.isHidden = true
                if(self.FlagProg1 == true){
                    cell.imgProg2Book.isHidden = true
                }
                else{
                    cell.imgProg2Book.isHidden = false
                }
                
            }
            else if(status == 3)
            {
                cell.lblProgStatus2.text = "Cancelled"
                cell.lblProgStatus2.textColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
                cell.imgCell2.isHidden = true
                if(self.FlagProg1 == true){
                    cell.imgProg2Book.isHidden = true
                }
                else{
                    cell.imgProg2Book.isHidden = false
                }
            }
            else
            {
                
            }
            
            if(self.FlagInitialProg1 == true)
            {
                let ID = Dict!["id"] as? Int ?? 12345
                let StrID = "\(ID)"
                let Status = Dict!["status"] as? Int
                if(StrID == "12345" && self.FlagPendingProg1 == true){
                    cell.imgProg2Book.isHidden = false
                }
                else if(StrID != "12345" && Status == 2){
                    cell.imgProg2Book.isHidden = true
                }
                else{
                    cell.imgProg2Book.isHidden = true
                    cell.lblProgStatus2.text = "Pending"
                }
                
            }
            else
            {
                let ID = Dict!["id"] as? Int ?? 12345
                let StrID = "\(ID)"
                let Status = Dict!["status"] as? Int
                if(StrID != "12345" && Status == 0){
                    cell.imgProg2Book.isHidden = true
                }
                else if(StrID != "12345" && Status == 2){
                    if(self.FlagProg1 == true || self.FlagPendingProg1 == true)
                    {
                        cell.imgProg2Book.isHidden = true
                        //cell.lblProgStatus2.text = "Pending"
                    }
                    else{
                        cell.imgProg2Book.isHidden = false
                    }
                    
                }
                else if(StrID != "12345" && Status == 3){
                    if(self.FlagProg1 == true || self.FlagPendingProg1 == true)
                    {
                        cell.imgProg2Book.isHidden = true
                     }
                    else{
                        cell.imgProg2Book.isHidden = false
                    }
                    
                }
                else{
                    cell.imgProg2Book.isHidden = true
                }
            }
            
            
            
            cell.viewCell2.addCornerRadius(10)
            cell.viewCell2.layer.borderColor = #colorLiteral(red: 0.2784313725, green: 0.4549019608, blue: 0.5921568627, alpha: 1)
            cell.viewCell2.layer.borderWidth = 2
        }
        else if(tableView == self.tableView3)
        {
            let Dict = self.arrDataProg2[indexPath.row] as? NSMutableDictionary
            var type = Dict?.value(forKey: "type") as? String
            
            if(type == "progression_enrollment")
            {
                type = "Progression Enrollment"
            }
            else if(type == "progression_level_1")
            {
                type = "Progression Level 1"
            }
            else if(type == "progression_level_2")
            {
                type = "Progression Level 2"
            }
            else if(type == "progression_level_3")
            {
                type = "Progression Level 3"
            }
            else if(type == "progression_level_4")
            {
                type = "Progression Level 4"
            }
            else
            {
                type = "Progression"
            }
            
            let status = Dict?.value(forKey: "status") as? Int
            
            cell.lblProgType3.text = "EXPLORER".localize
            cell.imgProg3Book.image = cell.imgProg3Book.image?.withRenderingMode(.alwaysTemplate)
            cell.imgProg3Book.tintColor = #colorLiteral(red: 0.2784313725, green: 0.4549019608, blue: 0.5921568627, alpha: 1)
            //cell.lblProgType3.text = type!
            if(status == 0)
            {
                cell.lblProgStatus3.text = "PENDING".localize
                cell.lblProgStatus3.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                cell.imgCell3.isHidden = true
                cell.imgProg3Book.isHidden = false
            }
            else if(status == 1)
            {
                cell.lblProgStatus3.text = "COMPLETED".localize
                cell.lblProgStatus3.textColor = #colorLiteral(red: 0.06274509804, green: 0.6392156863, blue: 0.2274509804, alpha: 1)
                cell.imgCell3.isHidden = false
                cell.imgProg3Book.isHidden = true
                cell.imgCell3.image = UIImage(named: "Done")
            }
            else if(status == 2)
            {
                cell.lblProgStatus3.text = "FAILED".localize
                cell.lblProgStatus3.textColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
                cell.imgCell3.isHidden = true
                if(self.FlagProg2 == true){
                    cell.imgProg3Book.isHidden = true
                }
                else{
                    cell.imgProg3Book.isHidden = false
                }
            }
            else if(status == 3)
            {
                cell.lblProgStatus3.text = "Cancelled"
                cell.lblProgStatus3.textColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
                cell.imgCell3.isHidden = true
                if(self.FlagProg2 == true){
                    cell.imgProg3Book.isHidden = true
                }
                else{
                    cell.imgProg3Book.isHidden = false
                }
            }
            else
            {
                
            }
            
            if(self.FlagInitialProg2 == true)
            {
                let ID = Dict!["id"] as? Int ?? 12345
                let StrID = "\(ID)"
                let Status = Dict!["status"] as? Int
                if(StrID == "12345" && self.FlagPendingProg2 == true){
                    cell.imgProg3Book.isHidden = false
                }
                else if(StrID != "12345" && Status == 2){
                    cell.imgProg3Book.isHidden = true
                }
                else{
                    cell.imgProg3Book.isHidden = true
                    cell.lblProgStatus3.text = "Pending"
                }
            }
            else{
                
                let ID = Dict!["id"] as? Int ?? 12345
                let StrID = "\(ID)"
                let Status = Dict!["status"] as? Int
                if(StrID != "12345" && Status == 0){
                    cell.imgProg3Book.isHidden = true
                }
                else if(StrID != "12345" && Status == 2){
                    if(self.FlagProg2 == true || self.FlagPendingProg2 == true)
                    {
                        cell.imgProg3Book.isHidden = true
                        //cell.lblProgStatus3.text = "Pending"
                    }
                    else{
                        cell.imgProg3Book.isHidden = false
                    }
                }
                else if(StrID != "12345" && Status == 3){
                    if(self.FlagProg2 == true || self.FlagPendingProg2 == true)
                    {
                        cell.imgProg3Book.isHidden = true
                    }
                    else{
                        cell.imgProg3Book.isHidden = false
                    }
                    
                }
                else{
                    cell.imgProg3Book.isHidden = true
                }
                
            }
            
            
            
            cell.viewCell3.addCornerRadius(10)
            cell.viewCell3.layer.borderColor = #colorLiteral(red: 0.2784313725, green: 0.4549019608, blue: 0.5921568627, alpha: 1)
            cell.viewCell3.layer.borderWidth = 2
        }
        else if(tableView == self.tableView4)
        {
            let Dict = self.arrDataProg3[indexPath.row] as? NSMutableDictionary
            var type = Dict?.value(forKey: "type") as? String
            
            if(type == "progression_enrollment")
            {
                type = "Progression Enrollment"
            }
            else if(type == "progression_level_1")
            {
                type = "Progression Level 1"
            }
            else if(type == "progression_level_2")
            {
                type = "Progression Level 2"
            }
            else if(type == "progression_level_3")
            {
                type = "Progression Level 3"
            }
            else if(type == "progression_level_4")
            {
                type = "Progression Level 4"
            }
            else
            {
                type = "Progression"
            }
            
            let status = Dict?.value(forKey: "status") as? Int
            
            cell.lblProgType4.text = "SPORT".localize
            cell.imgProg4Book.image = cell.imgProg4Book.image?.withRenderingMode(.alwaysTemplate)
            cell.imgProg4Book.tintColor = #colorLiteral(red: 0.2784313725, green: 0.4549019608, blue: 0.5921568627, alpha: 1)
            //cell.lblProgType4.text = type!
            if(status == 0)
            {
                cell.lblProgStatus4.text = "PENDING".localize
                cell.lblProgStatus4.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                cell.imgCell4.isHidden = true
                cell.imgProg4Book.isHidden = false
            }
            else if(status == 1)
            {
                cell.lblProgStatus4.text = "COMPLETED".localize
                cell.lblProgStatus4.textColor = #colorLiteral(red: 0.06274509804, green: 0.6392156863, blue: 0.2274509804, alpha: 1)
                cell.imgCell4.isHidden = false
                cell.imgCell4.image = UIImage(named: "Done")
                cell.imgProg4Book.isHidden = true
            }
            else if(status == 2)
            {
                cell.lblProgStatus4.text = "FAILED".localize
                cell.lblProgStatus4.textColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
                cell.imgCell4.isHidden = true
                if(self.FlagProg3 == true){
                    cell.imgProg4Book.isHidden = true
                }
                else{
                    cell.imgProg4Book.isHidden = false
                }
            }
            else if(status == 3)
            {
                cell.lblProgStatus4.text = "Cancelled"
                cell.lblProgStatus4.textColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
                cell.imgCell4.isHidden = true
                if(self.FlagProg3 == true){
                    cell.imgProg4Book.isHidden = true
                }
                else{
                    cell.imgProg4Book.isHidden = false
                }
            }
            else
            {
                
            }
            
            if(self.FlagInitialProg3 == true)
            {
                let ID = Dict!["id"] as? Int ?? 12345
                let Status = Dict!["status"] as? Int
                let StrID = "\(ID)"
                if(StrID == "12345" && self.FlagPendingProg3 == true){
                    cell.imgProg4Book.isHidden = false
                }
                else if(StrID != "12345" && Status == 2){
                    cell.imgProg4Book.isHidden = true
                }
                else{
                    cell.imgProg4Book.isHidden = true
                    cell.lblProgStatus4.text = "Pending"
                }
            }
            else{
                
                let ID = Dict!["id"] as? Int ?? 12345
                let StrID = "\(ID)"
                let Status = Dict!["status"] as? Int
                if(StrID != "12345" && Status == 0){
                    cell.imgProg4Book.isHidden = true
                }
                else if(StrID != "12345" && Status == 2){
                    if(self.FlagProg3 == true || self.FlagPendingProg3 == true)
                    {
                        cell.imgProg4Book.isHidden = true
                        //cell.lblProgStatus4.text = "Pending"
                    }
                    else{
                        cell.imgProg4Book.isHidden = false
                    }
                }
                else if(StrID != "12345" && Status == 3){
                    if(self.FlagProg3 == true || self.FlagPendingProg3 == true)
                    {
                        cell.imgProg4Book.isHidden = true
                    }
                    else{
                        cell.imgProg4Book.isHidden = false
                    }
                    
                }
                else{
                    cell.imgProg4Book.isHidden = true
                }
                
            }
            
            
            
            cell.viewCell4.addCornerRadius(10)
            cell.viewCell4.layer.borderColor = #colorLiteral(red: 0.2784313725, green: 0.4549019608, blue: 0.5921568627, alpha: 1)
            cell.viewCell4.layer.borderWidth = 2
        }
        else if(tableView == self.tableView5)
        {
            let Dict = self.arrDataProg4[indexPath.row] as? NSMutableDictionary
            var type = Dict?.value(forKey: "type") as? String
            
            if(type == "progression_enrollment")
            {
                type = "Progression Enrollment"
            }
            else if(type == "progression_level_1")
            {
                type = "Progression Level 1"
            }
            else if(type == "progression_level_2")
            {
                type = "Progression Level 2"
            }
            else if(type == "progression_level_3")
            {
                type = "Progression Level 3"
            }
            else if(type == "progression_level_4")
            {
                type = "Progression Level 4"
            }
            else
            {
                type = "Progression"
            }
            
            let status = Dict?.value(forKey: "status") as? Int
            
            cell.lblProgType5.text = "PRO".localize
            cell.imgProg5Book.image = cell.imgProg5Book.image?.withRenderingMode(.alwaysTemplate)
            cell.imgProg5Book.tintColor = #colorLiteral(red: 0.2784313725, green: 0.4549019608, blue: 0.5921568627, alpha: 1)
            //cell.lblProgType5.text = type!
            if(status == 0)
            {
                cell.lblProgStatus5.text = "PENDING".localize
                cell.lblProgStatus5.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                cell.imgCell5.isHidden = true
                cell.imgProg5Book.isHidden = false
            }
            else if(status == 1)
            {
                cell.lblProgStatus5.text = "COMPLETED".localize
                cell.lblProgStatus5.textColor = #colorLiteral(red: 0.06274509804, green: 0.6392156863, blue: 0.2274509804, alpha: 1)
                cell.imgCell5.isHidden = false
                cell.imgCell5.image = UIImage(named: "Done")
                cell.imgProg5Book.isHidden = true
            }
            else if(status == 2)
            {
                cell.lblProgStatus5.text = "FAILED".localize
                cell.lblProgStatus5.textColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
                cell.imgCell5.isHidden = true
                if(self.FlagProg3 == true){
                    cell.imgProg5Book.isHidden = true
                }
                else{
                    cell.imgProg5Book.isHidden = false
                }
            }
            else if(status == 3)
            {
                cell.lblProgStatus5.text = "Cancelled"
                cell.lblProgStatus5.textColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
                cell.imgCell5.isHidden = true
                if(self.FlagProg3 == true){
                    cell.imgProg5Book.isHidden = true
                }
                else{
                    cell.imgProg5Book.isHidden = false
                }
            }
            else
            {
                
            }
            
            if(self.FlagInitialProg4 == true)
            {
                let ID = Dict!["id"] as? Int ?? 12345
                let StrID = "\(ID)"
                let Status = Dict!["status"] as? Int
                if(StrID == "12345" && self.FlagPendingProg4 == true){
                    cell.imgProg5Book.isHidden = false
                }
                else if(StrID != "12345" && Status == 2){
                    cell.imgProg5Book.isHidden = true
                }
                else{
                    cell.imgProg5Book.isHidden = true
                    cell.lblProgStatus5.text = "Pending"
                }
                
            }
            else{
                
                let ID = Dict!["id"] as? Int ?? 12345
                let StrID = "\(ID)"
                let Status = Dict!["status"] as? Int
                if(StrID != "12345" && Status == 0){
                    cell.imgProg5Book.isHidden = true
                }
                else if(StrID != "12345" && Status == 2){
                    if(self.FlagProg4 == true  || self.FlagPendingProg4 == true)
                    {
                        cell.imgProg5Book.isHidden = true
                        //                        cell.lblProgStatus5.text = "Pending"
                    }
                    else{
                        cell.imgProg5Book.isHidden = false
                    }
                }
                else if(StrID != "12345" && Status == 3){
                    if(self.FlagProg4 == true || self.FlagPendingProg4 == true)
                    {
                        cell.imgProg5Book.isHidden = true
                    }
                    else{
                        cell.imgProg5Book.isHidden = false
                    }
                    
                }
                else{
                    cell.imgProg5Book.isHidden = true
                }
                
            }
            
            
            
            cell.viewCell5.addCornerRadius(10)
            cell.viewCell5.layer.borderColor = #colorLiteral(red: 0.2784313725, green: 0.4549019608, blue: 0.5921568627, alpha: 1)
            cell.viewCell5.layer.borderWidth = 2
        }
            
        else if(tableView == self.tableView6)
        {
          
            cell.viewCell6.addCornerRadius(10)
            cell.viewCell6.layer.borderColor = #colorLiteral(red: 0.2784313725, green: 0.4549019608, blue: 0.5921568627, alpha: 1)
            cell.viewCell6.layer.borderWidth = 2
        }
        else
        {
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(tableView == self.tableView)
        {
            let Dict = self.arrDataEnrollment[indexPath.row] as? NSMutableDictionary
            
            let DictInst = Dict?.value(forKeyPath: "instructor") as? NSMutableDictionary
            let strInst = DictInst?.value(forKeyPath: "name") as? String
            let CommentedBy = strInst
            let Comment = Dict?.value(forKey: "comment") as? String
            let Status = Dict?.value(forKey: "status") as? Int
            if(Status == 0)
            {
                print("Comment Not Available.")
            }
            else
            {
                if(CommentedBy == nil || Comment == nil)
                {
                    print("Comment Nil.")
                }
                else
                {
                    let popupVC = storyboard?.instantiateViewController(withIdentifier: "ProgressionPopup_VC") as! ProgressionPopup_VC
                    popupVC.Comment = Comment!
                    popupVC.CommentedBy = CommentedBy!
                    view.addSubview(popupVC.view)
                    addChild(popupVC)
                }
            }
        }
        else if(tableView == self.tableView2)
        {
            
            let Dict = self.arrDataProg1[indexPath.row] as? NSMutableDictionary
            
            
            let StatusProg1 = Dict!["status"] as? Int
            if(StatusProg1 == 0 || StatusProg1 == 2 || StatusProg1 == 3){
                if(self.FlagProg1 == true){
                    
                    let DictInst = Dict?.value(forKeyPath: "instructor") as? NSMutableDictionary
                    let strInst = DictInst?.value(forKeyPath: "name") as? String
                    let CommentedBy = strInst
                    let Comment = Dict?.value(forKey: "comment") as? String
                    let Status = Dict?.value(forKey: "status") as? Int
                    if(Status == 0)
                    {
                        print("Comment Not Available.")
                    }
                    else
                    {
                        if(CommentedBy == nil || Comment == nil)
                        {
                            print("Comment Nil.")
                        }
                        else
                        {
                            let popupVC = storyboard?.instantiateViewController(withIdentifier: "ProgressionPopup_VC") as! ProgressionPopup_VC
                            popupVC.Comment = Comment!
                            popupVC.CommentedBy = CommentedBy!
                            view.addSubview(popupVC.view)
                            addChild(popupVC)
                        }
                    }
                    
                }
                else{
                    
                    let ID = Dict!["id"] as? Int ?? 12345
                    let StrID = "\(ID)"
                    let Status = Dict!["status"] as? Int
                    
                    if(StrID != "12345" && Status == 0){
                        print("Status Pending")
                    }
                    else if (self.StatusProg1 == 0 &&  Status == 2){
                        print("Status Pending")
                    }
                    else
                    {
                        if(self.FlagInitialProg1 == true || Status == 2){
                            
                            self.tabBarController?.selectedIndex = 1
                            (self.tabBarController?.selectedViewController as! UINavigationController).popToRootViewController(animated: false)
                        }
                        else if(self.FlagInitialProg1 == true || Status == 3){
                            
                            self.tabBarController?.selectedIndex = 1
                            (self.tabBarController?.selectedViewController as! UINavigationController).popToRootViewController(animated: false)
                        }
                        else{
                            print("Prog Stage Booking Not Allowed")
                        }
                    }
                }
            }
                
            else{
                let DictInst = Dict?.value(forKeyPath: "instructor") as? NSMutableDictionary
                let strInst = DictInst?.value(forKeyPath: "name") as? String
                let CommentedBy = strInst
                let Comment = Dict?.value(forKey: "comment") as? String
                let Status = Dict?.value(forKey: "status") as? Int
                if(Status == 0)
                {
                    print("Comment Not Available.")
                }
                else
                {
                    if(CommentedBy == nil || Comment == nil)
                    {
                        print("Comment Nil.")
                    }
                    else
                    {
                        let popupVC = storyboard?.instantiateViewController(withIdentifier: "ProgressionPopup_VC") as! ProgressionPopup_VC
                        popupVC.Comment = Comment!
                        popupVC.CommentedBy = CommentedBy!
                        view.addSubview(popupVC.view)
                        addChild(popupVC)
                    }
                }
            }
            
            
            
        }
        else if(tableView == self.tableView3)
        {
            let Dict = self.arrDataProg2[indexPath.row] as? NSMutableDictionary
            
            let StatusProg1 = Dict!["status"] as? Int
            if(StatusProg1 == 0 || StatusProg1 == 2){
                if(self.FlagProg2 == true){
                    
                    let DictInst = Dict?.value(forKeyPath: "instructor") as? NSMutableDictionary
                    let strInst = DictInst?.value(forKeyPath: "name") as? String
                    let CommentedBy = strInst
                    let Comment = Dict?.value(forKey: "comment") as? String
                    let Status = Dict?.value(forKey: "status") as? Int
                    if(Status == 0)
                    {
                        print("Comment Not Available.")
                    }
                    else
                    {
                        if(CommentedBy == nil || Comment == nil)
                        {
                            print("Comment Nil")
                        }
                        else
                        {
                            let popupVC = storyboard?.instantiateViewController(withIdentifier: "ProgressionPopup_VC") as! ProgressionPopup_VC
                            popupVC.Comment = Comment!
                            popupVC.CommentedBy = CommentedBy!
                            view.addSubview(popupVC.view)
                            addChild(popupVC)
                        }
                    }
                    
                }
                else{
                    
                    let ID = Dict!["id"] as? Int ?? 12345
                    let StrID = "\(ID)"
                    let Status = Dict!["status"] as? Int
                    
                    if(StrID != "12345" && Status == 0){
                        print("Status Pending")
                    }
                    else if (self.StatusProg2 == 0 &&  Status == 2){
                        print("Status Pending")
                    }
                    else
                    {
                        if(self.FlagInitialProg2 == true || Status == 2){
                            
                            self.tabBarController?.selectedIndex = 1
                            (self.tabBarController?.selectedViewController as! UINavigationController).popToRootViewController(animated: false)
                        }
                        else if(self.FlagInitialProg2 == true || Status == 3){
                            
                            self.tabBarController?.selectedIndex = 1
                            (self.tabBarController?.selectedViewController as! UINavigationController).popToRootViewController(animated: false)
                        }
                        else{
                            print("Prog Stage Booking Not Allowed")
                        }
                    }
                }
            }
                
            else{
                let DictInst = Dict?.value(forKeyPath: "instructor") as? NSMutableDictionary
                let strInst = DictInst?.value(forKeyPath: "name") as? String
                let CommentedBy = strInst
                let Comment = Dict?.value(forKey: "comment") as? String
                let Status = Dict?.value(forKey: "status") as? Int
                if(Status == 0)
                {
                    print("Comment Not Available.")
                }
                else
                {
                    if(CommentedBy == nil || Comment == nil)
                    {
                        print("Comment Nil")
                    }
                    else
                    {
                        let popupVC = storyboard?.instantiateViewController(withIdentifier: "ProgressionPopup_VC") as! ProgressionPopup_VC
                        popupVC.Comment = Comment!
                        popupVC.CommentedBy = CommentedBy!
                        view.addSubview(popupVC.view)
                        addChild(popupVC)
                    }
                }
            }
            
        }
        else if(tableView == self.tableView4)
        {
            let Dict = self.arrDataProg3[indexPath.row] as? NSMutableDictionary
            
            let StatusProg1 = Dict!["status"] as? Int
            if(StatusProg1 == 0 || StatusProg1 == 2){
                
                if(self.FlagProg3 == true){
                    
                    let DictInst = Dict?.value(forKeyPath: "instructor") as? NSMutableDictionary
                    let strInst = DictInst?.value(forKeyPath: "name") as? String
                    let CommentedBy = strInst
                    let Comment = Dict?.value(forKey: "comment") as? String
                    let Status = Dict?.value(forKey: "status") as? Int
                    if(Status == 0)
                    {
                        print("Comment Not Available.")
                    }
                    else
                    {
                        if(CommentedBy == nil || Comment == nil)
                        {
                            print("Comment Nil.")
                        }
                        else
                        {
                            let popupVC = storyboard?.instantiateViewController(withIdentifier: "ProgressionPopup_VC") as! ProgressionPopup_VC
                            popupVC.Comment = Comment!
                            popupVC.CommentedBy = CommentedBy!
                            view.addSubview(popupVC.view)
                            addChild(popupVC)
                        }
                    }
                    
                    
                }
                else{
                    
                    let ID = Dict!["id"] as? Int ?? 12345
                    let StrID = "\(ID)"
                    let Status = Dict!["status"] as? Int
                    
                    if(StrID != "12345" && Status == 0){
                        print("Status Pending")
                    }
                    else if (self.StatusProg3 == 0 &&  Status == 2){
                        print("Status Pending")
                    }
                    else
                    {
                        if(self.FlagInitialProg3 == true || Status == 2){
                            
                            self.tabBarController?.selectedIndex = 1
                            (self.tabBarController?.selectedViewController as! UINavigationController).popToRootViewController(animated: false)
                        }
                        else if(self.FlagInitialProg3 == true || Status == 3){
                            
                            self.tabBarController?.selectedIndex = 1
                            (self.tabBarController?.selectedViewController as! UINavigationController).popToRootViewController(animated: false)
                        }
                        else{
                            print("Prog Stage Booking Not Allowed")
                        }
                    }
                }
            }
                
            else{
                let DictInst = Dict?.value(forKeyPath: "instructor") as? NSMutableDictionary
                let strInst = DictInst?.value(forKeyPath: "name") as? String
                let CommentedBy = strInst
                let Comment = Dict?.value(forKey: "comment") as? String
                let Status = Dict?.value(forKey: "status") as? Int
                if(Status == 0)
                {
                    print("Comment Not Available.")
                }
                else
                {
                    if(CommentedBy == nil || Comment == nil)
                    {
                        print("Comment Nil.")
                    }
                    else
                    {
                        let popupVC = storyboard?.instantiateViewController(withIdentifier: "ProgressionPopup_VC") as! ProgressionPopup_VC
                        popupVC.Comment = Comment!
                        popupVC.CommentedBy = CommentedBy!
                        view.addSubview(popupVC.view)
                        addChild(popupVC)
                    }
                }
            }
            
        }
        else if(tableView == self.tableView5)
        {
            let Dict = self.arrDataProg4[indexPath.row] as? NSMutableDictionary
            
            let StatusProg1 = Dict!["status"] as? Int
            if(StatusProg1 == 0 || StatusProg1 == 2){
                
                if(self.FlagProg4 == true){
                    
                    let DictInst = Dict?.value(forKeyPath: "instructor") as? NSMutableDictionary
                    let strInst = DictInst?.value(forKeyPath: "name") as? String
                    let CommentedBy = strInst
                    let Comment = Dict?.value(forKey: "comment") as? String
                    let Status = Dict?.value(forKey: "status") as? Int
                    if(Status == 0)
                    {
                        print("Comment Not Available.")
                    }
                    else
                    {
                        if(CommentedBy == nil || Comment == nil)
                        {
                            print("Comment Nil.")
                        }
                        else
                        {
                            let popupVC = storyboard?.instantiateViewController(withIdentifier: "ProgressionPopup_VC") as! ProgressionPopup_VC
                            popupVC.Comment = Comment!
                            popupVC.CommentedBy = CommentedBy!
                            view.addSubview(popupVC.view)
                            addChild(popupVC)
                        }
                    }
                    
                }
                else{
                    
                    let ID = Dict!["id"] as? Int ?? 12345
                    let StrID = "\(ID)"
                    let Status = Dict!["status"] as? Int
                    
                    if(StrID != "12345" && Status == 0){
                        print("Status Pending")
                    }
                    else if (self.StatusProg4 == 0 &&  Status == 2){
                        print("Status Pending")
                    }
                    else
                    {
                        if(self.FlagInitialProg4 == true || Status == 2){
                            
                            self.tabBarController?.selectedIndex = 1
                            (self.tabBarController?.selectedViewController as! UINavigationController).popToRootViewController(animated: false)
                        }
                        else if(self.FlagInitialProg4 == true || Status == 3){
                            
                            self.tabBarController?.selectedIndex = 1
                            (self.tabBarController?.selectedViewController as! UINavigationController).popToRootViewController(animated: false)
                        }
                        else{
                            print("Prog Stage Booking Not Allowed")
                        }
                    }
                }
            }
                
            else{
                let DictInst = Dict?.value(forKeyPath: "instructor") as? NSMutableDictionary
                let strInst = DictInst?.value(forKeyPath: "name") as? String
                let CommentedBy = strInst
                let Comment = Dict?.value(forKey: "comment") as? String
                let Status = Dict?.value(forKey: "status") as? Int
                if(Status == 0)
                {
                    print("Comment Not Available.")
                }
                else
                {
                    if(CommentedBy == nil || Comment == nil)
                    {
                        print("Comment Nil.")
                    }
                    else
                    {
                        let popupVC = storyboard?.instantiateViewController(withIdentifier: "ProgressionPopup_VC") as! ProgressionPopup_VC
                        popupVC.Comment = Comment!
                        popupVC.CommentedBy = CommentedBy!
                        view.addSubview(popupVC.view)
                        addChild(popupVC)
                    }
                }
            }
            
        }
        else if(tableView == self.tableView6)
        {
            
        }
        else
        {
            print("Extra Data")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(tableView == self.tableView6)
        {
            return 100
        }
        else
        {
            return 80
        }
        
        //UITableView.automaticDimension
    }
    
    
    //MARK: -  API Calls
    func Get_ProgressionData_API() {
        
        let url = API.BASE_URL + API.GET_PROGRESSION_DATA
        
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
                        print(dict!)
                        let status = dict?.value(forKeyPath: "status") as? String ?? ""
                        if(status == "error")
                        {
                            displayAlert(APPNAME, andMessage: (dict?.value(forKeyPath: "message") as? String)!)
                        }
                        else
                        {
                            let dictData = dict?.value(forKeyPath: "data.progression_history") as? NSMutableDictionary
                            
                            
                            
                            self.arrDataEnrollment = (dictData?.value(forKey: "discovery_lesson") as? NSMutableArray)!
                            //
                            
                            self.arrDataProg1 = (dictData?.value(forKey: "cruiser") as? NSMutableArray)!
                            if(self.arrDataProg1.count > 1){
                                for DictArr  in self.arrDataProg1
                                {
                                    let Dictt = DictArr as? NSMutableDictionary
                                    self.StatusProg1 = (Dictt!["status"] as? Int)!
                                    if(self.StatusProg1 == 1){
                                        self.FlagProg1 = true
                                    }
                                    else{
                                        self.FlagProg1 = false
                                    }
                                    
                                    if(self.StatusProg1 == 0){
                                        self.FlagPendingProg1 = true
                                    }
                                    else{
                                        self.FlagPendingProg1 = false
                                    }
                                }
                            }
                            else
                            {
                                let DictProg1 = self.arrDataProg1[0] as? NSMutableDictionary
                                self.StatusProg1 = (DictProg1!["status"] as? Int)!
                                if(self.StatusProg1 == 1){
                                    self.FlagProg1 = true
                                }
                                else{
                                    self.FlagProg1 = false
                                }
                                
                                if(self.StatusProg1 == 0){
                                    self.FlagPendingProg1 = true
                                }
                                else{
                                    self.FlagPendingProg1 = false
                                }
                            }
                            
                            
                            self.arrDataProg2 = (dictData?.value(forKey: "explorer") as? NSMutableArray)!
                            if(self.arrDataProg2.count > 1){
                                for DictArr  in self.arrDataProg2
                                {
                                    let Dictt = DictArr as? NSMutableDictionary
                                    self.StatusProg2 = (Dictt!["status"] as? Int)!
                                    if(self.StatusProg2 == 1){
                                        self.FlagProg2 = true
                                    }
                                    else{
                                        self.FlagProg2 = false
                                    }
                                    
                                    if(self.StatusProg2 == 0){
                                        self.FlagPendingProg2 = true
                                    }
                                    else{
                                        self.FlagPendingProg2 = false
                                    }
                                }
                            }
                            else
                            {
                                let DictProg2 = self.arrDataProg2[0] as? NSMutableDictionary
                                self.StatusProg2 = (DictProg2!["status"] as? Int)!
                                if(self.StatusProg2 == 1){
                                    self.FlagProg2 = true
                                }
                                else{
                                    self.FlagProg2 = false
                                }
                                
                                if(self.StatusProg2 == 0){
                                    self.FlagPendingProg2 = true
                                }
                                else{
                                    self.FlagPendingProg2 = false
                                }
                            }
                            
                            
                            
                            self.arrDataProg3 = (dictData?.value(forKey: "sport") as? NSMutableArray)!
                            if(self.arrDataProg3.count > 1){
                                for DictArr  in self.arrDataProg3
                                {
                                    let Dictt = DictArr as? NSMutableDictionary
                                    self.StatusProg3 = (Dictt!["status"] as? Int)!
                                    if(self.StatusProg3 == 1){
                                        self.FlagProg3 = true
                                    }
                                    else{
                                        self.FlagProg3 = false
                                    }
                                    
                                    if(self.StatusProg3 == 0){
                                        self.FlagPendingProg3 = true
                                    }
                                    else{
                                        self.FlagPendingProg3 = false
                                    }
                                }
                            }
                            else
                            {
                                let DictProg3 = self.arrDataProg3[0] as? NSMutableDictionary
                                self.StatusProg3 = (DictProg3!["status"] as? Int)!
                                if(self.StatusProg3 == 1){
                                    self.FlagProg3 = true
                                }
                                else{
                                    self.FlagProg3 = false
                                }
                                
                                if(self.StatusProg3 == 0){
                                    self.FlagPendingProg3 = true
                                }
                                else{
                                    self.FlagPendingProg3 = false
                                }
                            }
                            
                            
                            
                            self.arrDataProg4 = (dictData?.value(forKey: "pro") as? NSMutableArray)!
                            if(self.arrDataProg4.count > 1){
                                for DictArr  in self.arrDataProg4
                                {
                                    let Dictt = DictArr as? NSMutableDictionary
                                    self.StatusProg4 = (Dictt!["status"] as? Int)!
                                    if(self.StatusProg4 == 1){
                                        self.FlagProg4 = true
                                    }
                                    else{
                                        self.FlagProg4 = false
                                    }
                                    
                                    if(self.StatusProg4 == 0){
                                        self.FlagPendingProg4 = true
                                    }
                                    else{
                                        self.FlagPendingProg4 = false
                                    }
                                }
                            }
                            else
                            {
                                let DictProg4 = self.arrDataProg4[0] as? NSMutableDictionary
                                self.StatusProg4 = (DictProg4!["status"] as? Int)!
                                if(self.StatusProg4 == 1){
                                    self.FlagProg4 = true
                                }
                                else{
                                    self.FlagProg4 = false
                                }
                                
                                if(self.StatusProg4 == 0){
                                    self.FlagPendingProg4 = true
                                }
                                else{
                                    self.FlagPendingProg4 = false
                                }
                            }
                            
                            // Display all table
                            
                            self.tableView.reloadData()
                            self.tableViewHeight.constant = CGFloat(self.arrDataEnrollment.count * 80)
                            
                            self.tableView2.reloadData()
                            self.tableViewHeight2.constant = CGFloat(self.arrDataProg1.count * 80)
                            
                            self.tableView3.reloadData()
                            self.tableViewHeight3.constant = CGFloat(self.arrDataProg2.count * 80)
                            
                            self.tableView4.reloadData()
                            self.tableViewHeight4.constant = CGFloat(self.arrDataProg3.count * 80)
                            
                            self.tableView5.reloadData()
                            self.tableViewHeight5.constant = CGFloat(self.arrDataProg4.count * 80)
                            
                            if(self.StatusProg1 == 0){
                                
                                if(self.StatusProg2 == 0 && self.StatusProg3 == 0 && self.StatusProg4 == 0)
                                {
                                    self.FlagInitialProg1 = true
                                }
                                else{
                                    self.FlagInitialProg1 = false
                                }
                            }
                            else
                            {
                                self.FlagInitialProg1 = false
                            }
                            
                            
                            if(self.StatusProg2 == 0){
                                
                                if(self.StatusProg1 == 1 && self.StatusProg3 == 0 && self.StatusProg4 == 0)
                                {
                                    self.FlagInitialProg2 = true
                                }
                                else{
                                    self.FlagInitialProg2 = false
                                }
                            }
                            else
                            {
                                self.FlagInitialProg2 = false
                            }
                            
                            
                            if(self.StatusProg3 == 0){
                                
                                if(self.StatusProg1 == 1 && self.StatusProg2 == 1 && self.StatusProg4 == 0)
                                {
                                    self.FlagInitialProg3 = true
                                }
                                else{
                                    self.FlagInitialProg3 = false
                                }
                            }
                            else
                            {
                                self.FlagInitialProg3 = false
                            }
                            
                            
                            if(self.StatusProg4 == 0){
                                
                                if(self.StatusProg1 == 1 && self.StatusProg2 == 1 && self.StatusProg3 == 1)
                                {
                                    self.FlagInitialProg4 = true
                                }
                                else{
                                    self.FlagInitialProg4 = false
                                }
                            }
                            else
                            {
                                self.FlagInitialProg4 = false
                            }
                            
                            
                            // Old Code
                            
                            //                            if(self.StatusProg1 == 0){
                            //
                            //                                if(self.StatusProg2 == 0 && self.StatusProg3 == 0 && self.StatusProg4 == 0)
                            //                                {
                            //                                    self.tableView2.reloadData()
                            //                                    self.tableViewHeight2.constant = CGFloat(self.arrDataProg1.count * 80)
                            //
                            //                                    self.viewCruiser.isHidden = false
                            //                                    self.lblCruiser.isHidden = false
                            //                                    self.viewCruiserHeight.constant = 40
                            //                                }
                            //                                else
                            //                                {
                            //                                    self.tableView2.reloadData()
                            //                                    self.tableViewHeight2.constant = 0
                            //
                            //                                    self.viewCruiser.isHidden = true
                            //                                    self.lblCruiser.isHidden = true
                            //                                    self.viewCruiserHeight.constant = 0
                            //                                }
                            //                            }
                            //                            else
                            //                            {
                            //                                self.tableView2.reloadData()
                            //                                self.tableViewHeight2.constant = CGFloat(self.arrDataProg1.count * 80)
                            //
                            //                                self.viewCruiser.isHidden = false
                            //                                self.lblCruiser.isHidden = false
                            //                                self.viewCruiserHeight.constant = 40
                            //                            }
                            //
                            //
                            //
                            //
                            //
                            //
                            //                            if(self.StatusProg2 == 0){
                            //                                if(self.StatusProg1 == 1 && self.StatusProg3 == 0 && self.StatusProg4 == 0)
                            ////                                {
                            //                                    self.tableView3.reloadData()
                            //                                    self.tableViewHeight3.constant = CGFloat(self.arrDataProg2.count * 80)
                            //
                            //                                    self.viewExplorer.isHidden = false
                            //                                    self.lblExplorer.isHidden = false
                            //                                    self.viewExplorerHeight.constant = 40
                            //                                }
                            //                                else
                            //                                {
                            //                                    self.tableView3.reloadData()
                            //                                    self.tableViewHeight3.constant = 0
                            //
                            //                                    self.viewExplorer.isHidden = true
                            //                                    self.lblExplorer.isHidden = true
                            //                                    self.viewExplorerHeight.constant = 0
                            //                                }
                            //                            }
                            //                            else
                            //                            {
                            //                                self.tableView3.reloadData()
                            //                                self.tableViewHeight3.constant = CGFloat(self.arrDataProg2.count * 80)
                            //
                            //                                self.viewExplorer.isHidden = false
                            //                                self.lblExplorer.isHidden = false
                            //                                self.viewExplorerHeight.constant = 40
                            //                            }
                            //
                            //
                            //
                            //
                            //                            if(self.StatusProg3 == 0){
                            //                                if(self.StatusProg1 == 1 && self.StatusProg2 == 1 && self.StatusProg4 == 0)
                            //                                {
                            //                                    self.tableView4.reloadData()
                            //                                    self.tableViewHeight4.constant = CGFloat(self.arrDataProg3.count * 80)
                            //
                            //                                    self.viewSport.isHidden = false
                            //                                    self.lblSport.isHidden = false
                            //                                    self.viewSportHeight.constant = 40
                            //                                }
                            //                                else
                            //                                {
                            //                                    self.tableView4.reloadData()
                            //                                    self.tableViewHeight4.constant = 0
                            //
                            //                                    self.viewSport.isHidden = true
                            //                                    self.lblSport.isHidden = true
                            //                                    self.viewSportHeight.constant = 0
                            //                                }
                            //                            }
                            //                            else
                            //                            {
                            //                                self.tableView4.reloadData()
                            //                                self.tableViewHeight4.constant = CGFloat(self.arrDataProg3.count * 80)
                            //
                            //                                self.viewSport.isHidden = false
                            //                                self.lblSport.isHidden = false
                            //                                self.viewSportHeight.constant = 40
                            //                            }
                            //
                            //
                            //
                            //
                            //                            if(self.StatusProg4 == 0){
                            //                                if(self.StatusProg1 == 1 && self.StatusProg2 == 1 && self.StatusProg3 == 1)
                            //                                {
                            //                                    self.tableView5.reloadData()
                            //                                    self.tableViewHeight5.constant = CGFloat(self.arrDataProg4.count * 80)
                            //
                            //                                    self.viewPro.isHidden = false
                            //                                    self.lblPro.isHidden = false
                            //                                    self.viewProHeight.constant = 40
                            //                                }
                            //                                else
                            //                                {
                            //                                    self.tableView5.reloadData()
                            //                                    self.tableViewHeight5.constant = 0
                            //
                            //                                    self.viewPro.isHidden = true
                            //                                    self.lblPro.isHidden = true
                            //                                    self.viewProHeight.constant = 0
                            //                                }
                            //                            }
                            //                            else
                            //                            {
                            //                                self.tableView5.reloadData()
                            //                                self.tableViewHeight5.constant = CGFloat(self.arrDataProg4.count * 80)
                            //
                            //                                self.viewPro.isHidden = false
                            //                                self.lblPro.isHidden = false
                            //                                self.viewProHeight.constant = 40
                            //                            }
                            
                            
                            self.view.updateConstraintsIfNeeded()
                            
                            let DictCert = dict?.value(forKeyPath: "data.certification") as? NSMutableDictionary ?? [:]
                            if(DictCert.count == 0)
                            {
                                print("Not Cerified yet.")
                                self.viewMember.isHidden = true
                                self.viewMemberHeader.isHidden = true
                                self.lblMember.isHidden = true
                                self.lblMemTitle.isHidden = true
                                self.lblMemberStatus.isHidden = true
                                self.imgMember.isHidden = true
                                self.viewMemberHeight.constant = 0
                                
                                
                            }
                            else
                            {
                                
                                self.viewMember.isHidden = false
                                self.viewMemberHeader.isHidden = false
                                self.lblMember.isHidden = false
                                self.lblMemTitle.isHidden = false
                                self.lblMemberStatus.isHidden = false
                                self.imgMember.isHidden = false
                                self.viewMemberHeight.constant = 40
                                
                                self.lblMemberStatus.text = "CONGRATULATIONS_MEMBER".localize
                                self.lblMemberStatus.textColor = #colorLiteral(red: 0.06274509804, green: 0.6392156863, blue: 0.2274509804, alpha: 1)
                                self.imgMember.image = UIImage(named: "Done")
                                
                                //                                let strCertDate = DictCert.value(forKeyPath: "certificate_date") as? String
                                //
                                //                                let CertBy = DictCert.value(forKeyPath: "certificate_by") as? NSMutableDictionary
                                //                                let strCertBy = CertBy?.value(forKeyPath: "name") as? String
                                
                                //                                let Msg = "YOU_RE_NOW_CERTI_BY".localize + " \n " + strCertBy! + "\n" + "ON_DATE".localize + strCertDate!
                                //
                                let Msg = "You are now Certified as a Member"
                                
                                let alert = UIAlertController(title: "CONGRATULATIONS".localize, message: Msg, preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "OK".localize, style: .default, handler: {(status) in
                                    
                                }))
                                self.present(alert, animated: true, completion: nil)
                            }
                            
                            self.FETCH_MEMBERSHIP()
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
    
    func FETCH_MEMBERSHIP() {
        
        let url = API.BASE_URL + API.FETCH_MEMBERSHIP
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
                            let dictData = dict?.value(forKey: "data") as? NSMutableDictionary
                            let DictMemberData = dictData?.value(forKey: "membership") as? NSMutableDictionary ?? [:]
                            
                            if(DictMemberData.count == 0){
                                print("Not a member")
                                
                                self.lblMemberShipHeader.isHidden = true
                                self.viewMemberShip.isHidden = true
                                self.viewMembershipHeight.constant = 0
                                self.tableViewHeight6.constant = 0
                                
                            }
                            else
                            {
                                print("member")

                                self.lblMemberShipHeader.isHidden = false
                                self.viewMemberShip.isHidden = false
                                self.viewMemberHeight.constant = 40
                                
                                self.tableView6.reloadData()
                                self.tableViewHeight6.constant = 100
                                
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
}


