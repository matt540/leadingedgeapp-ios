//
//  CardListCell.swift
//  SurfBoard
//
//  Created by esparkbiz on 1/30/20.
//  Copyright © 2020 esparkbiz. All rights reserved.
//

import UIKit

class CardListCell: UITableViewCell {
    
    
    @IBOutlet var lblCardNumber: UILabel!
    @IBOutlet var lblLast4: UILabel!
    @IBOutlet var viewCell: UIView!
    @IBOutlet var cellImg: UIImageView!
    
    
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
