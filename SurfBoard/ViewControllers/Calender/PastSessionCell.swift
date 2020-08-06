//
//  PastSessionCell.swift
//  SurfBoard
//
//  Created by esparkbiz on 2/11/20.
//  Copyright © 2020 esparkbiz. All rights reserved.
//

import UIKit

class PastSessionCell: UITableViewCell {
    
    @IBOutlet var lblType: UILabel!
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var lblCost: UILabel!
    @IBOutlet var lblLoc: UILabel!
    @IBOutlet var lblRatingTitle: UILabel!
    @IBOutlet var btnCancel: UIButton!
    
    @IBOutlet var CellView: UIView!
    @IBOutlet weak var cosmosViewFull: CosmosView!
    
    
    @IBOutlet var lblSubmit: UILabel!
    @IBOutlet var lblSubmitWidth: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.btnCancel.addCornerRadius(5)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}
