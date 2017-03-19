//
//  BrandNameEntity.swift
//  VParking
//
//  Created by Thanh Lee on 3/15/17.
//  Copyright © 2017 xtel. All rights reserved.
//

import Foundation
import EVReflection
class BrandNameEntity: EVObject {
    var code:String?
    var name:String?
    var madeby:String?
}

class BrandNameResult: ResultBase {
    var data = [BrandNameEntity]()
    
}
