//
//  TicketViewController.swift
//  VParking
//
//  Created by TD on 3/9/17.
//  Copyright © 2017 xtel. All rights reserved.
//

import UIKit

class TicketViewController: UIViewController {

    @IBOutlet weak var lblTicketTime: UILabel!
    @IBOutlet weak var lblTicketVehicle: UILabel!
    @IBOutlet weak var lblParkingName: UILabel!
    @IBOutlet weak var lblParkingAddress: UILabel!
    @IBOutlet weak var lblParkingTime: UILabel!
    @IBOutlet weak var lblParkingPrice: UILabel!
    @IBOutlet weak var imgActionView: UIImageView!
    var presenter:TicketPresenter!
    
    private var _checkInInfo:CheckInInfo?
    private var _delegate:TicketViewDelegate?
    
    var delegate:TicketViewDelegate?{
        set{
            _delegate = newValue
        }
        get{
            return _delegate
        }
    }
    
    var checkInInfo:CheckInInfo?{
        get{return self._checkInInfo}
        set(newValue){self._checkInInfo = newValue}
    }
    
    var p:ParkingInfoEntity?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Initialization()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func checkOut(_ sender: Any) {
        presenter.checkOut((checkInInfo?.transaction)!, ParkingName: (checkInInfo?.parking.parking_name)!)
    }
    
    @IBAction func viewParking(_ sender: Any) {
        if let pk = self.p {
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "ParkingDetails") as? HomeViewController{
                let f:FindParkingEntity = FindParkingEntity()
                f.id = pk.id
                f.lng = pk.lng
                f.lat = pk.lat
                vc.FixedParking = f
                vc.mode = .TICKET
                if let nav = self.navigationController {
                    nav.pushViewController(vc, animated: true)
                }
            }
        }
    }
}

extension TicketViewController : ITicketView {
    func Initialization() {
        presenter = TicketPresenter(self)
        imgActionView.layer.cornerRadius = imgActionView.frame.height/2
        imgActionView.clipsToBounds = true
        
        // init ticket
        if let c = checkInInfo {
            lblTicketTime.text = c.checkin_time
            lblTicketVehicle.text = "\(c.vehicle.name!):\(c.vehicle.plate_number!)"
            presenter.retParkingInfo(c.parking.id)
        }
    }
    
    func showError(message: String) {
        self.view.makeToast(message)
    }
    
    func ticket(didResult p: ParkingInfoEntity) {
        lblParkingName.text = p.parking_name
        lblParkingAddress.text = p.address
        lblParkingTime.text = "\(p.begin_time!) - \(p.end_time!)"
        if p.prices.count > 0 {
           lblParkingPrice.text = "\(Int((p.prices[0].price)))K/\(self.getPriceType(type: (p.prices[0].price_type)))"
        }
        self.p = p
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
    
    func checkOutSuccess() {
        let alert = UIAlertController(title: "Thông báo", message: "Bạn đã checkout ra khỏi bãi gửi xe \((checkInInfo?.parking.parking_name)!)", preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (ac) in
            self.close(){
                () in
                if let d = self.delegate {
                    d.reloadCheckList()
                }
            }
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}
