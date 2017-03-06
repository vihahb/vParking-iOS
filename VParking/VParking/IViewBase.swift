//
//  BasePresenter.swift
//  VParking
//
//  Created by TD on 2/16/17.
//  Copyright © 2017 xtel. All rights reserved.
//

import Foundation
protocol IViewBase {
    func Initialization()
    func showProgress(title:String?)
    func closeProgress()
    func showLoginForm()
}
