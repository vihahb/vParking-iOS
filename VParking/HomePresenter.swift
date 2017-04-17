//
//  HomePresenter.swift
//  VParking
//
//  Created by TD on 2/16/17.
//  Copyright © 2017 xtel. All rights reserved.
//

import Foundation
class HomePresenter: PresenterBase {
    var view:IHomeView
    var localData:UserDefaults = UserDefaults.init();
    init(view:IHomeView) {
        self.view = view
    }
    
    func checkLogin()
    {
        let session:String? = SessionManager.getCurrentSession()
        if session == nil{
            self.view.showLoginForm()
        }
    }
    
    func findParking(lat:Double,lng:Double){
        let codition:FindCondition = getCondition(lat:lat,lng:lng)
        self.view.showToast("Đang tìm kiếm bãi đỗ xe...!")
        ParkingManager.instance.findParking(condition: codition){(result,error) in
            if result != nil && error == nil{
                let r:FindParkingResult = FindParkingResult(json: result)
                
                if r.error != nil {
                    if self.showUpdateStore(r.error,view: self.view) {
                        return
                    }
                    if let errorCode = r.error?.code, errorCode == 2 { // session ko hợp lệ
                        self.getNewSession(completion: { 
                            self.findParking(lat: lat, lng: lng)
                        }, didError: { 
                            self.view.showLoginForm()
                        })
                        return
                    }
                    
                    self.view.findParking(didError: error, didLoaded: nil)
                }else{
                    self.view.findParking(didError: error, didLoaded: r.data)
                }
            }else{
                self.view.findParking(didError: error, didLoaded: nil)
            }
            
        }
        
        
    }
    
    func retParkingDetails(id:Int){
        self.view.showProgress(title: "Đang lấy thông tin bãi đỗ xe...!")
        ParkingManager.instance.retParkingDetails(id: id){
            (result,error) in
             self.view.closeProgress()
            if result != nil && error == nil{
                let r:ParkingInfoEntity = ParkingInfoEntity(json: result)
                
                if r.error != nil {
                    if let errorCode = r.error?.code, errorCode == 2 { // session ko hợp lệ
                        self.getNewSession(completion: {
                            self.retParkingDetails(id:id)
                        }, didError: {
                            self.view.showLoginForm()
                        })
                        return
                    }
                    self.view.retParkingDetails(didError: error, didLoaded: nil)
                }else{
                    self.view.retParkingDetails(didError: error, didLoaded: r)
                }
            }else{
                self.view.findParking(didError: error, didLoaded: nil)
            }
        }
    }
    
    func getCondition(lat:Double,lng:Double)->FindCondition{
        let condition:FindCondition = FindCondition()
        condition.lat = lat
        condition.lng = lng
        return condition
    }
}
