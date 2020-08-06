//
//  ChatAdminCell.swift
//  SurfBoard
//
//  Created by esparkbiz on 2/4/20.
//  Copyright © 2020 esparkbiz. All rights reserved.
//

import UIKit

class ChatAdminCell: UITableViewCell {
    
    
    @IBOutlet var viewCell: UIView!
    @IBOutlet var lblAdminMsg: UILabel!
    @IBOutlet var lblAdminMsgTime: UILabel!
    @IBOutlet var imgAdmin: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.viewCell.addCornerRadius(10)
//        self.viewCell.layer.borderColor = #colorLiteral(red: 0.2784313725, green: 0.4549019608, blue: 0.5921568627, alpha: 1)
//        self.viewCell.layer.borderWidth = 1
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
