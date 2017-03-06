//
//  DeviceEntity.swift
//  VParking
//
//  Created by TD on 2/17/17.
//  Copyright © 2017 xtel. All rights reserved.
//

import Foundation
import EVReflection
class DeviceEntity: EVObject {
    var deviceid:String?
    var os_name:String?
    var os_version:String?
    var other:String?
    var type:Int = 2
    var vendor:String?
}
