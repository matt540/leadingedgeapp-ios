//
//  CustomTabBar.swift
//  SurfBoard
//
//  Created by esparkbiz on 12/23/19.
//  Copyright © 2019 esparkbiz. All rights reserved.
//

import UIKit
import Alamofire
import SlideMenuControllerSwift


class CustomTabBar: UITabBarController,UITabBarControllerDelegate  {
    
    //static let shared = CustomTabBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        self.tabBar.unselectedItemTintColor = UIColor.white
        self.tabBar.tintColor = UIColor.black
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    //MARK: - UITabbar Delegate Methods -
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController)
    {
        //        if AppPrefs.shared.isUserLogin()
        //        {
        //            let navVC = tabBarController.viewControllers![4] as! UINavigationController
        //            var arrVC = navVC.viewControllers
        //            let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "MyAccountViewController") as! MyAccountViewController
        //            arrVC = [loginVC]
        //            navVC.viewControllers = arrVC
        //        }
        
        let navigation = viewController as! UINavigationController
        navigation.popToRootViewController(animated: false)
        
        
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        let choice = 3;
        if viewController == tabBarController.viewControllers![choice]
        {
            
            self.GetUser_API()
            //            let ProgressionStatus = AppDelegate.shared().progressionStatus
            //            let DiscoverySatus = AppDelegate.shared().discoverStatus
            //            let Certificatestatus = AppDelegate.shared().discoverStatus
            
            let result = UserDefaults.standard.value(forKey: "UserAllData") as? NSDictionary
            let Certificatestatus = result?.value(forKeyPath: "certificate_status") as? Int
            let DiscoverySatus = result?.value(forKeyPath: "discover_lesson_status") as? Int
            let ProgressionStatus = result?.value(forKeyPath: "progression_model_status") as? Int
            
            
            if (DiscoverySatus == 1 && ProgressionStatus == 0)
            {
                let alert = UIAlertController(title: APPNAME, message: "Successful completion of a discover session is required to advance to the Progression Model.", preferredStyle: .actionSheet)
                let action1 = UIAlertAction(title: "Book Discover Session", style: .default) { (success) in
                    
                    let ViewController = self.storyboard?.instantiateViewController(withIdentifier: "CustomTabBar") as! CustomTabBar
                    ViewController.selectedIndex = 1
                    ViewController.selectedViewController = ViewController.viewControllers![1]
                    self.navigationController?.pushViewController(ViewController, animated: true)
                    
                }
                let action2 = UIAlertAction(title: "Cancel", style: .cancel) { (success) in
                    
                }
                alert.addAction(action1)
                alert.addAction(action2)
                self.present(alert, animated: true, completion: nil)
                return false
            }
            else if (DiscoverySatus == 2 && ProgressionStatus == 0)
            {
                let alert = UIAlertController(title: APPNAME, message: "Progression Enrollment is required to advance to the Progression Model.", preferredStyle: .actionSheet)
                let action1 = UIAlertAction(title: "Book Progression Enrollment", style: .default) { (success) in
                    
                    let ViewController = self.storyboard?.instantiateViewController(withIdentifier: "CustomTabBar") as! CustomTabBar
                    ViewController.selectedIndex = 1
                    ViewController.selectedViewController = ViewController.viewControllers![1]
                    self.navigationController?.pushViewController(ViewController, animated: true)
                }
                let action2 = UIAlertAction(title: "Cancel", style: .cancel) { (success) in
                    
                }
                alert.addAction(action1)
                alert.addAction(action2)
                self.present(alert, animated: true, completion: nil)
                return false
            }
            else if (DiscoverySatus == 0 && ProgressionStatus == 0 && Certificatestatus == 1 || DiscoverySatus == 0 && ProgressionStatus == 0 && Certificatestatus == 2)
            {
                let alert = UIAlertController(title: APPNAME, message: "You're in Certification Flow. You can not access Progression Model.", preferredStyle: .actionSheet)
                
                let action2 = UIAlertAction(title: "Close", style: .cancel) { (success) in
                    
                }
                alert.addAction(action2)
                self.present(alert, animated: true, completion: nil)
                return false
            }
//            else if (DiscoverySatus == 2 && ProgressionStatus == 1 && Certificatestatus == 0)
//            {
//                let alert = UIAlertController(title: APPNAME, message: "Successful completion of a Cruiser session is required to advance to the Progression Model.", preferredStyle: .actionSheet)
//                let action1 = UIAlertAction(title: "Book Cruiser Session", style: .default) { (success) in
//                    
//                    let ViewController = self.storyboard?.instantiateViewController(withIdentifier: "CustomTabBar") as! CustomTabBar
//                    ViewController.selectedIndex = 1
//                    ViewController.selectedViewController = ViewController.viewControllers![1]
//                    self.navigationController?.pushViewController(ViewController, animated: true)
//                }
//                let action2 = UIAlertAction(title: "Cancel", style: .cancel) { (success) in
//                    
//                }
//                alert.addAction(action1)
//                alert.addAction(action2)
//                self.present(alert, animated: true, completion: nil)
//                return false
//            }
//            else if (DiscoverySatus == 0 && ProgressionStatus == 0 && Certificatestatus == 2)
//            {
//                let alert = UIAlertController(title: APPNAME, message: "You're now Certified User. You can Book Normal Sessions.", preferredStyle: .actionSheet)
//                let action1 = UIAlertAction(title: "Book Normal Session", style: .default) { (success) in
//
//                    let ViewController = self.storyboard?.instantiateViewController(withIdentifier: "CustomTabBar") as! CustomTabBar
//                    ViewController.selectedIndex = 1
//                    ViewController.selectedViewController = ViewController.viewControllers![1]
//                    self.navigationController?.pushViewController(ViewController, animated: true)
//                }
//                let action2 = UIAlertAction(title: "Cancel", style: .cancel) { (success) in
//
//                }
//                alert.addAction(action1)
//                alert.addAction(action2)
//                self.present(alert, animated: true, completion: nil)
//                return false
//            }
            else
            {
                
            }
        }
        
        if viewController == tabBarController.viewControllers![1]
        {
            let ViewController = self.storyboard?.instantiateViewController(withIdentifier: "CustomTabBar") as! CustomTabBar
            ViewController.selectedIndex = 1
            ViewController.selectedViewController = ViewController.viewControllers![1]
            self.navigationController?.pushViewController(ViewController, animated: false)
        }
        return true
    }
    
    
    //MARK: - Helper Methods -
    func setLeftBarMenuItem() {
        var leftBarMenuItem = UIBarButtonItem()
        leftBarMenuItem = UIBarButtonItem(image: #imageLiteral(resourceName: "SideMenu"), style: .plain, target: self, action: #selector(self.clickToBtnMenuItem(_:)))
        //leftBarMenuItem.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.navigationItem.leftBarButtonItem = leftBarMenuItem
    }
    
    @IBAction func clickToBtnMenuItem(_ sender: UIBarButtonItem) {
        view.endEditing(true)
        //slideDrawerMenuController()?.setDrawerState(.opened, animated: true)
        self.slideMenuController()?.addLeftGestures()
        self.slideMenuController()?.openLeft()
    }
    
    func setLeftBarBackItem() {
        var leftBarBackItem = UIBarButtonItem()
        leftBarBackItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Setting"), style: .plain, target: self, action: #selector(self.clickToBtnBackItem(_:)))
        self.navigationItem.leftBarButtonItem = leftBarBackItem
        //slideMenuController()?.navigationItem.leftBarButtonItem = leftBarBackItem
    }
    
    @IBAction func clickToBtnBackItem(_ sender: UIBarButtonItem) {
        view.endEditing(true)
        
        //   slideMenuController()?.navigationController?.popViewController(animated: true)
        _ = navigationController?.popViewController(animated: true)
    }
    
    func hideNavBar(){
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func ShwoNavBar()
    {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func hideTabNav(){
        let viewController = slideMenuController()?.mainViewController as! UINavigationController
        for vc in viewController.viewControllers{
            if vc is CustomTabBar{
                let cv = vc as? CustomTabBar
                cv?.hideNavBar()
            }
        }
    }
    
    func showTabNav(){
        let viewController = slideMenuController()?.mainViewController as! UINavigationController
        for vc in viewController.viewControllers{
            if vc is CustomTabBar{
                let cv = vc as? CustomTabBar
                cv?.ShwoNavBar()
            }
        }
    }
    
    
    
     //MARK: - GetUser_API -
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
                            print(dict!)
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
    
    
}
