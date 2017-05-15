//
//  ParkingInfoBottomSheetExtensionView.swift
//  VParking
//
//  Created by TD on 3/2/17.
//  Copyright © 2017 xtel. All rights reserved.
//

import Foundation
extension ParkingInfoBottomsheetViewController: IParkingInfoBottomSheet{
    
    func favorite(error: NIPError) {
        view.makeToast(error.type!)
    }
    
    func favorite() {
        if isFavorite {
            isFavorite = false
            imgSFavorite.image = #imageLiteral(resourceName: "ic_favorite_gray")
            imgFavorite.image = #imageLiteral(resourceName: "ic_favorite_gray")
            favoriteIcon = #imageLiteral(resourceName: "ic_favorite_gray")
        }else{
            isFavorite = true
            imgSFavorite.image = #imageLiteral(resourceName: "ic_favorite_red")
            imgFavorite.image = #imageLiteral(resourceName: "ic_favorite_red")
            favoriteIcon = #imageLiteral(resourceName: "ic_favorite_red")
        }
    }
    
    func findRoute(_ pathEndcode: String?, error: NIPError?) {
        if let e = error {
            self.view.makeToast(e.message ?? "Hệ thống đang bận vui lòng thử lại.")
            return
        }
        if let parrentController = self.parent as? HomeViewController {
            parrentController.drawbleDirection(pathEndcode!, id: parking!.id)
            isDirection = true
            showPartialView(duration: 0.3)
        }
        
    }
}
