//
//  AppDelegate.swift
//  SurfBoard
//
//  Created by esparkbiz on 12/5/19.
//  Copyright © 2019 esparkbiz. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift
import CoreLocation
import Stripe
import UserNotifications
import Firebase
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate, UNUserNotificationCenterDelegate {
    
    var NOTIFICATION_TOKEN = ""
    var NOTIFICATION_DICT:NSDictionary = [:]
    var NOTIFICATION_STATUS:Bool = false
    var NOTIFICATION_TYPE:String!
    var DEVICE_ID = ""//UIDevice.current.identifierForVendor?.uuidString
    var isFrom_Notification:Bool = false
    var AllowDateSelecetionInCalendar:Bool = true
    var CHATROOM_ID = ""
    
    var isFromBooking:Bool = false
    //var UserMainImage:UIImage!
    
    var window: UIWindow?
    var spinnerView: MMMaterialDesignSpinner = MMMaterialDesignSpinner()
    
    var locationManager = CLLocationManager()
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    
    var certificateStatus: Int!
    var discoverStatus: Int!
    var progressionStatus: Int!
    var StripeCustomerID: String!
    
    var arrAllState:NSMutableArray = []
    var arrState:NSArray = []
    
    var arrAllCountry:NSMutableArray = []
    var arrCountry:NSArray = []
    
    
    
    class func shared() -> AppDelegate {
        let shared = UIApplication.shared.delegate as! AppDelegate
        return shared
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        UNUserNotificationCenter.current().delegate = self
        
        self.registerForPushNotifications()
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        if let notification = launchOptions?[.remoteNotification] as? [String: AnyObject]{
        self.application(application, didReceiveRemoteNotification: notification)
        }
        
//        if launchOptions != nil {
//            let userInfo = launchOptions?[.remoteNotification] as? [AnyHashable : Any]
//            if userInfo != nil {
//                if let object = userInfo?["aps"] {
//                    NOTIFICATION_DICT = object as! NSDictionary
//                    NOTIFICATION_STATUS = true
//                }
//            }
//        } else {
//        }
        //Facebook
        //ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        //Facebook
        
        FirebaseApp.configure()
        Fabric.sharedSDK().debug = true
        Fabric.with([Crashlytics.self])
        
        SlideMenuOptions.contentViewScale = 1.0
        SlideMenuOptions.hideStatusBar = false
        
        SlideMenuOptions.contentViewScale = 1.0
        if DeviceType.IS_IPHONE_5 {
            SlideMenuOptions.leftViewWidth = 246
        }
        else if DeviceType.IS_IPAD{
            SlideMenuOptions.leftViewWidth = 350
        }
        else{
            SlideMenuOptions.leftViewWidth = 350
        }
        
        setupNavigationBar()
        
        //MMMaterialDesignSpinner
        let spinnerView:MMMaterialDesignSpinner = MMMaterialDesignSpinner(frame: CGRect.zero)
        spinnerView.frame = CGRect.zero
        
        self.spinnerView = spinnerView
        
        spinnerView.lineWidth = 2;
        spinnerView.tintColor =  #colorLiteral(red: 0.2784313725, green: 0.4549019608, blue: 0.5921568627, alpha: 1)
        
        self.spinnerView.bounds = CGRect(x: 0, y: 0, width: 40, height: 40);
        self.spinnerView.center = CGPoint(x: self.window!.bounds.midX, y: self.window!.bounds.midY);
        //MMMaterialDesignSpinner Comp
        
        //Location
        if CLLocationManager.locationServicesEnabled()
        {
            self.locationManager = CLLocationManager()
            self.locationManager.delegate = self
            self.locationManager.distanceFilter = kCLDistanceFilterNone
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            
            let authorizationStatus = CLLocationManager.authorizationStatus()
            if (authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways)
            {
                self.locationManager.startUpdatingLocation()
            }
                
            else if (locationManager.responds(to: #selector(CLLocationManager.requestAlwaysAuthorization)))
            {
                self.locationManager.requestAlwaysAuthorization()
                self.locationManager.startUpdatingLocation()
                
                //                let alert = UIAlertController(title: "Allow Location Access", message: "Link Affiliate needs access to your location. Turn on Location Services in your device settings.", preferredStyle: UIAlertController.Style.alert)
                //                
                //                alert.addAction(UIAlertAction(title: "Settings", style: UIAlertAction.Style.default, handler: { action in
                //                    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                //                        return
                //                    }
                //                    if UIApplication.shared.canOpenURL(settingsUrl) {
                //                        UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                //                            print("Settings opened: \(success)")
                //                        })
                //                    }
                //                }))
                //                DispatchQueue.main.async {
                //                    self.window?.rootViewController?.present(alert, animated: true, completion: nil)
                //                }
                
            }
                
            else
            {
                self.locationManager.startUpdatingLocation()
            }
        }
        //Location Comp
        
        //Stripe
        // Old Test : pk_test_bfcHaJ5DBAMWGCZDTwSAWhRt
        // New Test : pk_test_9RGEz7pOMwiOsKnr9D2DJkVy00y4gJXtac
        // Live : "pk_live_OXutpP1dO34MPAAUSSby454100OIddPuqP"
        
        STPPaymentConfiguration.shared().publishableKey = "pk_live_OXutpP1dO34MPAAUSSby454100OIddPuqP"
        //Stripe Comp
        
        self.getAllState()
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        
    }
    
    //MARK:- getAllState Method
    func getAllState()
    {
        let url = Bundle.main.url(forResource: "state", withExtension: "json")!
        do {
            let jsonData = try Data(contentsOf: url)
            arrState = try (JSONSerialization.jsonObject(with: jsonData) as? NSArray)!
            print(arrState)
            for dict in arrState
            {
                arrAllState.add(dict)
            }
            print(arrAllState)
            self.getAllCountry()
        }
        catch {
            print(error)
        }
    }
    
    //MARK:- getAllCountry Method
    func getAllCountry()
    {
        let url = Bundle.main.url(forResource: "countries", withExtension: "json")!
        do {
            let jsonData = try Data(contentsOf: url)
            arrCountry = try (JSONSerialization.jsonObject(with: jsonData) as? NSArray)!
            print(arrCountry)
            for dict in arrCountry
            {
                arrAllCountry.add(dict)
            }
            print(arrAllCountry)
        }
        catch {
            print(error)
        }
    }
    
    //MARK:- logout Method
    func logout() {
        let rootVc = window?.rootViewController as! UINavigationController
        for controller in rootVc.viewControllers as Array {
            if controller is Login_VC
            {
                rootVc.popToViewController(controller, animated: false)
                break
            }
        }
        
        
        //Clear User Data
        AppPrefs.shared.setIsUserLogin(isUserLogin: false)
        AppPrefs.shared.removeUserName()
        AppPrefs.shared.removeUserProfile()
        AppPrefs.shared.setIsUserRememberLogin(isUserLogin: false)
        
        //
        //        AppPrefs.shared.removeSessionId()
        //        AppPrefs.shared.removeUserData()
        
    }
    
    
    
    //MARK:- setupNavigationBar Method
    func setupNavigationBar() {
        if #available(iOS 13, *) {
            let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            let statusBar = UIView(frame: window?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero)
            statusBar.backgroundColor = #colorLiteral(red: 0.2784313725, green: 0.4549019608, blue: 0.5921568627, alpha: 1) //UIColor.init(hexString: "#002856")
            //statusBar.tintColor = UIColor.init(hexString: "#002856")
            window?.addSubview(statusBar)
            UINavigationBar.appearance().tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            UINavigationBar.appearance().barTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            UINavigationBar.appearance().isTranslucent = false
            UINavigationBar.appearance().backgroundColor = #colorLiteral(red: 0.2784313725, green: 0.4549019608, blue: 0.5921568627, alpha: 1)
            UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        }
        else
        {
            UIApplication.shared.statusBarView?.backgroundColor = #colorLiteral(red: 0.2784313725, green: 0.4549019608, blue: 0.5921568627, alpha: 1)
            UINavigationBar.appearance().tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            UINavigationBar.appearance().barTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            UINavigationBar.appearance().isTranslucent = false
            UINavigationBar.appearance().backgroundColor = #colorLiteral(red: 0.2784313725, green: 0.4549019608, blue: 0.5921568627, alpha: 1)
            UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        }
    }
    
    //MARK:- locationManager Method
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error while requesting new coordinates")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        self.latitude = locations[0].coordinate.latitude
        self.longitude = locations[0].coordinate.longitude
        
        print(self.latitude)
        print(self.longitude)
        
        //        let newLocation = locations.last
        //
        //        let locationAge: TimeInterval = -(newLocation?.timestamp.timeIntervalSinceNow ?? 0.0)
        //        if locationAge > 30.0
        //        {
        //            return
        //        }
        
        //        DispatchQueue.global(qos: .background).async {
        //            DispatchQueue.main.asyncAfter(deadline:  DispatchTime.now() + 00.00){
        //                self.serviceCall_PassLatLong(latitude: String(self.latitude), longitude: String(self.longitude), notification_token: self.NOTIFICATION_TOKEN)
        //
        //            }
        //        }
        // Notification Api When User Comes Near to Event
    }
    
    //MARK:- ~~~~~~~~~~HUD Method
    func ShowSpinnerView()
    {
        // show Progress bar
        self.window!.addSubview(self.spinnerView)
        self.window!.isUserInteractionEnabled=false
        
        spinnerView.isHidden = false
        spinnerView.startAnimating()
    }
    func HideSpinnerView()
    {
        // hide Progress bar
        self.window!.isUserInteractionEnabled=true
        spinnerView.isHidden = true
        spinnerView.stopAnimating()
    }
}

// Push Notificaion
@available(iOS 10.0, *)
extension AppDelegate {
    func registerForPushNotifications() {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
                [weak self] (granted, error) in
                print("Permission granted: \(granted)")
                
                guard granted else {
                    print("Please enable \"Notifications\" from App Settings.")
                    self?.showPermissionAlert()
                    return
                }
                self?.getNotificationSettings()
            }
        } else {
            let settings = UIUserNotificationSettings(types: [.alert, .sound, .badge], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    @available(iOS 10.0, *)
    func getNotificationSettings() {
        
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            print("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print("Device Token: \(token)")
        self.NOTIFICATION_TOKEN = token
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
    
    func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [AnyHashable : Any], completionHandler: @escaping () -> Void)
    {
        print("Handle")
    }
    
    @available(iOS 10.0, *)
//    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
//    {
//        completionHandler([.alert, .badge, .sound])
//    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        
        let userInfo = notification.request.content.userInfo
        print("Notification Data : ",userInfo)
        NOTIFICATION_DICT = userInfo as NSDictionary
        NOTIFICATION_TYPE =  NOTIFICATION_DICT.value(forKey: "type") as? String ?? ""
        
        completionHandler([.alert,.badge,.sound])
            
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        
        if let object = userInfo["aps"] {
            NOTIFICATION_DICT = object as! NSDictionary
            NOTIFICATION_STATUS = true
            CHATROOM_ID = NOTIFICATION_DICT.value(forKey: "room") as? String ?? ""
            NOTIFICATION_TYPE =  NOTIFICATION_DICT.value(forKey: "type") as? String ?? ""
        }
        
        if application.applicationState == .inactive
        {
            if NOTIFICATION_TYPE == "chat"{
                isFrom_Notification = true
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PushNotification_CALL"), object: self)
            }
            else{
                let rootViewController = self.window!.rootViewController as! UINavigationController
                let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let Splash = mainStoryboard.instantiateViewController(withIdentifier: "Splash_VC") as! Splash_VC
                rootViewController.pushViewController(Splash, animated: true)
            }
            
        }
        else if application.applicationState == .active
        {
            isFrom_Notification = false
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PushNotification_CALL"), object: self)
            
        }
        else if application.applicationState == .background
        {
            isFrom_Notification = false
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PushNotification_CALL"), object: self)
            
        }
        else
        {
            
        }
    }
    
    func showPermissionAlert() {
        let alert = UIAlertController(title: "WARNING", message: "Please enable access to Notifications in the Settings app.", preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default) {[weak self] (alertAction) in
            self?.gotoAppSettings()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        alert.addAction(settingsAction)
        alert.addAction(cancelAction)
        
        DispatchQueue.main.async {
            self.window?.rootViewController?.present(alert, animated: true, completion: nil)
        }
    }
    
    private func gotoAppSettings() {
        
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
        }
    }
}
