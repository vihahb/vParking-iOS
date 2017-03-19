//
//  AddVerhiclePresenter.swift
//  VParking
//
//  Created by Thanh Lee on 3/16/17.
//  Copyright © 2017 xtel. All rights reserved.
//

import Foundation
class AddVerhiclePresenter: PresenterBase {
    var view:IAddVerhicleView?
    
    init(_ view:IAddVerhicleView){
        self.view = view
    }
    
    func verhicle(_ data: VerhicleRequest){
        
//        var dt:VerhicleRequest = VerhicleRequest()
    
        self.view?.showProgress(title: "Đang xử lý thao tác...")
        ParkingManager.instance.verhicle(data: data) { (result, error) in
            self.view?.closeProgress()
            if error != nil {
                if let errorCode = error?.code, errorCode == 2{
                    self.getNewSession(completion: { 
                        self.verhicle(data)
                    }, didError: { 
                        self.view?.showLoginForm()
                    })
                    return
                }
                self.view?.verhicle(error: error!)
                return
            }
            let result: ResultBase = ResultBase(json: result)
            if result.error != nil {
                self.view?.verhicle(error: error!)
                return
            }
            self.view?.verhicles()
        }
        
    }
    
    func putVerhicle(_ data: VerhicleRequest){
        self.view?.showProgress(title: "Đang xử lý thao tác...")
        ParkingManager.instance.editVerhicle(data: data) { (result, error) in
            self.view?.closeProgress()
            if error != nil {
                if let errorCode = error?.code, errorCode == 2{
                    self.getNewSession(completion: { 
                        self.putVerhicle(data)
                    }, didError: { 
                        self.view?.showLoginForm()
                    })
                    return
                }
                self.view?.verhicle(error: error!)
                return
            }
            let result: ResultBase = ResultBase(json: result)
            if result.error != nil {
                self.view?.verhicle(error: error!)
                return
            }
            self.view?.verhicles()
        }
        
    }
    
    func loadBrandName(){
        ParkingManager.instance.getBrandName { (result, error) in
            if result != nil && error == nil {
                let b:BrandNameResult = BrandNameResult(json: result)
                self.view?.getBrandName(didResult: b.data)
                
            }
        }
    }
}
