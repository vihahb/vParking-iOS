//
//  ParkingInfoPresenter.swift
//  VParking
//
//  Created by TD on 3/4/17.
//  Copyright © 2017 xtel. All rights reserved.
//

import Foundation
import GoogleMapsDirections
class ParkingInfoPresenter: PresenterBase {
    var view:IParkingInfoBottomSheet?
    
    init(_ view:IParkingInfoBottomSheet) {
        self.view = view
    }
    
    
    func favorite(_ id:Int){
        let data:ParkingRequest = ParkingRequest()
        data.parking_id = id
        self.view?.showProgress(title: "Đang xử lý thao tác...")
        ParkingManager.instance.favorite(data){
            (result,error) in
            self.view!.closeProgress()
            if error != nil {
                // truong ho het session
                if let errorCode = error?.code, errorCode == 2 { // session ko hợp lệ
                    self.getNewSession(completion: {
                        self.favorite(id)
                    }, didError: {
                        self.view?.showLoginForm()
                    })
                    return
                }
                
                self.view?.favorite(error: error!)
                return
            }
            
            let result:ResultBase = ResultBase(json: result)
            
            if result.error != nil {
                self.view?.favorite(error: error!)
                return
            }
            
            self.view?.favorite()
        }
    }
    
    func findRouter(latOrigin:Double,lngOrigin:Double,latDestination:Double,lngDestination:Double){
            let origin = GoogleMapsDirections.Place.coordinate(coordinate: GoogleMapsService.LocationCoordinate2D(latitude: latOrigin, longitude: lngOrigin))
            let destination = GoogleMapsDirections.Place.coordinate(coordinate: GoogleMapsService.LocationCoordinate2D(latitude: latDestination, longitude: lngDestination))
            self.view?.showProgress(title: "Đang tìm đường...!")
            GoogleMapsDirections.direction(fromOrigin: origin, toDestination: destination){(response,error) -> Void in
                self.view?.closeProgress()
                guard response?.status == GoogleMapsDirections.StatusCode.ok else{
                    let nError:NIPError = NIPError()
                    nError.code = -1
                    nError.message = response?.errorMessage
                    self.view?.findRoute(nil, error: nError)
                    return
                }
                if let route = response?.routes, route.count > 0 {
                    self.view?.findRoute(route[0].overviewPolylinePoints, error: nil)
                    return
                }
                
                let nError:NIPError = NIPError()
                nError.code = -1
                nError.message = "Không tìm thấy chỉ đường"
                self.view?.findRoute(nil, error: nError)
            }
    }
}
