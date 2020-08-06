//
//  ProgressionPopup_VC.swift
//  SurfBoard
//
//  Created by esparkbiz on 1/22/20.
//  Copyright © 2020 esparkbiz. All rights reserved.
//

import UIKit

class ProgressionPopup_VC: UIViewController {
    
    var CommentedBy:String!
    var Comment:String!
    
    @IBOutlet private weak var viewPopupUI:UIView!
    @IBOutlet private weak var viewMain:UIView!
    @IBOutlet var lblCommentName: UILabel!
    @IBOutlet var lblCommentDesc: UILabel!
    
    @IBOutlet var lblCommentBy: UILabel!
    @IBOutlet var lblComment: UILabel!
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.showViewWithAnimation()
        self.viewPopupUI.addShadow(color: .lightGray, opacity: 1.0, offset: CGSize(width: 1, height: 1), radius: 2)
        
        self.lblCommentName.text = self.CommentedBy
        self.lblCommentDesc.text = self.Comment
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setupLang()
        
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

        self.lblCommentBy.text = "COMMENTED_BY".localize
        self.lblComment.text = "COMMENT".localize
      
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
    
    
    @IBAction func btnCloseAction(_ sender: Any) {
        self.hideViewWithAnimation()
    }
    
}
