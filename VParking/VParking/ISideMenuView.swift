//
//  ISideMenuView.swift
//  VParking
//
//  Created by TD on 2/19/17.
//  Copyright © 2017 xtel. All rights reserved.
//

import Foundation
protocol ISideMenuView : IViewBase {
    func onLoadProfileFail(message:String?)
    func onLoadProfileSuccess(info:UserProfileEntity)
    func onLogoutSuccess()
}
