//
//  ParkingInfoEntity.swift
//  VParking
//
//  Created by TD on 2/27/17.
//  Copyright © 2017 xtel. All rights reserved.
//

import Foundation
class ParkingInfoEntity: ResultBase {
    var id:Int = 0
    var lat:Double = 0.0
    var lng:Double = 0.0
    var type:Int = 0
    var begin_time:String?
    var end_time:String?
    var parking_name:String?
    var empty_number:String?
    var total_place:Int = 0
    var parking_phone:String?
    var prices:[PriceEntity] = []
    var parking_owner:UserProfileEntity = UserProfileEntity()
    var pictures:[ParkingPictureEntity] = []
    var address:String?
    var favorite:Int = 0
    
    override func setValue(_ value: Any?, forKey key: String) {
//        if key == "prices" {
//            if value != nil{
//                prices = [PriceEntity](json:value as! String?)
//            }
//        }else if key == "pictures" {
//            pictures = [ParkingPictureEntity](json:value as! String?)
//        }else{
//            super.setValue(value, forKey: key)
//        }
        super.setValue(value, forKey: key)
    }
    
}
