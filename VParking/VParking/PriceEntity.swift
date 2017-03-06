//
//  PriceEntity.swift
//  VParking
//
//  Created by TD on 2/27/17.
//  Copyright © 2017 xtel. All rights reserved.
//

import Foundation
import EVReflection
class PriceEntity: EVObject {
    var id:Int = 0
    var name:String?
    var price:Double = 0.0
    var price_type:Int = 0
    var price_for:Int = 0
}
