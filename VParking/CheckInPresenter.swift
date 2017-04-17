//
//  CheckInPresenter.swift
//  VParking
//
//  Created by TD on 3/9/17.
//  Copyright © 2017 xtel. All rights reserved.
//

import Foundation
class CheckInPresenter: PresenterBase {
    var view:ICheckInView!
    
    init(_ view:ICheckInView) {
        self.view = view
    }
    
    func loadCheckIn() {
        self.view.showProgress(title: "Đang lấy dữ liệu ...!")
        ParkingManager.instance.getCheckInList { (result, error) in
            self.view.closeProgress()

            if result != nil && error == nil{
                let v:CheckInList = CheckInList(json: result)
                
                if v.error != nil {
                    if self.showUpdateStore(v.error,view: self.view) {
                        return
                    }
                    if let errorCode = v.error?.code { // session ko hợp lệ
                        switch(errorCode){
                        case 2:
                            self.getNewSession(completion: {
                                self.loadCheckIn()
                            }, didError: {
                                self.view.showLoginForm()
                            })
                            return
                        default:
                            self.view.showError("Hệ thống đang bảo trì vui lòng thử lại sau.")
                            return
                        }
                    }
                }else{
                    self.view.checkIn(didResult: v.data)
                }
            }else{
                self.view.showError("Kết nối mạng không ổn định vui lòng kiểm tra lại.")
            }
        }
    }
}
