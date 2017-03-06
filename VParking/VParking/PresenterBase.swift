//
//  PresenterBase.swift
//  VParking
//
//  Created by TD on 2/16/17.
//  Copyright © 2017 xtel. All rights reserved.
//

import Foundation
class PresenterBase: NSObject {
    func getNewSession(completion:@escaping ()->Void,didError:@escaping () -> Void){
        let data:AuthenticateEntity = AuthenticateEntity()
        data.devInfo = DeviceUtil.getDeviceInfo()
        data.authenticationid = SessionManager.getAuthozation_Key()
        UserManager.instance.getNewSession(data: data) { (result, error) in
            if error == nil{
                let resultObj:NIPLoginResult = NIPLoginResult(json: result)
                if resultObj.error == nil {
                    SessionManager.setSession(session: resultObj.session!)
                    completion()
                }else{
                    SessionManager.clear()
                    didError()
                }
            }else
            {
                SessionManager.clear()
                didError()
            }
        }
    }
}
