//
//  IAddVerhicleView.swift
//  VParking
//
//  Created by Thanh Lee on 3/16/17.
//  Copyright © 2017 xtel. All rights reserved.
//

import Foundation
protocol IAddVerhicleView: IViewBase {
    func getBrandName(didResult data:[BrandNameEntity]?)
    func verhicles()
    func verhicle(error:NIPError)
    
}
