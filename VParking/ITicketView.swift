//
//  ITicketView.swift
//  VParking
//
//  Created by TD on 3/9/17.
//  Copyright © 2017 xtel. All rights reserved.
//

import Foundation
protocol ITicketView : IViewBase {
    func showError(message:String)
    func ticket(didResult p:ParkingInfoEntity)
    func checkOutSuccess()
}
