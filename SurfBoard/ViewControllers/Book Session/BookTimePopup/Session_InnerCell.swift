//
//  Session_InnerCell.swift
//  SurfBoard
//
//  Created by esparkbiz on 12/6/19.
//  Copyright © 2019 esparkbiz. All rights reserved.
//

import UIKit

class Session_InnerCell: UITableViewCell {

    
    @IBOutlet var viewCell: UIView!
    @IBOutlet var imgCell: UIImageView!
    @IBOutlet var lblDateCell: UILabel!
    @IBOutlet var lblDescCell: UILabel!
    @IBOutlet var lblAmountCell: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.viewCell.addCornerRadius(10)
        self.viewCell.layer.borderColor = #colorLiteral(red: 0.2784313725, green: 0.4549019608, blue: 0.5921568627, alpha: 1)
        self.viewCell.layer.borderWidth = 1
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
