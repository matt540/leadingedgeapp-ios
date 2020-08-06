//
//  PrivacyPopup_VC.swift
//  SurfBoard
//
//  Created by esparkbiz on 5/18/20.
//  Copyright © 2020 esparkbiz. All rights reserved.
//

import UIKit

class PrivacyPopup_VC: BaseViewController {
    
    @IBOutlet private weak var viewPopupUI:UIView!
    @IBOutlet private weak var viewMain:UIView!
    @IBOutlet var btnSubmit: UIButton!
    @IBOutlet var btnCheckBox: UIButton!
    @IBOutlet var btnPrivacyLink: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.showViewWithAnimation()
        self.viewPopupUI.addShadow(color: .lightGray, opacity: 1.0, offset: CGSize(width: 1, height: 1), radius: 2)
        self.viewPopupUI.addCornerRadius(5)
        self.btnSubmit.addCornerRadius(5)
        
        self.btnPrivacyLink.underline()
        
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
    
    
    //MARK: - btnSubmitAction Method
    @IBAction func btnSubmitAction(_ sender: Any) {
        
        if(btnCheckBox.isSelected == false){
            displayAlert(APPNAME, andMessage: "Please Accept Our Privacy Policy")
        }
        else{
            
            UserDefaults.standard.set(true, forKey: "UserPrivacyACK")
            UserDefaults.standard.synchronize()
            displayAlert(APPNAME, andMessage: "Saved Successfully")
            self.hideViewWithAnimation()
        }
        
    }
    
    //MARK: - btnCheckAction Method
    @IBAction func btnCheckAction(_ sender: Any) {
        
        if(btnCheckBox.isSelected == true){
            btnCheckBox.isSelected = false
        }
        else{
            btnCheckBox.isSelected = true
        }
        
    }
    
    //MARK: - btnPrivacyLinkAction Method
    @IBAction func btnPrivacyLinkAction(_ sender: Any) {
        
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
    
}
