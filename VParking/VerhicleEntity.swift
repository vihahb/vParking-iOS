//
//  VerhicleEntity.swift
//  VParking
//
//  Created by TD on 3/9/17.
//  Copyright © 2017 xtel. All rights reserved.
//

import Foundation
class VerhicleEntity: ResultBase {
    var id:Int = 0
    var name:String?
    var type:Int = 0
    var plate_number:String?
    var flag_default:Int = 0
    var brandname:BrandNameEntity = BrandNameEntity()
    var desc:String?
    
}

class VerhicleResult: ResultBase {
    var data:[VerhicleEntity]?
}


