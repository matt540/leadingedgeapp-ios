//
//  VideoList_VC.swift
//  SurfBoard
//
//  Created by esparkbiz on 1/29/20.
//  Copyright © 2020 esparkbiz. All rights reserved.
//

import UIKit

class VideoList_VC: BaseViewController,UITableViewDataSource, UITableViewDelegate {
    
    var arrVideoList:[String]!
    var arrVideoListLink:[String]!

    @IBOutlet var tableView: UITableView!
    @IBOutlet var tableViewHeight: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        AppDelegate.shared().setupNavigationBar()
        self.title = "Video List"
        setLeftBarBackItem()
        setTranspertNavigation()

        arrVideoList = ["Welcome to the family!","Safety","First Ride","How to Foil","4'4 Proper Stance","Whitney's First eFoil Ride","CT's First Ride","Effortless Exploring"]
        arrVideoListLink = ["https://www.youtube.com/watch?v=1yEmtz4ZVMM",
                            "https://www.youtube.com/watch?v=FenSw41WbvQ&t=19s",
                            "https://www.youtube.com/watch?v=PlxX_3gsQQ0&t=52s",
                            "https://www.youtube.com/watch?v=WaLrpuUawfA&t=37s",
                            "https://www.youtube.com/watch?v=znDhzzGPzWQ",
                            "https://www.youtube.com/watch?v=UEmvO1Am69s",
                            "https://www.youtube.com/watch?v=gHJ-VLhW8Hk",
                            "https://www.youtube.com/watch?v=Ff-osqqyY7A"
                            ]
        
        self.tableViewHeight.constant = CGFloat(arrVideoList.count * 80)
        self.view.updateConstraintsIfNeeded()
    }
    
    //MARK: -  TableView DataSource - Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrVideoList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VideoListCell") as! VideoListCell
        cell.selectionStyle = .none
        
        cell.lblURL.text = arrVideoList[indexPath.row]
        cell.imgCell.image = UIImage(named: "Play")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let nextNavVc = self.storyboard!.instantiateViewController(withIdentifier: "VideoWebView_VC") as! VideoWebView_VC
        nextNavVc.StrURL = arrVideoListLink[indexPath.row]
        navigationController?.pushViewController(nextNavVc, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
