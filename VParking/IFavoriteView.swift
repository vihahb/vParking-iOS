//
//  IFavoriteView.swift
//  VParking
//
//  Created by Thanh Lee on 3/14/17.
//  Copyright © 2017 xtel. All rights reserved.
//

import Foundation
protocol IFavoriteView: IViewBase {
    func infoParking(didResult p:ParkingInfoEntity)
    func getFavorite(didResult data:[FavoriteEntity]? , error:NIPError?)
    func showError(_ message:String)
}
