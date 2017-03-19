//
//  FavoriteEntity.swift
//  VParking
//
//  Created by Thanh Lee on 3/14/17.
//  Copyright © 2017 xtel. All rights reserved.
//

import Foundation
import EVReflection
class FavoriteEntity: EVObject {
    var id:Int = 0
    var parking_name:String?
    var address:String?
    var end:String?
    var price:Int = 0
    var image:String?
    
}

class FavoriteResult:ResultBase{
    var data:[FavoriteEntity]?
}
