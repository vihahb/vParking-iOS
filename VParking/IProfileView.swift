//
//  IProfileView.swift
//  VParking
//
//  Created by TD on 3/13/17.
//  Copyright © 2017 xtel. All rights reserved.
//

import Foundation
protocol IProfileView:IViewBase {
    func profile()
    func profile(error : NIPError?)

}
