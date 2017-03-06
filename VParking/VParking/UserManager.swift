//
//  UserManager.swift
//  VParking
//
//  Created by TD on 2/17/17.
//  Copyright © 2017 xtel. All rights reserved.
//

import Foundation
import Alamofire
class UserManager{
    let baseUrl:String = "http://124.158.5.112:9180/nipum/v1.0/m/user/"
    
    static let instance:UserManager = UserManager();
    
    func facebookLogin(data:FBLoginEntity,completion:@escaping (String?,NIPError?)->Void){
        
        HttpRequestManager.post(url: "\(baseUrl)fb/login", headers: getHeader(), data: data.toDictionary() as? Dictionary<String, AnyObject>, completion: completion)
    }
    
    func accountKitLogin(data:AKLoginEntity,completion:@escaping (String?,NIPError?)->Void){
        
        HttpRequestManager.post(url: "\(baseUrl)accountkit/login", headers: getHeader(), data: data.toDictionary() as? Dictionary<String, AnyObject>, completion: completion)
    }
    
    func getNewSession(data:AuthenticateEntity,completion:@escaping (String?,NIPError?)->Void){
        HttpRequestManager.post(url: "\(baseUrl)authenticate", headers: getHeader(), data: data.toDictionary() as? Dictionary<String, AnyObject>, completion: completion)
    }
    
    
    func getHeader() -> HTTPHeaders?{
        
        let headers:HTTPHeaders = [
            "Accept": "application/json"
        ]
        
        return headers
    }
}
