//
//  ParkingInfoBottomsheetViewController.swift
//  VParking
//
//  Created by TD on 2/27/17.
//  Copyright © 2017 xtel. All rights reserved.
//

import UIKit
import ImageSlideshow
import GoogleMaps
enum VCState {
    case full,partial,hidden
}

class ParkingInfoBottomsheetViewController: UIViewController {
    
    @IBOutlet weak var imgSideShow: ImageSlideshow!
    @IBOutlet weak var lblParkingName: UILabel!
    @IBOutlet weak var lblParkingTime: UILabel!
    @IBOutlet weak var lblParkingPrice: UILabel!
    @IBOutlet weak var lblParkingAddress: UILabel!
    
    //
    @IBOutlet weak var lblParkingNameS: UILabel!
    @IBOutlet weak var lblParkingAddressS: UILabel!
    @IBOutlet weak var lblParkingPhoneS: UILabel!
    @IBOutlet weak var imgFavorite: UIImageView!
    @IBOutlet weak var lblParkingTimeS: UILabel!
    @IBOutlet weak var imgCar: UIImageView!
    @IBOutlet weak var imgMoto: UIImageView!
    @IBOutlet weak var imgBike: UIImageView!
    
    // price_view
    @IBOutlet weak var priceView: UIView!
    @IBOutlet weak var priceViewHeight: NSLayoutConstraint!
    
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var btnDirection: UIButton!
    
    
    @IBOutlet weak var patiralView: UIView!
    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    // init
    var fullView: CGFloat = 100
    
    var state:VCState = VCState.hidden
    
    var alamofireSource = [AlamofireSource]()
    
    // init partialView
    var sortViewHeight:CGFloat = 0
    var fullViewHeight:CGFloat = 0
    var isFavorite:Bool = true
    var isDirection:Bool = false
    var favoriteIcon:UIImage?
    
    var height:CGFloat{
        return self.view.frame.height
    }
    
    var width:CGFloat{
        return self.view.frame.width
    }
    
    // ic_action_favorite
    @IBOutlet weak var imgSFavorite: UIImageView!
    
    //
    var parking:ParkingInfoEntity?
    
    var presenter:ParkingInfoPresenter?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Initialization()
        

    }
    
    func Initialization() {
        presenter = ParkingInfoPresenter(self)
        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(ParkingInfoBottomsheetViewController.panGesture))
        gesture.delegate = self
        view.addGestureRecognizer(gesture)
        
        // Init ImageSileShow
        imgSideShow.backgroundColor = UIColor.black
        imgSideShow.slideshowInterval = 5.0
        imgSideShow.pageControlPosition = PageControlPosition.hidden
        imgSideShow.pageControl.currentPageIndicatorTintColor = ColorUtils.hexStringToUIColor(hex: "#b285be")
        imgSideShow.pageControl.pageIndicatorTintColor = UIColor.white
        imgSideShow.contentScaleMode = UIViewContentMode.scaleAspectFill
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ParkingInfoBottomsheetViewController.didTap))
        imgSideShow.addGestureRecognizer(gestureRecognizer)
        
        // init map
        self.mapView.settings.setAllGesturesEnabled(false)
        
        btnDirection.backgroundColor = ColorUtils.hexStringToUIColor(hex: "#b285be")
        btnDirection.setTitleColor(UIColor.white, for: .normal)
        
        roundImage()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        let frame = self.view.frame
        fullView = 0//(self.parent?.navigationController?.navigationBar.frame.height)! + UIApplication.shared.statusBarFrame.height
        fullViewHeight = frame.height - fullView
        sortViewHeight = self.patiralView.frame.height
        scrollView.scrollsToTop = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func roundImage(){
        imgCar.layer.cornerRadius = imgCar.frame.width/2
        imgCar.clipsToBounds = true
        
        imgBike.layer.cornerRadius = imgBike.frame.width/2
        imgBike.clipsToBounds = true
        
        imgMoto.layer.cornerRadius = imgMoto.frame.width/2
        imgMoto.clipsToBounds = true
    }
    
    func didTap() {
        imgSideShow.presentFullScreenController(from: self)
    }
    
    func panGesture(_ recognizer: UIPanGestureRecognizer) {
        if !isDirection{
            let translation = recognizer.translation(in: self.view)
            let velocity = recognizer.velocity(in: self.view)
            let y = self.view.frame.minY
            let translationY = translation.y * self.sortViewHeight / (self.fullViewHeight - self.sortViewHeight)
            if recognizer.state == .changed {
                if ( y + translation.y >= fullView) && (y + translation.y <= self.height) {
                    self.detailsView.frame = CGRect(x: 0, y: self.detailsView.frame.minY + translationY, width: view.frame.width, height: fullViewHeight)
                    self.view.frame = CGRect(x: 0, y: y + translation.y, width: view.frame.width, height: self.height)
                    recognizer.setTranslation(CGPoint.zero, in: self.view)
                }
                
            }
            
            
            if recognizer.state == .ended {
                var duration =  velocity.y < 0 ? Double((y - fullView) / -velocity.y) : Double((sortViewHeight - y) / velocity.y )
                
                duration = duration > 1.3 ? 1 : duration
                
                if  velocity.y > 0 {
                    if (y + translation.y) > (self.view.frame.height - self.sortViewHeight) {
                        self.hiddenBottomSheet()
                        
                    }else{
                        self.showPartialView(duration: duration)
                    }
                    
                } else {
                    self.showFullView(duration: duration)
                }
            }

        }else {
            if let vc = self.parent as? HomeViewController {
                vc.clearDirection()
            }
            hiddenBottomSheet()
        }
        
        
    }
    
    func hiddenBottomSheet() {
        if self.state != .hidden{
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                let frame = self?.view.frame
                let yComponent = self?.view.frame.height
                self?.view.frame = CGRect(x: 0, y: yComponent!, width: frame!.width, height: (self?.height)!)
                self?.detailsView.frame = CGRect(x: 0, y: (self?.sortViewHeight)!, width: (self?.view.frame.width)!, height: (self?.height)! - (self?.sortViewHeight)!)
            })
            self.state = .hidden
        }
        isDirection = false
    }
    
    func showPartialView(duration:Double){
        if !isDirection {
            imgSFavorite.image = favoriteIcon!
        }else{
            imgSFavorite.image = #imageLiteral(resourceName: "ic_close_black_36dp")
        }
        if self.state != .partial{
            UIView.animate(withDuration: duration, delay: 0.0, options: [.allowUserInteraction], animations: {
                print("heigth: \(self.height)")
                self.view.frame = CGRect(x: 0, y: self.height - self.sortViewHeight, width: self.view.frame.width, height: self.height)
                self.detailsView.frame = CGRect(x: 0, y: self.sortViewHeight, width: self.width, height: self.fullViewHeight)
            },completion:nil)
            self.state = .partial
        }
        self.scrollView.scrollToTop()
    }
    
    func showFullView(duration:Double){
        if self.state != .full{
            UIView.animate(withDuration: duration, delay: 0.0, options: [.allowUserInteraction], animations: {
                self.view.frame = CGRect(x: 0, y: self.fullView, width: self.width, height: self.height)
                 self.detailsView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.fullViewHeight)
            },completion:nil)
           
            self.state = .full
        }
        if !self.scrollView.isScrollEnabled {
            self.scrollView.isScrollEnabled = true
        }
    }
    
    func setInfo(parking:ParkingInfoEntity?){
        self.parking = parking
        if parking == nil {
            return
        }
        
        // set info
        lblParkingAddress.text = parking!.address
        lblParkingNameS.text = parking!.address
        
        lblParkingName.text = parking!.parking_name
        lblParkingNameS.text = parking!.parking_name
        
        lblParkingTime.text = "\(parking!.begin_time!) - \(parking!.end_time!)"
        lblParkingTimeS.text = "\(parking!.begin_time!) - \(parking!.end_time!)"
        
        lblParkingPhoneS.text = parking!.parking_phone
        
        if (parking?.prices.count)! > 0 {
            lblParkingPrice.text = "\(Int((parking?.prices[0].price)!))K/\(self.getPriceType(type: (parking?.prices[0].price_type)!))"
        }else{
            lblParkingPrice.text = "Chưa có giá"
        }
        
        if parking?.favorite == 1 {
            favoriteIcon = #imageLiteral(resourceName: "ic_favorite_red")
            imgFavorite.image = #imageLiteral(resourceName: "ic_favorite_red")
            isFavorite = true
        }else{
            favoriteIcon = #imageLiteral(resourceName: "ic_favorite_gray")
            imgFavorite.image = #imageLiteral(resourceName: "ic_favorite_gray")
            isFavorite = false
        }
        
        // set icon favorite
        if(isDirection){
            imgSFavorite.image = #imageLiteral(resourceName: "ic_close_black_36dp")
        }
        
        // set image sideshow
        alamofireSource.removeAll()
        if parking!.pictures.count > 0 {
            parking!.pictures.forEach({ (i) in
                alamofireSource.append(AlamofireSource(urlString: i.url!)!)
            })
        }
        imgSideShow.setImageInputs(alamofireSource)
        
        // clean maker
        self.mapView.clear()
        // add new marker
        var l:CLLocationCoordinate2D = CLLocationCoordinate2D()
        l.latitude = (parking?.lat)!
        l.longitude = (parking?.lng)!
        let m:GMSMarker = GMSMarker(position: l)
        m.icon = #imageLiteral(resourceName: "ic_marker_blue")
        self.mapView.camera = GMSCameraPosition.camera(withTarget: l, zoom: 14.0)
        m.map = self.mapView
        
        // make price view
        makePriceView(data: parking?.prices,empty:parking?.empty_number)
        
        //set icon price
        setIcon(type: parking?.type)
        
        
        caculateContentSize()
    }
    
    func setIcon(type:Int?){
        if type == nil{
            return
        }
        
        switch type! {
        case 1:
            imgCar.image = #imageLiteral(resourceName: "ic_action_car")
            imgMoto.image = #imageLiteral(resourceName: "ic_action_moto")
            imgBike.image = #imageLiteral(resourceName: "ic_action_bike_black")
        case 2:
            imgCar.image = #imageLiteral(resourceName: "ic_action_car")
            imgMoto.image = #imageLiteral(resourceName: "ic_action_car_black")
            imgBike.image = #imageLiteral(resourceName: "ic_action_bike")
        case 3:
            imgCar.image = #imageLiteral(resourceName: "ic_action_car")
            imgMoto.image =  #imageLiteral(resourceName: "ic_action_moto_black")
            imgBike.image = #imageLiteral(resourceName: "ic_action_bike")
        case 4:
            imgCar.image = #imageLiteral(resourceName: "ic_action_car")
            imgMoto.image = #imageLiteral(resourceName: "ic_action_moto_black")
            imgBike.image = #imageLiteral(resourceName: "ic_action_bike_black")
        case 5:
            imgCar.image = #imageLiteral(resourceName: "ic_action_car_black")
            imgMoto.image = #imageLiteral(resourceName: "ic_action_moto_black")
            imgBike.image = #imageLiteral(resourceName: "ic_action_bike_black")
        case 6:
            imgCar.image = #imageLiteral(resourceName: "ic_action_car_black")
            imgMoto.image = #imageLiteral(resourceName: "ic_action_moto_black")
            imgBike.image = #imageLiteral(resourceName: "ic_action_bike_black")
        default:
            imgCar.image = #imageLiteral(resourceName: "ic_action_car")
            imgMoto.image = #imageLiteral(resourceName: "ic_action_moto")
            imgBike.image = #imageLiteral(resourceName: "ic_action_bike")
        }
    }
    
    func caculateContentSize(){
        var contentSize:CGFloat = 0
        
        self.scrollView.updateConstraintsIfNeeded()
        self.priceView.updateConstraintsIfNeeded()
        self.priceView.layoutIfNeeded()
        self.scrollView.layoutIfNeeded()
        print(self.priceView.frame.height)
        self.scrollView.subviews.forEach { (v) in
            print("view:\(v) heiht: \(v.frame.height)")
            if !v.isKind(of: UIImageView.self){
                contentSize += (v.frame.height + 8)
            }
        }
        print("contentSize:\(contentSize)")
        self.scrollView.contentSize = CGSize(width: self.width, height: contentSize + 10)
    }
    
    func makePriceView(data:[PriceEntity]?,empty:String?){
        if data == nil || data!.count <= 0 {
            return
        }
        
        // remove subview
        self.priceView.subviews.forEach { (v) in
            v.removeFromSuperview()
        }
        let height:Int = (data!.count + 1) * 29 + (data!.count)
        let contentHeight:Int = (data!.count) * 29 + (data!.count-1)
        self.priceViewHeight.constant = CGFloat(height)
        
        self.priceView.backgroundColor = ColorUtils.hexStringToUIColor(hex: "#b285be")
        // header
        let bgColorHeader:UIColor = ColorUtils.hexStringToUIColor(hex: "#cbcde2")
        let header:UIStackView = UIStackView()
        let hType:UIView = UIView()
        hType.backgroundColor = bgColorHeader
        let hPrice:UIView = UIView()
        hPrice.backgroundColor = bgColorHeader
        let hEmpty:UIView = UIView()
        hEmpty.backgroundColor = bgColorHeader
        
        
        
        hType.translatesAutoresizingMaskIntoConstraints = false
        hPrice.translatesAutoresizingMaskIntoConstraints = false
        hEmpty.translatesAutoresizingMaskIntoConstraints = false
        priceView.translatesAutoresizingMaskIntoConstraints = false
        header.translatesAutoresizingMaskIntoConstraints = false
        self.priceView.addSubview(header)
        
        // setup contrains header
        header.spacing = 1.0
        header.distribution = .fill
        header.alignment = .fill
        header.axis = .horizontal
        NSLayoutConstraint(item: header, attribute: .leading, relatedBy: .equal, toItem: priceView, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: header, attribute: .trailing, relatedBy: .equal, toItem: priceView, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: header, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 29).isActive = true
        NSLayoutConstraint(item: header, attribute: .top, relatedBy: .equal, toItem: priceView, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        
        // add item to header
        header.addArrangedSubview(hType)
        header.addArrangedSubview(hPrice)
        header.addArrangedSubview(hEmpty)
        NSLayoutConstraint(item: hPrice, attribute: .width, relatedBy: .equal, toItem: hType, attribute: .width, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: hEmpty, attribute: .width, relatedBy: .equal, toItem: hPrice, attribute: .width, multiplier: 2/3, constant: 0).isActive = true
        // type
        let lblType:UILabel = UILabel()
        hType.addSubview(lblType)
        lblType.translatesAutoresizingMaskIntoConstraints = false
        lblType.text = "Loại xe"
        lblType.textColor = UIColor.blue
        lblType.textAlignment = .center
        lblType.font = UIFont.systemFont(ofSize: 14.0)
        NSLayoutConstraint(item: lblType, attribute: .leading, relatedBy: .equal, toItem: hType, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: lblType, attribute: .trailing, relatedBy: .equal, toItem: hType, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: lblType, attribute: .centerY, relatedBy: .equal, toItem: hType, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        // type
        let lblPrice:UILabel = UILabel()
        hPrice.addSubview(lblPrice)
        lblPrice.translatesAutoresizingMaskIntoConstraints = false
        lblPrice.text = "Giá"
        lblPrice.textColor = UIColor.blue
        lblPrice.textAlignment = .center
        lblPrice.font = UIFont.systemFont(ofSize: 14.0)
        NSLayoutConstraint(item: lblPrice, attribute: .leading, relatedBy: .equal, toItem: hPrice, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: lblPrice, attribute: .trailing, relatedBy: .equal, toItem: hPrice, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: lblPrice, attribute: .centerY, relatedBy: .equal, toItem: hPrice, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        
        // vi tri trong
        let lblEmpty:UILabel = UILabel()
        hEmpty.addSubview(lblEmpty)
        lblEmpty.translatesAutoresizingMaskIntoConstraints = false
        lblEmpty.text = "Ví trí trống"
        lblEmpty.textColor = UIColor.blue
        lblEmpty.textAlignment = .center
        
        lblEmpty.font = UIFont.systemFont(ofSize: 14.0)
        NSLayoutConstraint(item: lblEmpty, attribute: .leading, relatedBy: .equal, toItem: hEmpty, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: lblEmpty, attribute: .trailing, relatedBy: .equal, toItem: hEmpty, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: lblEmpty, attribute: .centerY, relatedBy: .equal, toItem: hEmpty, attribute: .centerY, multiplier: 1, constant: 0).isActive = true

        //Content
        let cStack:UIStackView = UIStackView()
        cStack.alignment = .fill
        cStack.distribution = .fill
        cStack.spacing = 1.0
        cStack.translatesAutoresizingMaskIntoConstraints = false
        priceView.addSubview(cStack)
        
        NSLayoutConstraint(item: cStack, attribute: .leading, relatedBy: .equal, toItem: priceView, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: cStack, attribute: .trailing, relatedBy: .equal, toItem: priceView, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: cStack, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: CGFloat(contentHeight)).isActive = true
        NSLayoutConstraint(item: cStack, attribute: .top, relatedBy: .equal, toItem: header, attribute: .bottom, multiplier: 1.0, constant: 1.0).isActive = true
        
        let cEmpty:UIView = UIView()
        cEmpty.backgroundColor = UIColor.white
        cEmpty.translatesAutoresizingMaskIntoConstraints = false
        
        let cType:UIView = UIView()
        cType.backgroundColor = ColorUtils.hexStringToUIColor(hex: "#b285be")
        cType.translatesAutoresizingMaskIntoConstraints = false
        
        let cPrice:UIView = UIView()
        cPrice.backgroundColor = ColorUtils.hexStringToUIColor(hex: "#b285be")
        cPrice.translatesAutoresizingMaskIntoConstraints = false
        
        cStack.addArrangedSubview(cType)
        cStack.addArrangedSubview(cPrice)
        cStack.addArrangedSubview(cEmpty)

        NSLayoutConstraint(item: cEmpty, attribute: .width, relatedBy: .equal, toItem: cType, attribute: .width, multiplier: 2/3, constant: 0).isActive = true
        NSLayoutConstraint(item: cPrice, attribute: .width, relatedBy: .equal, toItem: cType, attribute: .width, multiplier: 1.0, constant: 0).isActive = true
        
        // vi tri trong
        let lblSEmpty:UILabel = UILabel()
        cEmpty.addSubview(lblSEmpty)
        lblSEmpty.translatesAutoresizingMaskIntoConstraints = false
        lblSEmpty.text = empty
        lblSEmpty.textColor = UIColor.black
        lblSEmpty.textAlignment = .center
        
        lblSEmpty.font = UIFont.systemFont(ofSize: 14.0)
        NSLayoutConstraint(item: lblSEmpty, attribute: .leading, relatedBy: .equal, toItem: cEmpty, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: lblSEmpty, attribute: .trailing, relatedBy: .equal, toItem: cEmpty, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: lblSEmpty, attribute: .centerY, relatedBy: .equal, toItem: cEmpty, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        
        
        //
        var u:UIView = UIView()
        var l:UILabel = UILabel()
        var oldPrice:UIView?
        var oldType:UIView?
        var top:CGFloat = 1.0
        var attr:NSLayoutAttribute = NSLayoutAttribute.top
  
        data!.forEach { (p) in
            u = UIView()
            u.translatesAutoresizingMaskIntoConstraints = false
            u.backgroundColor = UIColor.white
            cPrice.addSubview(u)
            //constrains U
            if oldPrice == nil {
                oldPrice = cPrice
                top = 0
                attr = NSLayoutAttribute.top
            }else{
                top = 1.0
                attr = NSLayoutAttribute.bottom
            }
            
            NSLayoutConstraint(item: u, attribute: .leading, relatedBy: .equal, toItem: cPrice, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
            NSLayoutConstraint(item: u, attribute: .trailing, relatedBy: .equal, toItem: cPrice, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
            NSLayoutConstraint(item: u, attribute: .top, relatedBy: .equal, toItem: oldPrice, attribute: attr, multiplier: 1.0, constant: top).isActive = true
            NSLayoutConstraint(item: u, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 29).isActive = true
            oldPrice = u
            
            l = UILabel()
            u.addSubview(l)
            l.translatesAutoresizingMaskIntoConstraints = false
            l.text = "\(Int(p.price))K/\(self.getPriceType(type: p.price_type))"
            l.textColor = UIColor.black
            l.textAlignment = .center
            
            l.font = UIFont.systemFont(ofSize: 14.0)
            NSLayoutConstraint(item: l, attribute: .leading, relatedBy: .equal, toItem: u, attribute: .leading, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: l, attribute: .trailing, relatedBy: .equal, toItem: u, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: l, attribute: .centerY, relatedBy: .equal, toItem: u, attribute: .centerY, multiplier: 1, constant: 0).isActive = true

            u = UIView()
            u.translatesAutoresizingMaskIntoConstraints = false
            u.backgroundColor = UIColor.white
            cType.addSubview(u)
            //constrains U
            if oldType == nil {
                oldType = cType
                top = 0
                attr = NSLayoutAttribute.top
            }else{
                top = 1.0
                attr = NSLayoutAttribute.bottom
            }
            
            NSLayoutConstraint(item: u, attribute: .leading, relatedBy: .equal, toItem: cType, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
            NSLayoutConstraint(item: u, attribute: .trailing, relatedBy: .equal, toItem: cType, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
            NSLayoutConstraint(item: u, attribute: .top, relatedBy: .equal, toItem: oldType, attribute: attr, multiplier: 1.0, constant: top).isActive = true
            NSLayoutConstraint(item: u, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 29).isActive = true
            oldType = u

            l = UILabel()
            u.addSubview(l)
            l.translatesAutoresizingMaskIntoConstraints = false
            l.text = "\(self.getPriceFor(for_: p.price_for))"
            l.textColor = UIColor.black
            l.textAlignment = .center
            
            l.font = UIFont.systemFont(ofSize: 14.0)
            NSLayoutConstraint(item: l, attribute: .leading, relatedBy: .equal, toItem: u, attribute: .leading, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: l, attribute: .trailing, relatedBy: .equal, toItem: u, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: l, attribute: .centerY, relatedBy: .equal, toItem: u, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        }
    }
    
    
    func getPriceType(type:Int) -> String{
        switch type {
        case 1:
            return "Giờ"
        case 2:
            return "Lượt"
        case 3:
            return "Qua đêm"
        default:
            return "Khác"
        }
    }
    
    func getPriceFor(for_:Int) -> String{
        switch for_ {
        case 1:
            return "Xe đạp"
        case 2:
            return "Xe máy"
        case 3:
            return "Xe ôtô"
        default:
            return "Khác"
        }
    }

}

extension ParkingInfoBottomsheetViewController{
    @IBAction func directions(_ sender: Any) {
        if let myLocation = (self.parent as? HomeViewController)?.myLocation {
            presenter?.findRouter(latOrigin: myLocation.latitude, lngOrigin: myLocation.longitude, latDestination: (parking!.lat), lngDestination: parking!.lng)
        }
    }
    
    @IBAction func favoriteSClick(_ sender: Any) {
        if !isDirection {
            presenter!.favorite(parking!.id)
        }else{
            if let vc = self.parent as? HomeViewController {
                vc.clearDirection()
            }
            hiddenBottomSheet()
        }
    }
    
    @IBAction func favoriteClick(_ sender:Any){
        presenter!.favorite(parking!.id)
    }
    
}

extension ParkingInfoBottomsheetViewController: UIGestureRecognizerDelegate {
    
    // Solution
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        let gesture = (gestureRecognizer as! UIPanGestureRecognizer)
        let direction = gesture.velocity(in: view).y
        
        let y = view.frame.minY
        print("gestureRecognizer:\(y) fullView:\(fullView)")
        if scrollView.contentOffset.y == 0 && direction > 0 {
            scrollView.isScrollEnabled = false
        } else {
            scrollView.isScrollEnabled = true
        }
        
        return false
    }
    
    
    
}

// xu ly handle tab favorie
extension ParkingInfoBottomsheetViewController{
    
}

extension UIScrollView{
    func scrollToTop() {
        self.setContentOffset(
            CGPoint(x: 0,y: -self.contentInset.top),
            animated: true)
    }
}

