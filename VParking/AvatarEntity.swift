//
//  AvatarEntity.swift
//  VParking
//
//  Created by Thanh Lee on 3/23/17.
//  Copyright © 2017 xtel. All rights reserved.
//

import Foundation
import EVReflection
class AvatarEntity: EVObject {
    var name:String?
    var server_path:String?
    var uri:String?
}

class AvatarResult: ResultBase {
    var data = [AvatarEntity]()
}
