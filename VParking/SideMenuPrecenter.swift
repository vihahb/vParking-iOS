//
//  SideMenuPrecenter.swift
//  VParking
//
//  Created by TD on 2/19/17.
//  Copyright © 2017 xtel. All rights reserved.
//

import Foundation
class SideMenuPresenter: PresenterBase {
    let localData:UserDefaults = UserDefaults.init()
//    let PROFILE_KEY:String = "PROFILE_KEY"
    var view:ISideMenuView?
    init(view:ISideMenuView?) {
        self.view = view
    }
    
    func loadProfile() {
        clearUserLocal()
        
        let profile:UserProfileEntity? = getLocalUserProfile()
        
        if profile == nil {
            ParkingManager.instance.loadProfile(){
                (result,error) in
                if error != nil{
                    self.view?.onLoadProfileFail(message: error?.message!)
                    return
                }
                
                let userInfo:UserProfileEntity = UserProfileEntity(json: result!)
                
                if userInfo.error != nil{
                    self.view?.onLoadProfileFail(message: (userInfo.error?.message))
                    return
                }
                self.saveLocalUserInfo(profile: userInfo)
                self.view?.onLoadProfileSuccess(info: userInfo)
            }
        }else{
            view?.onLoadProfileSuccess(info: profile!)
        }
    }
    
    func logout(){
        clearUserLocal()
        SessionManager.clear()
        self.view?.onLogoutSuccess()
    }
    
    
    func getLocalUserProfile() -> UserProfileEntity?{
        var profile:UserProfileEntity?
        if localData.string(forKey: "full_name") == nil {
            return nil
        }
        
        profile = UserProfileEntity()
        profile?.avatar = localData.string(forKey: "avatar")
        profile?.birthday = localData.string(forKey: "birthday")
        profile?.email = localData.string(forKey: "email")
        profile?.gender = localData.integer(forKey: "gender")
        profile?.fullname = localData.string(forKey: "full_name")
        profile?.phone = localData.string(forKey: "phone")
        return profile
    }
    
    func saveLocalUserInfo(profile:UserProfileEntity?){
        if profile == nil {
            return
        }
        localData.set(profile?.avatar, forKey: "avatar")
        localData.set(profile?.birthday, forKey: "birthday")
        localData.set(profile?.email, forKey: "email")
        localData.set(profile?.fullname, forKey: "full_name")
        localData.set(profile?.gender, forKey: "gender")
        localData.set(profile?.phone, forKey: "phone")
    }
    
    func clearUserLocal(){
        localData.removeObject(forKey: "avatar")
        localData.removeObject(forKey: "birthday")
        localData.removeObject(forKey: "email")
        localData.removeObject(forKey: "full_name")
        localData.removeObject(forKey: "gender")
        localData.removeObject(forKey: "phone")
    }
    
    
    class LoadProfileHandle: IRestFulResult {
        var presenter:SideMenuPresenter
        init(presenter:SideMenuPresenter) {
            self.presenter = presenter
        }
        
        func onResult(result: String?, error: NIPError?) {
            if error != nil{
                self.presenter.view?.onLoadProfileFail(message: error?.message!)
                return
            }
            
            let userInfo:UserProfileEntity = UserProfileEntity(json: result!)
            
            if userInfo.error != nil{
                self.presenter.view?.onLoadProfileFail(message: (userInfo.error?.message))
                return
            }
            self.presenter.saveLocalUserInfo(profile: userInfo)
            self.presenter.view?.onLoadProfileSuccess(info: userInfo)
            
        }
    }
}
