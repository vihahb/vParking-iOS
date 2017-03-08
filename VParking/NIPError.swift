//
//  Error.swift
//  VParking
//
//  Created by TD on 2/17/17.
//  Copyright © 2017 xtel. All rights reserved.
//

import Foundation
import EVReflection
class NIPError : EVObject{
    var code:Int = -1
    var type:String?
    var message:String?
}
