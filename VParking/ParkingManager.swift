//
//  ParkingManager.swift
//  VParking
//
//  Created by TD on 2/19/17.
//  Copyright © 2017 xtel. All rights reserved.
//

import Foundation
import Alamofire
class ParkingManager {
    let baseUrl:String="http://124.158.5.112:9180/p/v1.0/"
    
    static let instance:ParkingManager = ParkingManager()
    
    func loadProfile(completion:@escaping (String?,NIPError?) -> Void){
        HttpRequestManager.get(url: "\(baseUrl)user", headers: getHeader(), completion: completion)
    }
    
    func editProfile(data: ProfileRequest,completion:@escaping (String?,NIPError?) -> Void ){
        let url = "\(baseUrl)user"
        HttpRequestManager.post(url: url, headers: getHeader(), data: data.toDictionary() as? Dictionary<String, AnyObject>, completion: completion)
        
    }
    
    func updatePhoneNumber(data : PhoneRequest, completion:@escaping (String?,NIPError?) -> Void ){
        let url = "\(baseUrl)user/phonenumber"
        HttpRequestManager.post(url: url, headers: getHeader(), data: data.toDictionary() as? Dictionary<String, AnyObject>, completion: completion)
    }
    
    
    func findParking(condition:FindCondition,completion:@escaping (String?,NIPError?) -> Void) {
        var url = "\(baseUrl)find?lat=\(condition.lat!)&lng=\(condition.lng!)"
        
        if condition.begin_time != nil{
            url = "\(url)/&begin_time=\(condition.begin_time!)";
        }
        
        if condition.end_time != nil{
            url = "\(url)/&end_time=\(condition.end_time!)";
        }
        
        if condition.type != nil{
            url = "\(url)/&type=\(condition.type!)";
        }
        
        if condition.price != nil{
            url = "\(url)/&price=\(condition.price!)";
        }
        
        if condition.price_type != nil{
            url = "\(url)/&price_type=\(condition.price_type!)";
        }
        
        HttpRequestManager.get(url: url, headers: getHeader(), completion: completion)
        
    }
    
    func retParkingDetails(id:Int,completion:@escaping (String?,NIPError?) -> Void) {
        let url = "\(baseUrl)info/\(id)"
        HttpRequestManager.get(url: url, headers: getHeader(), completion: completion)
        
    }
    
    func favorite(_ request:ParkingRequest,completion:@escaping (String?,NIPError?)->Void) {
        let url = "\(baseUrl)user/favorite"
        HttpRequestManager.post(url: url, headers: getHeader(),data: request.toDictionary() as? Dictionary<String, AnyObject>, completion: completion)
        
    }
    
    func getFavorite(completion:@escaping (String?,NIPError?)->Void){
        let url = "\(baseUrl)user/favorite"
        HttpRequestManager.get(url: url, headers: getHeader(), completion: completion)
    }
    
    func verhicle(data :VerhicleRequest,completion:@escaping (String?,NIPError?)->Void){
        let url = "\(baseUrl)user/verhicle"
        HttpRequestManager.post(url: url, headers: getHeader(), data: data.toDictionary() as? Dictionary<String, AnyObject>, completion: completion)
    }
    
    func editVerhicle(data :VerhicleRequest,completion:@escaping (String?,NIPError?)->Void){
        let url = "\(baseUrl)user/verhicle"
        HttpRequestManager.put(url: url, headers: getHeader(), data: data.toDictionary() as? Dictionary<String, AnyObject>, completion: completion)
    }
    
    
    func getVerhicle(completion:@escaping (String?,NIPError?)->Void) {
        let url = "\(baseUrl)user/verhicle"
        HttpRequestManager.get(url: url, headers: getHeader(),completion: completion)
    }
    
    func getBrandName(completion:@escaping (String?,NIPError?)->Void){
        let url = "\(baseUrl)verhicle/brandname"
        HttpRequestManager.get(url: url, headers: nil, completion: completion)
    }

    func checkIn(_ request:CheckInEntity,completion:@escaping (String?,NIPError?)->Void) {
        let url = "\(baseUrl)user/checkin"
        HttpRequestManager.post(url: url, headers: getHeader(),data: request.toDictionary() as? Dictionary<String, AnyObject>, completion: completion)
        
    }
    
    func getCheckInList(completion:@escaping (String?,NIPError?)->Void) {
        let url = "\(baseUrl)user/checkin"
        HttpRequestManager.get(url: url, headers: getHeader(),completion: completion)
    }
    
    func checkOut(_ request:CheckOutReq,completion:@escaping (String?,NIPError?)->Void) {
        let url = "\(baseUrl)user/checkout"
        HttpRequestManager.post(url: url, headers: getHeader(),data: request.toDictionary() as? Dictionary<String, AnyObject>, completion: completion)
        
    }
    
    
    
    func getHeader() -> HTTPHeaders?{
        var session:String = ""
        var device_type:Int = 2
        var version_number:Int = 1
        if SessionManager.getCurrentSession() != nil {
            session = SessionManager.getCurrentSession()!
        }
        let headers:HTTPHeaders = [
            "Accept": "application/json;charset=utf-8",
            "session": "\(session)",
            "device-type":  "\(device_type)",
            "version-number": "\(version_number)"
        ]
        print(headers)
        return headers
    }
    
}
