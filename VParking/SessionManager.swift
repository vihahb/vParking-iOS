//
//  SessionManager.swift
//  VParking
//
//  Created by TD on 2/17/17.
//  Copyright © 2017 xtel. All rights reserved.
//

import Foundation
class SessionManager{
    public static var currentSession:String?
    public static var authoziation_key:String?
    static let localData:UserDefaults = UserDefaults.init()
    static let SESSION_KEY = "session"
    static let AUTHOZIATION_KEY = "authoziation_key"
    
    
    static func setSession(session:String){
        SessionManager.currentSession = session
        localData.set(session, forKey: SESSION_KEY)
    }
    
    static func setAuthoziation_Key(authoziation_key:String){
        SessionManager.authoziation_key = authoziation_key;
        localData.set(authoziation_key, forKey: AUTHOZIATION_KEY)
    }
    
    static func getCurrentSession() -> String?{
        if currentSession == nil{
            currentSession = localData.string(forKey: SESSION_KEY)
        }
        return currentSession;
    }
    
    static func getAuthozation_Key() -> String?{
        
        if authoziation_key == nil{
            authoziation_key = localData.string(forKey: AUTHOZIATION_KEY)
        }
        return authoziation_key;
    }
    
    static func clear(){
        localData.removeObject(forKey: SESSION_KEY)
        localData.removeObject(forKey: AUTHOZIATION_KEY)
    }
    
}
