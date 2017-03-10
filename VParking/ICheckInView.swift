//
//  ICheckInView.swift
//  VParking
//
//  Created by TD on 3/9/17.
//  Copyright © 2017 xtel. All rights reserved.
//

import Foundation
protocol ICheckInView : IViewBase {
    func checkIn(didResult data:[CheckInInfo]?)
    func showError(_ message:String)
}
