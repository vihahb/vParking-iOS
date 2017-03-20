//
//  VerhicleRequest.swift
//  VParking
//
//  Created by Thanh Lee on 3/17/17.
//  Copyright © 2017 xtel. All rights reserved.
//

import Foundation
import EVReflection
class VerhicleRequest:EVObject{
    var id:Int = 0
    var plate_number:String?
    var type:Int = 0
    var name:String?
    var desc:String?
    var flag_default:Int = 0
    var brandname:BrandNameEntity?
}
