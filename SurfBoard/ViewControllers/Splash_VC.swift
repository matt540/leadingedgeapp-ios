//
//  ViewController.swift
//  Surf Board
//
//  Created by eSparkBiz-1 on 03/12/19.
//  Copyright © 2019 eSparkBiz. All rights reserved.
// 
import UIKit
import AVKit
import Alamofire
import AVFoundation
import JNKeychain

class Splash_VC: BaseViewController,AVPlayerViewControllerDelegate {
    
    var timer : Timer!
    var count : Int! = 0
    var player = AVPlayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let english = Locale1().initWithLanguageCode(languageCode: "en", countryCode: "gb", name: "United Kingdom")
        DGLocalization.sharedInstance.setLanguage(withCode:english)
        
        AppDelegate.shared().DEVICE_ID = (self.keychain_valueForKey("keychainDeviceUDIDForLink") as? String ?? "")
        if AppDelegate.shared().DEVICE_ID == ""
        {
            AppDelegate.shared().DEVICE_ID = UIDevice.current.identifierForVendor!.uuidString
            self.keychain_setObject(AppDelegate.shared().DEVICE_ID as AnyObject, forKey: "keychainDeviceUDIDForLink")
        }
        
        self.navigationController?.isNavigationBarHidden = true
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppDelegate.shared().setupNavigationBar()
        if AppDelegate.shared().isFrom_Notification == true{
            self.buttonAction(sender: nil)
        }
        else{
            videoPlay()
        }
    }
    
    // MARK: - Keychain
    func keychain_setObject(_ object: AnyObject, forKey: String) {
        let result = JNKeychain.saveValue(object, forKey: forKey)
        if !result {
            print("keychain saving: smth went wrong")
        }
    }
    
    func keychain_deleteObjectForKey(_ key: String) -> Bool {
        let result = JNKeychain.deleteValue(forKey: key)
        return result
    }
    
    func keychain_valueForKey(_ key: String) -> AnyObject? {
        let value = JNKeychain.loadValue(forKey: key)
        return value as AnyObject?
    }
    
    //MARK:- update Method
    @objc func update()
    {
        count = count + 1
        print(count)
        if Int(count) == 2
        {
            timer.invalidate()
            count = 0
            
            let btn: UIButton = UIButton(frame: CGRect(x: 0, y: UIScreen.main.bounds.height - 50, width: UIScreen.main.bounds.width - 25, height: 50))
            btn.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.right
            btn.backgroundColor = UIColor.clear
            btn.setTitleColor(UIColor.white, for: .normal)
            btn.setTitle("Skip Video", for: .normal)
            btn.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
            btn.tag = 1
            self.view.addSubview(btn)
        }
    }
    
    @objc func goToMainScreen() {
        
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "Register_VC")  as! Register_VC
        self.navigationController?.pushViewController(nextVC, animated: false)
        
    }
    
    func videoPlay()
    {
        let playerController = AVPlayerViewController()
        playerController.delegate = self
        
        let path = Bundle.main.path(forResource: "video", ofType: "mp4")
        let url = NSURL(fileURLWithPath: path!)
        
        NotificationCenter.default.addObserver(self,selector: #selector(playerItemDidReachEnd),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                               object: nil)
        
        player = AVPlayer(url: url as URL)
        playerController.player = player
        playerController.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        playerController.videoGravity = AVLayerVideoGravity.resize
        self.addChild(playerController)
        self.view.addSubview(playerController.view)
        
        playerController.showsPlaybackControls = false
        player.play()
        
    }
    
    //MARK: - Button Action Method -
    @objc func buttonAction(sender: UIButton!) {
        player.pause()
        player.replaceCurrentItem(with: nil)
        
//        if AppPrefs.shared.isUserRememberLogin() {
//            self.navigationController?.isNavigationBarHidden = true
//            goToHome(animated: false)
//        }
//        else
//        {
//            goToMainScreen()
//        }
        
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "Welcome_VC")  as! Welcome_VC
        self.navigationController?.pushViewController(nextVC, animated: true)
        
    }
    
    //MARK: - playerItemDidReachEnd Method -
    @objc func playerItemDidReachEnd(notification: NSNotification) {
        player.pause()
        player.replaceCurrentItem(with: nil)
        
//        if AppPrefs.shared.isUserRememberLogin() {
//            self.navigationController?.isNavigationBarHidden = true
//            goToHome(animated: false)
//        }
//        else
//        {
//            goToMainScreen()
//        }
        
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "Welcome_VC")  as! Welcome_VC
        self.navigationController?.pushViewController(nextVC, animated: true)
        
    }
    
    // MARK:- Extra Method
    func HandlePushNotification()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(self.GoOnNotificationVC), name: NSNotification.Name(rawValue: "PushNotification_CALL"), object: nil)

    }
    
    @objc func GoOnNotificationVC(notification: NSNotification){
        DispatchQueue.main.async() {
            self.moveVCBaseonNotificationType()
        }
    }
        
    func moveVCBaseonNotificationType()
    {
        if AppDelegate.shared().NOTIFICATION_TYPE == "chat"
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChatUserList_VC") as! ChatUserList_VC
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    //MARK: - Remove Observer
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
}

