//
//  CalenderCell.swift
//  SurfBoard
//
//  Created by esparkbiz on 12/5/19.
//  Copyright © 2019 esparkbiz. All rights reserved.
//

import UIKit

protocol CancelSession: NSObjectProtocol
{
    func btnCancelAction(_ sender: Any?)
    func btnrescheduleAction(_ sender: Any?)
}

class CalenderCell: UITableViewCell {
    
    @IBOutlet var lblType: UILabel!
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var lblCost: UILabel!
    @IBOutlet var lblLoc: UILabel!
    @IBOutlet var lblTime: UILabel!
    @IBOutlet var CellView: UIView!
    @IBOutlet var btnCancel: UIButton!
    @IBOutlet var btnReschedule: UIButton!
    
    weak var delegate: CancelSession?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //self.btnReschedule.isHidden = true
        
        self.btnCancel.addCornerRadius(5)
        self.btnReschedule.addCornerRadius(5)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    @IBAction func btnCancelAction(_ sender: Any) {
        
        self.delegate?.btnCancelAction(self)
    }
    
    @IBAction func btnrescheduleAction(_ sender: Any) {
        
        self.delegate?.btnrescheduleAction(self)
        
    }
    
}
