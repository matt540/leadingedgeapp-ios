//
//  CardsCell.swift
//  SurfBoard
//
//  Created by esparkbiz on 4/22/20.
//  Copyright © 2020 esparkbiz. All rights reserved.
//

import UIKit

protocol MakeDefaultPayment: NSObjectProtocol
{
    func btnMakeDefaultAction(_ sender: Any?)
}

class CardsCell: UITableViewCell {
    
    weak var delegate: MakeDefaultPayment?
    
    @IBOutlet var lblCardNumber: UILabel!
    @IBOutlet var lblLast4: UILabel!
    @IBOutlet var viewCell: UIView!
    @IBOutlet var cellImg: UIImageView!
    
    @IBOutlet var lblDefaultMethod: UILabel!
    @IBOutlet var btnMakeDefault: UIButton!
    @IBOutlet var lblDefaulrMethodWidth: NSLayoutConstraint!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.viewCell.addCornerRadius(10)
        self.viewCell.layer.borderColor = #colorLiteral(red: 0.2784313725, green: 0.4549019608, blue: 0.5921568627, alpha: 1)
        self.viewCell.layer.borderWidth = 1
        
        self.btnMakeDefault.addCornerRadius(5)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btnMakeDefaultAction(_ sender: Any) {
        self.delegate?.btnMakeDefaultAction(self)
    }
}
