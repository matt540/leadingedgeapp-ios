//
//  SideMenu_VC.swift
//  Surf Board
//
//  Created by eSparkBiz-1 on 03/12/19.
//  Copyright © 2019 eSparkBiz. All rights reserved.
//

import UIKit
import SDWebImage

class SideMenu_VC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    //MARK:- IBOUTLET AND VARIABLES
    @IBOutlet var viewBottom: UIView!
    @IBOutlet var viewTop: UIView!
    @IBOutlet var tableview:UITableView!
    @IBOutlet var btnLogout:UIButton!
    @IBOutlet var imgProfile: UIImageView!
    @IBOutlet var lblName: UILabel!
    var indexPath:Int!
    var arrMenu:[String]!
    var arrImages = Array<UIImage>()
    
    //var dGlocale = DGLocalization()
    
    //MARK:- LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.tableview.separatorStyle = .none
        self.btnLogout.addCornerRadius(5)
        
        imgProfile.addCornerRadius(imgProfile.frame.size.height/2)
        self.imgProfile.layer.masksToBounds = false
        self.imgProfile.contentMode = .scaleAspectFill
        
        if(AppPrefs.shared.isUserLogin() == true)
        {
            self.lblName.text = AppPrefs.shared.getUserName()
            self.imgProfile.downloaded(from: AppPrefs.shared.getUserProfile())
        }
        else
        {
            self.lblName.text = "Test User"
            self.imgProfile.image = UIImage(named: "Register_Icon.png")
        }
        
        
        arrMenu = ["Dashboard","Location Finder","My Upcoming Sessions","Videos","Share the app","My Account","Chat","Buy a Board","Membership","Terms of Use and Privacy Policy","About"]
        
        arrImages = [UIImage(named: "Dashboard"),UIImage(named: "Search"),UIImage(named: "Calender"),UIImage(named: "Play"),UIImage(named: "Share"),UIImage(named: "Setting"),UIImage(named: "Chat"),UIImage(named: "UserImage_Blue"),UIImage(named: "Member"),UIImage(named: "Privacy"),UIImage(named: "About")] as! [UIImage]
        
        tableview.tableFooterView = UIView()
        tableview.separatorStyle = .none
        tableview.reloadData()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.imgProfile.layer.masksToBounds = true
        self.imgProfile.contentMode = .scaleAspectFill
        
        if(AppPrefs.shared.isUserLogin() == true)
        {
            self.lblName.text = AppPrefs.shared.getUserName()
            self.imgProfile.downloaded(from: AppPrefs.shared.getUserProfile())
        }
        tableview.reloadData()
    }
    
    //MARK:- BUTTON ACTION
    @IBAction func btnLogoutAction(_ sender: Any){
        
        //Clear User Data
        AppPrefs.shared.setIsUserLogin(isUserLogin: false)
        AppPrefs.shared.removeUserId()
        AppPrefs.shared.removeUserName()
        AppPrefs.shared.removeUserProfile()
        AppPrefs.shared.setIsUserRememberLogin(isUserLogin: false)
        
        UserDefaults.standard.removeObject(forKey: "UserAllData")
        UserDefaults.standard.removeObject(forKey: "UserPrivacyACK")
        
        UserDefaults.standard.synchronize()
        
        goToMainScreen()
    }
    
    @objc func goToMainScreen() {
        
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "Register_VC")  as! Register_VC
        self.navigationController?.pushViewController(nextVC, animated: false)
        
    }
    
    //MARK:- TABLEVIEW DATASOURCE AND DELEGATE
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrMenu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuCell") as! SideMenuCell
        cell.lblMenuTitle.text = arrMenu[indexPath.row]
        cell.imgMenu.image = arrImages[indexPath.row]
        
        if self.indexPath == indexPath.item
        {
            cell.imgMenu.image = cell.imgMenu.image?.withRenderingMode(.alwaysTemplate)
            cell.imgMenu.tintColor = .white
            cell.contentView.backgroundColor = Color.APP_THEME_COLOR
            cell.lblMenuTitle.textColor = .white
        }
        else
        {
            cell.imgMenu.image = cell.imgMenu.image?.withRenderingMode(.alwaysTemplate)
            cell.imgMenu.tintColor = .black
            cell.contentView.backgroundColor = .clear
            cell.lblMenuTitle.textColor = .black
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        slideMenuController()?.closeLeft()
        
        let navVC = slideMenuController()?.mainViewController as! UINavigationController
        self.indexPath = indexPath.item
        
        if indexPath.row == 0 {
            
        }
        else if indexPath.row == 1 {
            
            let nextNavVc = Location_VC.instantiate(fromAppStoryboard: .Main)
            nextNavVc.isFromMenu = true
            navVC.pushViewController(nextNavVc, animated: true)
        }
        else if indexPath.row == 2 {
            let nextNavVc = self.storyboard!.instantiateViewController(withIdentifier: "Calender_VC") as! Calender_VC
            nextNavVc.isFromMenu = true
            navVC.pushViewController(nextNavVc, animated: true)
        }
        else if indexPath.row == 3 {
            
            let nextNavVc = self.storyboard!.instantiateViewController(withIdentifier: "VideoList_VC") as! VideoList_VC
            navVC.pushViewController(nextNavVc, animated: true)
            
        }
        else if indexPath.row == 4 {
            
            self.ShareAPP()
            
        }
        else if indexPath.row == 5 {
            
            let nextNavVc = self.storyboard!.instantiateViewController(withIdentifier: "MyAccount_VC") as! MyAccount_VC
            nextNavVc.isFromMenu = true
            navVC.pushViewController(nextNavVc, animated: true)
            
        }
        else if indexPath.row == 6 {
            
            let nextNavVc = self.storyboard!.instantiateViewController(withIdentifier: "ChatUserList_VC") as! ChatUserList_VC
            navVC.pushViewController(nextNavVc, animated: true)
            
        }
        else if indexPath.row == 7 {
            
            self.openBuyBoard()
            
        }
        else if indexPath.row == 8 {
            
            let nextNavVc = self.storyboard!.instantiateViewController(withIdentifier: "Membership_VC") as! Membership_VC
            navVC.pushViewController(nextNavVc, animated: true)
            
        }
        else if indexPath.row == 9 {
            
            guard let url = URL(string: "https://linkaffiliateapp.com/images/Link%20Program%20Terms%20of%20Use%20and%20Privacy%20Policy.pdf") else {
                return
            }
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            else
            {
                print("URL Can't Open.")
                displayAlert(APPNAME, andMessage: "URL Can't Open.")
            }
            
        }
        else if indexPath.row == 10 {
            
            let nextNavVc = self.storyboard!.instantiateViewController(withIdentifier: "Welcome_VC") as! Welcome_VC
            nextNavVc.isFromMenu = true
            navVC.pushViewController(nextNavVc, animated: true)
            
        }
        else
        {
            
        }
        
        self.tableview.reloadData()
    }
    
    func openBuyBoard(){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "BuyBoard"), object: nil, userInfo: nil)
    }
    
    //MARK:- ShareAPP Method
    func ShareAPP()
    {
        let theMessage = "https://apps.apple.com/in/app/link-affiliate/id1491907745"
        let items = [theMessage]
        
        let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        activityViewController.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook,UIActivity.ActivityType.mail,UIActivity.ActivityType.saveToCameraRoll]
        
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    //MARK:- ChangeLang Method
    func ChangeLang()
    {
        let selectLanguage = APPNAME//"languageButton".localize
        let msg = "Select Language"//"languageMsg".localize
        
        let moviePicker = UIAlertController(title: selectLanguage, message: msg, preferredStyle: .actionSheet)
        var language = ["English","Spanish","German","French","Italian"]
        
        let imageDataDict:[String: String] = ["image": "image"]
        
        for index in 0..<language.count {
            
            let normalAction = UIAlertAction(title: language[index], style: UIAlertAction.Style.default, handler: { (action: UIAlertAction!) -> Void in
                
                if index == 0 {
                    
                    let English = Locale1().initWithLanguageCode(languageCode: "en", countryCode: "us", name: "United Kingdom")
                    DGLocalization.sharedInstance.setLanguage(withCode:English)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LanguageChange"), object: nil, userInfo: imageDataDict)
                }
                if index == 1 {
                    
                    let Spanish = Locale1().initWithLanguageCode(languageCode: "es", countryCode: "es", name: "Spain")
                    DGLocalization.sharedInstance.setLanguage(withCode:Spanish)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LanguageChange"), object: nil, userInfo: imageDataDict)
                }
                if index == 2 {
                    
                    let German = Locale1().initWithLanguageCode(languageCode: "de", countryCode: "de", name: "Germany")
                    DGLocalization.sharedInstance.setLanguage(withCode:German)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LanguageChange"), object: nil, userInfo: imageDataDict)
                }
                if index == 3 {
                    
                    let French = Locale1().initWithLanguageCode(languageCode: "fr", countryCode: "fr", name: "France")
                    DGLocalization.sharedInstance.setLanguage(withCode:French)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LanguageChange"), object: nil, userInfo: imageDataDict)
                }
                if index == 4 {
                    
                    let Italian = Locale1().initWithLanguageCode(languageCode: "it", countryCode: "it", name: "Italy")
                    DGLocalization.sharedInstance.setLanguage(withCode:Italian)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LanguageChange"), object: nil, userInfo: imageDataDict)
                }
                
            })
            
            moviePicker.addAction(normalAction)
            moviePicker.view.tintColor = #colorLiteral(red: 0.2784313725, green: 0.4549019608, blue: 0.5921568627, alpha: 1)
        }
        
        let closeAction = UIAlertAction(title:"Close".localize, style: UIAlertAction.Style.cancel) { (action: UIAlertAction!) -> Void in
        }
        
        moviePicker.addAction(closeAction)
        self.present(moviePicker, animated: true, completion: nil)
    }
}

//MARK:-DGLoclalization Delegate
extension SideMenu_VC:DGLocalizationDelegate {
    func languageDidChanged(to: (String)) {
        print("language changed to \(to)")
    }
}
