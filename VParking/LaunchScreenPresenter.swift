//
//  LaunchScreenPresenter.swift
//  VParking
//
//  Created by TD on 2/20/17.
//  Copyright © 2017 xtel. All rights reserved.
//

import Foundation
class LaunchScreenPresenter: PresenterBase {
    
    var view:ILaunchScreenView!
    init(view:ILaunchScreenView!) {
        self.view = view
    }
    
    func checkLogin(){
        let session:String? = SessionManager.getCurrentSession()
        if session == nil{
            self.view.showLogin()
        }else{
            self.view?.showHome()
        }
    }
}
