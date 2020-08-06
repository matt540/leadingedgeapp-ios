//
//  TimeSlotCell.swift
//  SurfBoard
//
//  Created by esparkbiz on 3/18/20.
//  Copyright © 2020 esparkbiz. All rights reserved.
//

import UIKit

class TimeSlotCell: UITableViewCell {
    
    @IBOutlet var viewCell: UIView!
    @IBOutlet var lblTimeCell: UILabel!
    @IBOutlet var lblOnlyAvalLeftCell: UILabel!
    @IBOutlet var viewBookIndicateCell: UIView!
    @IBOutlet var viewBookIndicateWidth: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.viewCell.addCornerRadius(10)
        self.viewCell.layer.borderColor = #colorLiteral(red: 0.2784313725, green: 0.4549019608, blue: 0.5921568627, alpha: 1)
        self.viewCell.layer.borderWidth = 1
        
        self.viewBookIndicateCell.addCornerRadius(10)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
