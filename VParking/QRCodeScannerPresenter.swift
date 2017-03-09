//
//  QRCodeScannerPresenter.swift
//  VParking
//
//  Created by TD on 3/9/17.
//  Copyright © 2017 xtel. All rights reserved.
//

import Foundation
class QRCodeScannerPresenter: PresenterBase {
    var view:IQRCodeScannerView!
    init(view:IQRCodeScannerView) {
        self.view = view
    }
    
    
    func getVerhicle(){
        self.view.showProgress(title: "Đang lấy thông tin phương tiện cá nhân.")
        ParkingManager.instance.getVerhicle(){
            (result,error) in
            self.view.closeProgress()
            if result != nil && error == nil{
                let v:VerhicleSortResult = VerhicleSortResult(json: result)
                
                if v.error != nil {
                    if let errorCode = v.error?.code, errorCode == 2 { // session ko hợp lệ
                        self.getNewSession(completion: {
                            self.getVerhicle()
                        }, didError: {
                            self.view.showLoginForm()
                        })
                        return
                    }
                    self.view.verhicle(didResult: nil, error: v.error)
                }else{
                    self.view.verhicle(didResult: v.data, error: nil)

                }
            }else{
                self.view.verhicle(didResult: nil, error: error)

            }
            
        }
    }
    
    func checkIn(code:String,verhicle_id:Int,verhicle_type:Int,name:String){
        let checkIn:CheckInEntity = CheckInEntity()
        checkIn.checkin_type = verhicle_type
        checkIn.parking_code = code
        checkIn.verhicle_id = verhicle_id
        self.view.showProgress(title: "Đang Checkin tại bãi đỗ xe \(name)")
        ParkingManager.instance.checkIn(checkIn) { (result, error) in
            self.view.closeProgress()
            if (result == nil || result!.isEmpty) && error == nil {
                self.view.checkInSuccess()
                return
            }
            if result != nil && error == nil{
                let v:ResultBase = ResultBase(json: result)
                
                if v.error != nil {
                    if let errorCode = v.error?.code { // session ko hợp lệ
                    switch(errorCode){
                        case 2:
                            self.getNewSession(completion: {
                                self.checkIn(code: code, verhicle_id: verhicle_id, verhicle_type: verhicle_id, name: name)
                            }, didError: {
                                self.view.showLoginForm()
                            })
                            return
                        case 1001:
                            self.view.showCheckInErrorAndReCheckIn(message: "Bãi đỗ xe không tồn tại vui lòng thử lại.")
                            return
                        case 3002:
                            self.view.showCheckInErrorAndReCheckIn(message: "Phương tiện không tồn tại vui lòng chọn phương tiện khác")
                            return
                        case 3003:
                            self.view.showCheckInErrorAndReCheckIn(message: "Phương tiện của bạn được 1 người khách checkin vùi lòng checkout trước khi checkin")
                            return
                        default:
                            self.view.showCheckInErrorAndReCheckIn(message: "Hệ thống đang bảo trì vui lòng thử lại sau.")
                            return
                        }
                    }
                }
            }else{
                self.view.verhicle(didResult: nil, error: error)
                self.view.showCheckInErrorAndReCheckIn(message: "Kết nối mạng không ổn định vui lòng kiểm tra lại.")
            }
        }
    }
}
