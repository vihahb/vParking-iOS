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
    
    
    
    @IBOutlet weak var imgWhenEmpty: UIImageView!
    @IBOutlet weak var lblWhenEmpty: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Initialization()
        
    }
    
    func whenDicEmpty(){
        
        if self.carDictionary.count != 0 || bikeDictionary.count != 0{
            self.verhicleTableView.isHidden = false
            imgWhenEmpty.isHidden = true
            lblWhenEmpty.isHidden = true
        }else {
            self.verhicleTableView.isHidden = true
            imgWhenEmpty.isHidden = false
            lblWhenEmpty.isHidden = false
        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Initialization()
        self.verhicleTableView.reloadData()
        
        
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
        self.verhicleTableView.dataSource = self
        self.verhicleTableView.delegate = self
        verhicleTableView.tableFooterView = UIView()
        presenter?.loadVerhicle()
        
    }
    func getVerhicle(didResult data: [VerhicleEntity]?, error: NIPError?) {
        self.carDictionary.removeAll()
        self.bikeDictionary.removeAll()
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
       whenDicEmpty()
        
    }
    func showError(_ message: String) {
        print(message)
    }
    
}

extension VerhicleViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        if carDictionary.count == 0 || bikeDictionary.count == 0{
            return 1
        }else {
            return 2
        }
        
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        var sec:Int?
        if carDictionary.count == 0 {
            sec = 1
        }else if bikeDictionary.count == 0 {
            sec = 0
        }else{
            sec = section
        }
        
        
        let view = UIView()
        view.backgroundColor = UIColor.init(red: 230/255, green: 231/255, blue: 232/255, alpha: 1)
        let image = UIImageView(image: imgSections[sec!])
        image.frame = CGRect(x: 5, y: 5, width: 35, height: 35)
        view.addSubview(image)
        let label = UILabel()
        label.text = lblSections[sec!]
        label.frame = CGRect(x: 45, y: 5, width: 100, height: 35)
        view.addSubview(label)
        
        return view
        
       
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if carDictionary.count == 0{
            return self.bikeDictionary.count
        }else if bikeDictionary.count == 0{
            return self.carDictionary.count
        }else {
            if section == 0{
                return self.carDictionary.count
            }else {
                return self.bikeDictionary.count
            }
        }
        
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell:VerhicleTableViewCell = Bundle.main.loadNibNamed("VerhicleTableViewCell", owner: self, options: nil)?.first as! VerhicleTableViewCell
        
        if carDictionary.count == 0{
            cell.lblVerhicleName.text = bikeDictionary[indexPath.row].name
            cell.lblPlate.text = bikeDictionary[indexPath.row].plate_number
            cell.lblBrandName.text = bikeBrandName[indexPath.row].name
            if bikeDictionary[indexPath.row].flag_default == 1{
                cell.imgDefault.image = #imageLiteral(resourceName: "ic_action_green_dot")
            }
            return cell
        }else if bikeDictionary.count == 0 {
            cell.lblVerhicleName.text = carDictionary[indexPath.row].name
            cell.lblPlate.text = carDictionary[indexPath.row].plate_number
            cell.lblBrandName.text = carBrandName[indexPath.row].name
            if carDictionary[indexPath.row].flag_default == 1{
                cell.imgDefault.image = #imageLiteral(resourceName: "ic_action_green_dot")
            }
            return cell
        }else {
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
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if carDictionary.count == 0 {
            vehicleSelected = bikeDictionary[indexPath.row]
            
            let addForm = self.storyboard?.instantiateViewController(withIdentifier: "AddVerhicleViewController") as! AddVerhicleViewController
            addForm.Verhicle = vehicleSelected
            addForm.delegate = self
            let navi = self.parent?.navigationController
            navi?.pushViewController(addForm, animated: true)
            addForm.isUpdate = true
        }else if bikeDictionary.count == 0 {
            vehicleSelected = carDictionary[indexPath.row]
            
            let addForm = self.storyboard?.instantiateViewController(withIdentifier: "AddVerhicleViewController") as! AddVerhicleViewController
            addForm.Verhicle = vehicleSelected
            addForm.delegate = self
            let navi = self.parent?.navigationController
            navi?.pushViewController(addForm, animated: true)
            addForm.isUpdate = true
        }else {
            if indexPath.section == 0{
                vehicleSelected = carDictionary[indexPath.row]
                
                let addForm = self.storyboard?.instantiateViewController(withIdentifier: "AddVerhicleViewController") as! AddVerhicleViewController
                addForm.Verhicle = vehicleSelected
                addForm.delegate = self
                let navi = self.parent?.navigationController
                navi?.pushViewController(addForm, animated: true)
                addForm.isUpdate = true
                
            }else{
                vehicleSelected = bikeDictionary[indexPath.row]
                
                let addForm = self.storyboard?.instantiateViewController(withIdentifier: "AddVerhicleViewController") as! AddVerhicleViewController
                addForm.Verhicle = vehicleSelected
                addForm.delegate = self
                let navi = self.parent?.navigationController
                navi?.pushViewController(addForm, animated: true)
                addForm.isUpdate = true
                
            }
        }

    }
}

extension VerhicleViewController : VerhicleViewDelegate{
    func reloadCellList(){
        self.presenter?.loadVerhicle()
        self.verhicleTableView.reloadData()
    }
    
}
