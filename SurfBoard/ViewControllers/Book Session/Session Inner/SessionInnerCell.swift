//
//  SessionInnerCell.swift
//  SurfBoard
//
//  Created by esparkbiz on 3/19/20.
//  Copyright © 2020 esparkbiz. All rights reserved.
//

import UIKit

protocol DescbtnAction: NSObjectProtocol
{
    func btnDescAction(_ sender: Any?)
}

class SessionInnerCell: UITableViewCell {
    
    weak var delegate: DescbtnAction?
    
    @IBOutlet var lblSessionTitle: UILabel!
    @IBOutlet var lblSessionTime: UILabel!
    @IBOutlet var lblSessionAmount: UILabel!
    @IBOutlet var viewCell: UIView!
    @IBOutlet var imgCheck: UIImageView!
    
    @IBOutlet var btnDesc: UIButton!
    
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
    
    
    @IBAction func btnDescAction(_ sender: Any) {
        self.delegate?.btnDescAction(self)
    }
    
}
