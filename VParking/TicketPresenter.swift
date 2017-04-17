//
//  TicketPresenter.swift
//  VParking
//
//  Created by TD on 3/9/17.
//  Copyright © 2017 xtel. All rights reserved.
//

import Foundation
class TicketPresenter: PresenterBase {
    var view:ITicketView!
    init(_ view:ITicketView) {
        self.view = view
    }
    
    
    func retParkingInfo(_ id:Int){
        self.view.showProgress(title: "Đang lấy thông tin vé xe...!")
        ParkingManager.instance.retParkingDetails(id: id){
            (result,error) in
            self.view.closeProgress()
            if result != nil && error == nil{
                let r:ParkingInfoEntity = ParkingInfoEntity(json: result)
                
                if r.error != nil {
                    if self.showUpdateStore(r.error,view: self.view) {
                        return
                    }
                    if let errorCode = r.error?.code, errorCode == 2 { // session ko hợp lệ
                        self.getNewSession(completion: {
                            self.retParkingInfo(id)
                        }, didError: {
                            self.view.showLoginForm()
                        })
                        return
                    }
                    self.view.showError(message: "Hệ thống đang bảo trì vui lòng thử lại")
                }else{
                    self.view.ticket(didResult: r)
                }
            }else{
                self.view.showError(message: "Hệ thống đang bảo trì vui lòng thử lại")
            }
        }
    }
    
    func checkOut(_ transaction:String, ParkingName name:String){
        self.view.showProgress(title: "Đang checkout khỏi bãi đỗ xe \(name)")
        let c:CheckOutReq = CheckOutReq()
        c.transaction = transaction
        ParkingManager.instance.checkOut(c){
            (result,error) in
            self.view.closeProgress()
            if result != nil && error == nil{
                let r:ParkingInfoEntity = ParkingInfoEntity(json: result)
                if let e = r.error{
                    if self.showUpdateStore(e,view: self.view) {
                        return
                    }
                    switch(e.code){
                    case 2:
                        self.getNewSession(completion: {
                            self.checkOut(transaction,ParkingName:name)
                        }, didError: {
                            self.view.showLoginForm()
                        })
                        return
                    case 3001:
                        self.view.showError(message: "Bạn chưa checkin tại bãi đỗ xe này. Vui lòng kiểm tra lại.")
                        return
                    default:
                        self.view.showError(message: "Hệ thống đang bảo chì vui lòng thử lại sau.")
                        return
                    }
                }else{
                    self.view.checkOutSuccess()
                }

            }else{
                self.view.showError(message: "Hệ thống đang bảo trì vui lòng thử lại")
            }
        }
    }

}
