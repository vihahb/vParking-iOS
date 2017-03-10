//
//  CheckInViewController.swift
//  VParking
//
//  Created by TD on 3/6/17.
//  Copyright © 2017 xtel. All rights reserved.
//

import UIKit

class CheckInViewController: UIViewController {
    @IBOutlet weak var tbCheckIn: UITableView!
    var prenseter:CheckInPresenter!
    var data = [CheckInInfo]()
    override func viewDidLoad() {
        super.viewDidLoad()
        Initialization()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("CheckInViewController:viewWillAppear")
        prenseter.loadCheckIn()
    }
    
}

extension CheckInViewController : ICheckInView {
    func Initialization() {
        prenseter = CheckInPresenter(self)
        tbCheckIn.dataSource = self
        tbCheckIn.delegate = self
    }
    func showError(_ message: String) {
        self.view.makeToast(message)
    }
    
    func checkIn(didResult data: [CheckInInfo]?) {
        if let d = data {
            self.data.removeAll()
            self.data.append(contentsOf: d)
            DispatchQueue.main.async {
                self.tbCheckIn.reloadData()
            }
        }
    }
}

extension CheckInViewController : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:CheckInTableViewCell = Bundle.main.loadNibNamed("CheckInTableViewCell", owner: self, options: nil)?.first as! CheckInTableViewCell
        cell.backgroundColor = UIColor.white
        let c:CheckInInfo = data[indexPath.row]
        cell.lblParkingName.text = c.parking.parking_name
        cell.lblTime.text = c.checkin_time
        cell.lblPlateNumber.text = c.vehicle.plate_number
        switch c.checkin_type {
        case 1:
            cell.imgVehicleType.image = #imageLiteral(resourceName: "ic_action_car")
            break
        case 2:
            cell.imgVehicleType.image = #imageLiteral(resourceName: "ic_action_moto")
            break
        case 3:
            cell.imgVehicleType.image = #imageLiteral(resourceName: "ic_action_bike")
            break
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("index: \(indexPath)")
        
        let checkInInfo:CheckInInfo = self.data[indexPath.row]
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "TicketViewController") as? TicketViewController {
            vc.checkInInfo = checkInInfo
            vc.delegate = self
            self.parent?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension CheckInViewController : TicketViewDelegate {
    func reloadCheckList() {
        self.prenseter.loadCheckIn()
    }
}
