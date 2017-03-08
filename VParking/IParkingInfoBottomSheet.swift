//
//  IParkingInfoBottomSheet.swift
//  VParking
//
//  Created by TD on 3/2/17.
//  Copyright © 2017 xtel. All rights reserved.
//

import Foundation
protocol IParkingInfoBottomSheet:IViewBase{
    func favorite(error:NIPError)
    func favorite()
    func findRoute(_ pathEndcode:String?, error:NIPError?)
}
