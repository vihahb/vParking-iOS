//
//  VerhiclePresenter.swift
//  VParking
//
//  Created by Thanh Lee on 3/15/17.
//  Copyright © 2017 xtel. All rights reserved.
//

import Foundation
class VerhiclePresenter: PresenterBase {
    var view:IVerhicleView
    init(_ view:IVerhicleView) {
        self.view = view
    }
    
   
    func loadVerhicle(){
        self.view.showProgress(title: "Đang lấy dữ liệu...!")
        ParkingManager.instance.getVerhicle { (result, error) in
            self.view.closeProgress()
            if result != nil && error == nil {
                let v:VerhicleResult = VerhicleResult(json: result)
                
                if v.error != nil {
                    if let errorCode = v.error?.code{
                        switch (errorCode){
                        case 2:
                            self.getNewSession(completion: { 
                                self.loadVerhicle()
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
                    self.view.getVerhicle(didResult: v.data, error: nil)
                }
            }else {
                self.view.showError("Kết nối mạng không ổn định vui lòng kiểm tra lại")
            }
        }
    }
}
