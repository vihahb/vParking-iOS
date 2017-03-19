//
//  HttpRequestManager.swift
//  VParking
//
//  Created by TD on 2/17/17.
//  Copyright © 2017 xtel. All rights reserved.
//

import Foundation
import Alamofire
import EVReflection
class HttpRequestManager{
    
    static func get(url:String ,headers:HTTPHeaders?, completion:@escaping (String?,NIPError?)->Void){
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers)
            .responseString(queue: nil,encoding: .utf8, completionHandler: {
                response in
                if let err:Error = response.error {
                    let error:NIPError = NIPError()
                    error.code = -1;
                    error.message  = err.localizedDescription
                    completion(nil,error)
                    return
                }
                completion(response.value,nil)
            })
        
    }
    
    static func delete(url:String ,headers:HTTPHeaders?, completion:@escaping (String?,NIPError?)->Void){
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers)
            .responseString(completionHandler: {
                response in
                if let err:Error = response.error {
                    let error:NIPError = NIPError()
                    error.code = -1;
                    error.message  = err.localizedDescription
                    completion(nil,error)
                    return
                }
                completion(response.value,nil)
            })
        
    }

    
    static func post(url:String ,headers:HTTPHeaders?,data:Dictionary<String,AnyObject>?, completion:@escaping (String?,NIPError?)->Void){
        Alamofire.request(url, method: .post, parameters: data, encoding: JSONEncoding(), headers: headers)
            .responseString(completionHandler: {
                response in
                if let err:Error = response.error {
                    let error:NIPError = NIPError()
                    error.code = -1;
                    error.message  = err.localizedDescription
                    completion(nil,error)
                    return
                }
                completion(response.value,nil)
            })
        
    }
    
    static func put(url:String ,headers:HTTPHeaders?,data:Dictionary<String,AnyObject>?, completion:@escaping (String?,NIPError?)->Void){
        Alamofire.request(url, method: .put, parameters: data, encoding: URLEncoding.default, headers: headers)
            .responseString(completionHandler: {
                response in
                if let err:Error = response.error {
                    let error:NIPError = NIPError()
                    error.code = -1;
                    error.message  = err.localizedDescription
                    completion(nil,error)
                    return
                }
                completion(response.value,nil)
            })
        
    }
    
    
    
}
