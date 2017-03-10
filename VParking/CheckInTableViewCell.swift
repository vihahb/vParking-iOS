//
//  CheckInTableViewCell.swift
//  VParking
//
//  Created by TD on 3/9/17.
//  Copyright © 2017 xtel. All rights reserved.
//

import UIKit

class CheckInTableViewCell: UITableViewCell {

    
    @IBOutlet weak var imgVehicleType: UIImageView!
    @IBOutlet weak var lblParkingName: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblPlateNumber: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
