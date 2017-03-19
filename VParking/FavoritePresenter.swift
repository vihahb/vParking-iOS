//
//  FavoritePresenter.swift
//  VParking
//
//  Created by Thanh Lee on 3/14/17.
//  Copyright © 2017 xtel. All rights reserved.
//

import Foundation
class FavoritePresenter: PresenterBase {
    var view:IFavoriteView
    init(_ view:IFavoriteView) {
        self.view = view
    }
    func retParkingInfo(_ id:Int){
        ParkingManager.instance.retParkingDetails(id: id) { (result, error) in
            if result != nil && error == nil {
                let r:ParkingInfoEntity = ParkingInfoEntity(json: result)
                self.view.infoParking(didResult: r)
            }
        }
    }
    
    func loadFavorite(){
        self.view.showProgress(title: "Đang lấy dữ liệu...!")
        ParkingManager.instance.getFavorite { (result, error) in
            self.view.closeProgress()
            if result != nil && error == nil {
                let f:FavoriteResult = FavoriteResult(json: result)
              
                
                if f.error != nil {
                    if let errorCode = f.error?.code {
                        switch (errorCode) {
                        case 2:
                            self.getNewSession(completion: { 
                                self.loadFavorite()
                            }, didError: { 
                                self.view.showLoginForm()
                            })
                            return
                        default:
                            self.view.showError("Hệ thống đang bảo trì vui lòng thử lại sau")
                            return
                        }
                    }
                }else {
                    self.view.getFavorite(didResult: f.data, error: nil)
                }
            }else {
                self.view.showError("Kết nối mạng không ổn định vui lòng kiểu tra lại")
            }
        }
    }
}
