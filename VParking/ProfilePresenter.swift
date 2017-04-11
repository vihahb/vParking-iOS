//
//  ProfilePresenter.swift
//  VParking
//
//  Created by Thanh Lee on 3/22/17.
//  Copyright © 2017 xtel. All rights reserved.
//

import Foundation
class ProfilePresenter: PresenterBase {
    var view:IProfileView?
    init(_ view:IProfileView) {
        self.view = view
    }
    
    func putProfile(_ data: ProfileRequest){
        self.view?.showProgress(title: "Đang xử lý thao tác...")
        ParkingManager.instance.editProfile(data: data) { (result, error) in
            self.view?.closeProgress()
            if error != nil {
                if let errorCode = error?.code, errorCode == 2 {
                    self.getNewSession(completion: { 
                        self.putProfile(data)
                    }, didError: { 
                        self.view?.showLoginForm()
                    })
                    return
                }
                self.view?.profile(error : error!)
                return
            }
            let result: ResultBase = ResultBase(json: result)
            if result.error != nil {
                self.view?.profile(error: error!)
                return
            }
            self.view?.profile()
        }
    }
    

    
}
