//
//  Welcome_VC.swift
//  SurfBoard
//
//  Created by esparkbiz on 6/19/20.
//  Copyright © 2020 esparkbiz. All rights reserved.
//

import UIKit

class Welcome_VC: BaseViewController {
    
    
    @IBOutlet var btnLetsTry: UIButton!
    @IBOutlet var lblDesc: UILabel!
    
    var isFromMenu:Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(self.isFromMenu == true)
        {
            self.navigationController?.isNavigationBarHidden = false
            AppDelegate.shared().setupNavigationBar()
            setLeftBarBackItem()
            self.title = "About"
            setTranspertNavigation()
            
            self.btnLetsTry.isUserInteractionEnabled  = false
        }

        self.btnLetsTry.addCornerRadius(5)
        
        self.lblDesc.text = "This app is custom built for customers to interact with our Partner Affiliates all over the world to ride Lift eFoils \n\n  Navigate to the locations window to find the Affiliate nearest to you or if you are traveling search any location in the world to schedule your time to fly \n\n Checkout their location description and select the sessions available to you, pick your date and time to schedule your session \n\n For those eager to fly like a pro start with a Discovery Lesson to advance to the Progression Training Program \n\n Once you complete the program at any location, enroll in Membership to utilize Lift eFoils at any Affiliate location at a discounted rate \n\n Welcome to the Family! \n Come Fly With Us!"
    
    }
    
    
    //MARK: - btnLetsTry Action Method -
    @IBAction func btnLetsTry(_ sender: Any) {
        
        if AppPrefs.shared.isUserRememberLogin() {
            self.navigationController?.isNavigationBarHidden = true
            goToHome(animated: false)
        }
        else
        {
            self.goToMainScreen()
        }
        
    }
    
    //MARK: - goToMainScreen Method -
    func goToMainScreen() {
        
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "Register_VC")  as! Register_VC
        self.navigationController?.pushViewController(nextVC, animated: false)
        
    }

}
