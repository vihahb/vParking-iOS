 //
//  LoginPresenter.swift
//  VParking
//
//  Created by TD on 2/16/17.
//  Copyright © 2017 xtel. All rights reserved.
//

import Foundation
import FBSDKCoreKit
import FBSDKLoginKit
import AccountKit
class LoginPresenter: PresenterBase, AKFViewControllerDelegate {

    var view:ILoginView?
    
    init(view:ILoginView) {
        self.view = view
    }
    
    func loginWithFacebook(controller:UIViewController) {
        let fbLoginManager:FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withPublishPermissions: nil, from: controller){
            (result,error)in
            if error == nil {
                self.loginFacebook(access_token_key: FBSDKAccessToken.current().tokenString)
            }else{
                self.view?.onLoginError(messageError: "Đăng nhập facebook không thành công \(String(describing: error))")
                print(String(describing: error))
            }
        }}
    
    func loginWithPhoneNumber(authozation_key:String) {
        let fbData:AKLoginEntity = AKLoginEntity()
        fbData.authorization_code = authozation_key
        fbData.devInfo = DeviceUtil.getDeviceInfo()
        self.view?.showProgress(title: "Đăng đăng nhập vào hệ thống...!")
        UserManager.instance.accountKitLogin(data: fbData){
            (result,error) in
            self.view?.closeProgress()
            if error == nil{
                let resultObj:NIPLoginResult = NIPLoginResult(json: result)
                if resultObj.error == nil {
                    SessionManager.setSession(session: resultObj.session!)
                    SessionManager.setAuthoziation_Key(authoziation_key: resultObj.authenticationid!)
                    self.view?.onLoginSucces()
                }else{
                    self.view?.onLoginError(messageError: (resultObj.error?.message)!)
                }
            }else
            {
                self.view?.onLoginError(messageError: (error!.message)!)
            }
        }
    }
    
    func viewController(_ viewController: UIViewController!, didFailWithError error: Error!) {
        self.view?.onLoginError(messageError: (error?.localizedDescription)!)
    }
    
    func viewController(_ viewController: UIViewController!, didCompleteLoginWithAuthorizationCode code: String!, state: String!) {
        self.view?.onLoginError(messageError: code)
        loginWithPhoneNumber(authozation_key: code)
       
    }
    func viewController(_ viewController: UIViewController!, didCompleteLoginWith accessToken: AKFAccessToken!, state: String!) {
        self.view?.onLoginError(messageError: accessToken.tokenString)
        
    }
    func viewControllerDidCancel(_ viewController: UIViewController!) {
        self.view?.onLoginError(messageError: "Login cancelled!")
    }
    
    private func loginFacebook(access_token_key:String){
        let fbData:FBLoginEntity = FBLoginEntity()
        fbData.access_token_key = access_token_key
        fbData.devInfo = DeviceUtil.getDeviceInfo()
        self.view?.showProgress(title: "Đăng đăng nhập vào hệ thống...!")
        UserManager.instance.facebookLogin(data: fbData){
            (result,error) in
            self.view?.closeProgress()
            if error == nil{
                let resultObj:NIPLoginResult = NIPLoginResult(json: result)
                if resultObj.error == nil {
                    SessionManager.setSession(session: resultObj.session!)
                    SessionManager.setAuthoziation_Key(authoziation_key: resultObj.authenticationid!)
                    self.view?.onLoginSucces()
                }else{
                    self.view?.onLoginError(messageError: (resultObj.error?.message)!)
                }
            }else
            {
                self.view?.onLoginError(messageError: (error!.message)!)
            }
        }
    }
    
}
