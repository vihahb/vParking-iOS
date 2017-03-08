//
//  LoginPresenter.swift
//  VParking
//
//  Created by TD on 2/16/17.
//  Copyright © 2017 xtel. All rights reserved.
//

import Foundation
protocol ILoginView : IViewBase {
   func onLoginSucces()
    func onLoginError(messageError:String)
}
