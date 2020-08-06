//
//  Message_VC.swift
//  SurfBoard
//
//  Created by esparkbiz on 12/6/19.
//  Copyright © 2019 esparkbiz. All rights reserved.
//

import UIKit

class Message_VC: BaseViewController ,UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var tableViewHeight: NSLayoutConstraint!
    
    @IBOutlet var lblAttachmentCount: UILabel!
    @IBOutlet var imgInstructor: UIImageView!
    @IBOutlet var lblInstructorName: UILabel!
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var lblTime: UILabel!
    @IBOutlet var lblSubmit: UILabel!
    @IBOutlet var lblDesc: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.isNavigationBarHidden = false
        AppDelegate.shared().setupNavigationBar()
        setLeftBarBackItem()
        setTranspertNavigation()
        self.title = "Instructor Message"
        
        self.tableView.separatorStyle = .none
        self.tableViewHeight.constant = CGFloat(2 * 50)
        self.view.updateConstraintsIfNeeded()
    }
    

    //MARK: -  TableView DataSource - Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell") as! MessageCell
        cell.selectionStyle = .none
        cell.lblCell.text = "image_original_\(indexPath.row).jpg"

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //        let nextNavVc = self.storyboard!.instantiateViewController(withIdentifier: "Calender_VC") as! Session_Inner_VC
        //        self.navigationController?.pushViewController(nextNavVc, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    
    //MARK: -  Button Actions
    @IBAction func btnReplyAction(_ sender: Any) {
    }
    
    @IBAction func btnFrwdAction(_ sender: Any) {
    }
    
    @IBAction func btnTrashAction(_ sender: Any) {
    }
    
}
