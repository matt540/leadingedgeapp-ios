//
//  Session_VC.swift
//  SurfBoard
//
//  Created by esparkbiz on 12/23/19.
//  Copyright © 2019 esparkbiz. All rights reserved.
//

import UIKit

class Session_VC: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.isNavigationBarHidden = false
        AppDelegate.shared().setupNavigationBar()
        self.title = "Sessions"
        setTranspertNavigation()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
