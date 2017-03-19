//
//  IVerhicleView.swift
//  VParking
//
//  Created by Thanh Lee on 3/15/17.
//  Copyright © 2017 xtel. All rights reserved.
//

import Foundation
protocol IVerhicleView: IViewBase {
    func getVerhicle(didResult data:[VerhicleEntity]?, error:NIPError?)
    func showError(_ message:String)
}
