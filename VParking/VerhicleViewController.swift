//
//  VerhicleViewController.swift
//  VParking
//
//  Created by TD on 3/6/17.
//  Copyright © 2017 xtel. All rights reserved.
//

import UIKit

class VerhicleViewController: UIViewController {
    let localData:UserDefaults = UserDefaults.init()
    @IBOutlet weak var verhicleTableView: UITableView!
    var lblSections: [String] = ["Ô Tô", "Xe Máy"]
    var imgSections: [UIImage] = [#imageLiteral(resourceName: "ic_action_car"), #imageLiteral(resourceName: "ic_action_moto-1")]
    var presenter:VerhiclePresenter?
    var carDictionary = [VerhicleEntity]()
    var carBrandName = [BrandNameEntity]()
    var bikeDictionary = [VerhicleEntity]()
    var bikeBrandName = [BrandNameEntity]()
    var vehicleSelected:VerhicleEntity?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        Initialization()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.verhicleTableView.reloadData()
        Initialization()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func getVehicleSelected() -> VerhicleEntity?{
        return self.vehicleSelected;
    }
}

extension VerhicleViewController: IVerhicleView{
    func Initialization() {
        presenter = VerhiclePresenter(self)
        verhicleTableView.dataSource = self
        verhicleTableView.delegate = self
        verhicleTableView.tableFooterView = UIView()
        presenter?.loadVerhicle()
    }
    func getVerhicle(didResult data: [VerhicleEntity]?, error: NIPError?) {
        if let v = data {
            
            for i in v {
                if i.type == 1{
                    self.carDictionary.append(i)
                    self.carBrandName.append(i.brandname)
                }else {
                    self.bikeDictionary.append(i)
                    self.bikeBrandName.append(i.brandname)
                }
            }
            DispatchQueue.main.async {
                self.verhicleTableView.reloadData()
            }
        }
        
    }
    func showError(_ message: String) {
        print(message)
    }
    
}

extension VerhicleViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        let image = UIImageView(image: imgSections[section])
        image.frame = CGRect(x: 5, y: 5, width: 35, height: 35)
        view.addSubview(image)
        
        let label = UILabel()
        label.text = lblSections[section]
        label.frame = CGRect(x: 45, y: 5, width: 100, height: 35)
        view.addSubview(label)
        return view
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0{
            return self.carDictionary.count
            
        }else {
            return self.bikeDictionary.count
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:VerhicleTableViewCell = Bundle.main.loadNibNamed("VerhicleTableViewCell", owner: self, options: nil)?.first as! VerhicleTableViewCell
        
        if indexPath.section == 0{
            cell.lblVerhicleName.text = carDictionary[indexPath.row].name
            cell.lblPlate.text = carDictionary[indexPath.row].plate_number
            cell.lblBrandName.text = carBrandName[indexPath.row].name
            if carDictionary[indexPath.row].flag_default == 1{
                cell.imgDefault.image = #imageLiteral(resourceName: "ic_action_green_dot")
            }
            return cell
        } else{
            cell.lblVerhicleName.text = bikeDictionary[indexPath.row].name
            cell.lblPlate.text = bikeDictionary[indexPath.row].plate_number
            cell.lblBrandName.text = bikeBrandName[indexPath.row].name
            if bikeDictionary[indexPath.row].flag_default == 1{
                cell.imgDefault.image = #imageLiteral(resourceName: "ic_action_green_dot")
            }
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0{

            vehicleSelected = carDictionary[indexPath.row]
            
            let addForm = self.storyboard?.instantiateViewController(withIdentifier: "AddVerhicleViewController") as! AddVerhicleViewController
            addForm.Verhicle = vehicleSelected
            let navi = self.navigationController
            navi?.pushViewController(addForm, animated: true)
            addForm.isUpdate = true
            
        }else{
            vehicleSelected = bikeDictionary[indexPath.row]

            let addForm = self.storyboard?.instantiateViewController(withIdentifier: "AddVerhicleViewController") as! AddVerhicleViewController
            addForm.Verhicle = vehicleSelected
            let navi = self.navigationController
            navi?.pushViewController(addForm, animated: true)
            addForm.isUpdate = true

        }
    }
}
