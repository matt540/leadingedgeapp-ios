//
//  MessageCell.swift
//  SurfBoard
//
//  Created by esparkbiz on 12/6/19.
//  Copyright © 2019 esparkbiz. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {
    
    
    @IBOutlet var lblCell: UILabel!
    @IBOutlet var imgCell: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
