//
//  CheckInInfo.swift
//  VParking
//
//  Created by TD on 3/9/17.
//  Copyright © 2017 xtel. All rights reserved.
//

import Foundation
import EVReflection
class CheckInInfo : EVObject{
    var transaction:String?
    var checkin_time:String?
    var checkin_type:Int = 0
    var ticket_code:String?
    var parking:ParkingInfoEntity = ParkingInfoEntity()
    var vehicle:VerhicleEntity  =
        VerhicleEntity()
}
