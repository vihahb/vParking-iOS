//
//  FavoriteViewController.swift
//  VParking
//
//  Created by TD on 3/6/17.
//  Copyright © 2017 xtel. All rights reserved.
//

import UIKit
import AlamofireImage

class FavoriteViewController: UIViewController {
    @IBOutlet weak var favoriteTableView: UITableView!
    @IBOutlet weak var imgWhenEmpty: UIImageView!
    @IBOutlet weak var lblWhenEmpty: UILabel!
    
    var presenter:FavoritePresenter?
    var favoriteDictonary = [FavoriteEntity]()
    var p:ParkingInfoEntity?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Initialization()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Initialization()
        self.favoriteTableView.reloadData()
    }
    
    func whenDicEmpty(){
        if self.favoriteDictonary.count != 0 {
            imgWhenEmpty.isHidden = true
            lblWhenEmpty.isHidden = true
        }else {
            imgWhenEmpty.isHidden = false
            lblWhenEmpty.isHidden = false
        }
    }
}


extension FavoriteViewController:IFavoriteView {
    func Initialization() {
       
        presenter                               = FavoritePresenter(self)
        self.favoriteTableView.delegate         = self
        self.favoriteTableView.dataSource       = self
        self.favoriteTableView.tableFooterView  = UIView()
        presenter?.loadFavorite()
        
        
        
    }
    func infoParking(didResult p: ParkingInfoEntity) {
        self.p = p
        
    }
    
    func getFavorite(didResult data: [FavoriteEntity]?, error: NIPError?) {
        if let f = data {
            self.favoriteDictonary.removeAll()
            self.favoriteDictonary.append(contentsOf: f)
            DispatchQueue.main.async {
                self.favoriteTableView.reloadData()
            }
        }
        whenDicEmpty()
    }
    func showError(_ message: String) {
        print(message)
    }
}

extension FavoriteViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.favoriteDictonary.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:FavoriteTableViewCell  = Bundle.main.loadNibNamed("FavoriteTableViewCell", owner: self, options: nil)?.first as! FavoriteTableViewCell

        
        cell.lblParkingAddress.text     = favoriteDictonary[indexPath.row].address
        cell.lblParkingName.text        = favoriteDictonary[indexPath.row].parking_name
        cell.lblParkingTime.text        = favoriteDictonary[indexPath.row].end
        cell.lblParkingMoney.text       = String(favoriteDictonary[indexPath.row].price)
        
        if let url = URL.init(string: favoriteDictonary[indexPath.row].image!){
            cell.imgParking.af_setImage(withURL: url)
        }
        

        cell.imgParking.contentMode = .scaleToFill
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let xem = UITableViewRowAction(style: .default, title: "Xem") { (action, indexPath) in
            var id:Int = self.favoriteDictonary[indexPath.row].id
            self.presenter?.retParkingInfo(id)
            if let pk = self.p {
                if let vc = self.storyboard?.instantiateViewController(withIdentifier: "ParkingDetails") as? HomeViewController{
                    let f:FindParkingEntity = FindParkingEntity()
                    f.id            = pk.id
                    f.lng           = pk.lng
                    f.lat           = pk.lat
                    vc.FixedParking = f
                    vc.mode         = .TICKET
                    if let navi     = self.navigationController{
                        navi.pushViewController(vc, animated: true)
                    }
                }
            }

        }
        let xoa = UITableViewRowAction(style: .destructive, title: "Xoá") { (action, indexPath) in
            
            var myAlert     = UIAlertController(title: "Thông báo", message: "Xóa bãi đỗ khỏi danh sách yêu thích ?", preferredStyle: UIAlertControllerStyle.alert)
            let okAction    = UIAlertAction(title: "Đồng ý", style: UIAlertActionStyle.destructive, handler: { (ACTION) in
                var id:Int              = self.favoriteDictonary[indexPath.row].id
                let data:ParkingRequest = ParkingRequest()
                data.parking_id         = id
                ParkingManager.instance.favorite(data, completion: { (result, error) in
                })
                self.favoriteDictonary.remove(at: indexPath.row)
                self.favoriteTableView.deleteRows(at: [indexPath], with: .automatic)
            })
            let cancelAction = UIAlertAction(title: "Hủy bỏ", style: UIAlertActionStyle.cancel, handler: { (ACTION) in
            })
            
            myAlert.addAction(okAction)
            myAlert.addAction(cancelAction)
            
            self.present(myAlert, animated: true, completion: nil)
 
        }
        xem.backgroundColor = UIColor.init(red: 92/255, green: 92/255, blue: 167/255, alpha: 1)
        xoa.backgroundColor = UIColor.red
        return [xoa, xem]

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        var id:Int = self.favoriteDictonary[indexPath.row].id
        self.presenter?.retParkingInfo(id)
        if let pk = self.p {
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "ParkingDetails") as? HomeViewController{
                let f:FindParkingEntity = FindParkingEntity()
                f.id            = pk.id
                f.lng           = pk.lng
                f.lat           = pk.lat
                vc.FixedParking = f
                vc.mode         = .TICKET
                if let navi     = self.navigationController{
                    navi.pushViewController(vc, animated: true)
                }
            }
        }
    }

    
}
