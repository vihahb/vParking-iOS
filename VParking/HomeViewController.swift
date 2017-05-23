//
//  HomeViewController.swift
//  VParking
//
//  Created by TD on 2/16/17.
//  Copyright © 2017 xtel. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import SVProgressHUD
import Polyline

enum HOME_MODE{
    case HOME
    case TICKET
    case FAVORITE
}
class HomeViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var mapView: GMSMapView!
    var presenter:HomePresenter?
    var locationManager = CLLocationManager()
    
    var didFindMyLocation = false
    
    // place complated view
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    var isLoadData:Bool  = true
    
    @IBOutlet weak var searchView: UIView!
    
    // save parking location
    var parkingDictionary = [Int:FindParkingEntity]()
    
    // Bottomsheet
    var bottomSheet:ParkingInfoBottomsheetViewController?
    
    // my location
    var myLocation:CLLocationCoordinate2D?
    var isDirection:Bool = false
    
    var mode:HOME_MODE = .HOME
    
    var markerSelected:GMSMarker?
    var markerSelectedOriginImage:UIImage?
    var isTapMarker:Bool = false
    
    // bar status
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    
    // fixed Parking
    private var _parking:FindParkingEntity?
    
    var FixedParking:FindParkingEntity?{
        get{
            return _parking
        }
        set{
            _parking = newValue
            if let p = newValue {
                parkingDictionary[p.id] = p
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Initialization()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // add bottom sheet
        self.addBottomSheet()
        if let p = _parking, mode != HOME_MODE.HOME {
            let position:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: p.lat, longitude: p.lng)
            mapView.camera = GMSCameraPosition.camera(withTarget: position, zoom: 14.0)
            pinParkingOnMap(p: p)
            self.presenter?.retParkingDetails(id: p.id)
        }
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func loadView() {
        super.loadView()
    }
    
    func Initialization() {
        presenter = HomePresenter(view: self)
        // init google map
        let camera = GMSCameraPosition.camera(withLatitude: 21.025905, longitude: 105.779800, zoom: 14.0)
        self.mapView.camera = camera
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        mapView.delegate = self
        
        // init location manager
        locationManager.distanceFilter = 10
        locationManager.delegate = self
        if CLLocationManager.authorizationStatus() == .denied{
            locationManager.requestWhenInUseAuthorization()
        }else{
            
            locationManager.startUpdatingLocation()

        }
        
        //
        
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        searchController?.searchBar.sizeToFit()
        searchController?.hidesNavigationBarDuringPresentation = false
        searchView.addSubview((searchController?.searchBar)!)
        definesPresentationContext = true
        
    }
    
    func addBottomSheet() {
        if self.bottomSheet == nil{
            self.bottomSheet = storyboard?.instantiateViewController(withIdentifier: "ParkingDetail") as? ParkingInfoBottomsheetViewController
            self.addChildViewController(bottomSheet!)
            self.view.addSubview(bottomSheet!.view)
            bottomSheet!.view.frame = CGRect(x: CGFloat(0), y: self.view.frame.height, width: self.view.frame.width, height: self.view.frame.height)
            self.bottomSheet!.didMove(toParentViewController: self)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.authorizedWhenInUse {
             locationManager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        if mode == .HOME {
            moveCamara(locations[0].coordinate)
        }
        myLocation = locations[0].coordinate
    }
    
    func moveCamara(_ coordinates:CLLocationCoordinate2D){
        mapView.animate(with: GMSCameraUpdate.setTarget(coordinates))
    }
    
    func selectedMarker(_ marker:GMSMarker){
        clearSelected()
        
        self.markerSelected = marker
        self.markerSelectedOriginImage = marker.icon
        marker.icon = #imageLiteral(resourceName: "ic_marker_red")
        moveCamara(marker.position)
    }
    
    func clearSelected(){
        if let m = self.markerSelected,!self.isTapMarker {
            m.icon = self.markerSelectedOriginImage
        }
    }
    
    
    
}

extension HomeViewController:IHomeView{
    func findParking(didError error: NIPError?, didLoaded result: [FindParkingEntity]?) {
        if error != nil {
            print("\(String(describing: error))")
        }
        DispatchQueue.main.async {
            if result != nil{
                result?.forEach({ p in
                    if self.parkingDictionary[p.id] == nil {
                        self.pinParkingOnMap(p: p)
                    }
                })
            }
        }
        
    }
    
    func pinParkingOnMap(p:FindParkingEntity){
        let position = CLLocationCoordinate2D(latitude: p.lat, longitude: p.lng)
        let m = GMSMarker(position: position)
        
        // tam toi comment ko mo voi ban cho nguoi dung chi mo cho ban vip
//        if p.owner == 0 {
//            m.icon = #imageLiteral(resourceName: "ic_marker_blue")
//        }else{
//            m.icon = #imageLiteral(resourceName: "ic_marker_red")
//        }
        
        m.icon = #imageLiteral(resourceName: "ic_marker_blue")
        
        m.map = mapView
        m.userData = p.id
        parkingDictionary[p.id] = p
    }
    
    func retParkingDetails(didError error: NIPError?, didLoaded result: ParkingInfoEntity?) {
        if error != nil {
            self.view.makeToast("\(String(describing: error?.message))")
            return
        }
        bottomSheet?.setInfo(parking: result)
        bottomSheet?.showPartialView(duration: 0.3)
        
    }
    
    func getMyLocation() -> CLLocationCoordinate2D? {
        return self.myLocation
    }
    
    func drawbleDirection(_ pathEncode: String, id: Int) {
        isDirection = true
        mapView.clear()
        if let p = parkingDictionary[id] {
            let position = CLLocationCoordinate2D(latitude: p.lat, longitude: p.lng)
            let m = GMSMarker(position: position)
 // tam toi comment ko mo voi ban cho nguoi dung chi mo cho ban vip
//            if p.owner == 0 {
//                m.icon = #imageLiteral(resourceName: "ic_marker_blue")
//            }else{
//                m.icon = #imageLiteral(resourceName: "ic_marker_red")
//            }
            m.icon = #imageLiteral(resourceName: "ic_marker_blue")
            
            m.map = mapView
            m.userData = p.id
        }
        
        DispatchQueue.main.async() {
            let path  = GMSPath(fromEncodedPath: pathEncode)
            let pl:GMSPolyline  = GMSPolyline(path: path)
            pl.strokeWidth = 8
            pl.strokeColor = ColorUtils.hexStringToUIColor(hex: "#62B1F6")
            pl.map = self.mapView
            
//            let po:Polyline = Polyline(encodedPolyline: pathEncode)
//            
//            if let a = po.coordinates {
//                
            var bounds = GMSCoordinateBounds()
//
//          
//            for index in 0...path?.count() {
                bounds = bounds.includingPath(GMSPath(fromEncodedPath: pathEncode)!)
//                bounds.inc
//            }
            
            
            self.mapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 70))
//            }
            
        }
        
       
        
    }
    
    func clearDirection() {
            if isDirection {
                isDirection = false
                mapView.clear()
                for (_,p) in parkingDictionary {
                    let position = CLLocationCoordinate2D(latitude: p.lat, longitude: p.lng)
                    let m = GMSMarker(position: position)
               // tam toi comment ko mo voi ban cho nguoi dung chi mo cho ban vip
//                    if p.owner == 0 {
//                        m.icon = #imageLiteral(resourceName: "ic_marker_blue")
//                    }else{
//                        m.icon = #imageLiteral(resourceName: "ic_marker_red")
//                    }
                    m.icon = #imageLiteral(resourceName: "ic_marker_blue")
                    m.map = mapView
                    m.userData = p.id
                }
            }
    }
    
    func showToast(_ message: String) {
        self.view.makeToast(message)
    }

}

extension HomeViewController: GMSMapViewDelegate{
    
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        locationManager.startUpdatingLocation()
        return true
    }
    
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        if mode == .HOME {
            if !isDirection {
//                DispatchQueue.main.async {
                    let lat:Double = position.target.latitude
                    let lng:Double = position.target.longitude
                    if self.isLoadData {
                        self.presenter?.findParking(lat: lat, lng: lng)
                    }
                    
                    self.isLoadData = true
//                }
            }
        }
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        if mode == .HOME { // thuc hien tac vu nay khi no la man hinh home
            if !isDirection {
                self.bottomSheet?.hiddenBottomSheet()
                self.isTapMarker = false
            }
        }
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        if !isDirection {
            isLoadData = false
//            mapView.camera = GMSCameraPosition.camera(withTarget: marker.position, zoom: 14.0)
            selectedMarker(marker)
            self.isTapMarker = true
            self.presenter?.retParkingDetails(id: marker.userData as! Int)
        }
        return true
    }
}

extension HomeViewController: GMSAutocompleteResultsViewControllerDelegate {
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        mapView.camera = GMSCameraPosition.camera(withTarget: place.coordinate, zoom: 14.0)
        
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didFailAutocompleteWithError error: Error){
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}



