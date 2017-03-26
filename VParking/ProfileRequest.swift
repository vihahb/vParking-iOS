//
//  ProfileRequest.swift
//  VParking
//
//  Created by Thanh Lee on 3/22/17.
//  Copyright © 2017 xtel. All rights reserved.
//

import Foundation
import EVReflection
class ProfileRequest:EVObject{
    var fullname:String?
    var gender:Int = 0
    var birthday:String?
    var email:String?
    var address:String?
    var avatar:String?
}
