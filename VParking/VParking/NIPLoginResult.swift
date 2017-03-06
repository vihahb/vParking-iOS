//
//  NIPLoginResult.swift
//  VParking
//
//  Created by TD on 2/17/17.
//  Copyright © 2017 xtel. All rights reserved.
//

import Foundation
import EVReflection
class NIPLoginResult: ResultBase{
    var authenticationid:String?
    var session:String?
    var login_time:Int64?
    var expired_time:Int64?
    var time_alive:Int?
    var dev_info_status:Int?
}
