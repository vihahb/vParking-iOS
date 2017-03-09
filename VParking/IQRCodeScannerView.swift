//
//  IQRCodeScannerView.swift
//  VParking
//
//  Created by TD on 3/6/17.
//  Copyright © 2017 xtel. All rights reserved.
//

import Foundation
protocol IQRCodeScannerView:IViewBase {
    func verhicle(didResult verhicles:[VerhicleEntity]?, error:NIPError?)
    func showCheckInError(message:String)
    func showCheckInErrorAndReCheckIn(message:String)
    func checkInSuccess()
}
