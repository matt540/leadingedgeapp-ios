//
//  SideMenuCell.swift
//  Surf Board
//
//  Created by eSparkBiz-1 on 03/12/19.
//  Copyright © 2019 eSparkBiz. All rights reserved.
//

import UIKit

class SideMenuCell: UITableViewCell {

    //MARK:- IBOUTLET AND VARIABLES
    @IBOutlet var lblMenuTitle: UILabel!
    @IBOutlet var imgMenu: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
