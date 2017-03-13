//
//  IHomeView.swift
//  VParking
//
//  Created by TD on 2/16/17.
//  Copyright © 2017 xtel. All rights reserved.
//

import Foundation
import CoreLocation
protocol IHomeView : IViewBase {
    func findParking(didError error:NIPError?,didLoaded result:[FindParkingEntity]?)
    func retParkingDetails(didError error:NIPError?,didLoaded result:ParkingInfoEntity?)
    func getMyLocation() -> CLLocationCoordinate2D?
    func drawbleDirection(_ pathEncode:String,id:Int)
    func clearDirection()
    func showToast(_ message:String)
}
