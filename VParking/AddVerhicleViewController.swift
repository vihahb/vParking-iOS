//
//  AddVerhicleViewController.swift
//  VParking
//
//  Created by Thanh Lee on 3/15/17.
//  Copyright © 2017 xtel. All rights reserved.
//

import UIKit
import DropDown

class AddVerhicleViewController: UIViewController {
    
    var presenter:AddVerhiclePresenter?
    var dropDown:DropDown = DropDown()
    var brandName = [String]()
    var brandObj = [BrandNameEntity]()
    var brand = [BrandNameEntity]()
    var brandRe:BrandNameEntity?
    var index:Int = 0
    var fdDefault:Int = 0
    var isDefault:Bool = true
    
    @IBOutlet weak var segVerhicleType: UISegmentedControl!
    @IBOutlet weak var dropDownView: UIView!
    @IBOutlet weak var imgDropDown: UIImageView!
    @IBOutlet weak var lblBrandName: UILabel!
    @IBOutlet weak var txtFVerhicleName: UITextField!
    @IBOutlet weak var txtFVerhiclePlate: UITextField!
    @IBOutlet weak var txtFDesc: UITextField!
    @IBOutlet weak var imgDefault: UIImageView!
    
    var type:Int = 0
    @IBAction func segAVerhicleType(_ sender: Any) {
        switch segVerhicleType.selectedSegmentIndex {
        case 0:
            type = 1
        case 1:
            type = 2
        default:
            break
        }
    }

    @IBAction func defaultTap(_ sender: Any) {
        verhicles()
    }
    
    @IBAction func AddVerhicle(_ sender: Any) {
        
//        let addForm:VerhicleViewController = self.storyboard?.instantiateViewController(withIdentifier: "VerhicleViewController") as! VerhicleViewController
//        let navi = self.navigationController
//        navi?.pushViewController(addForm, animated: true)
        
        var dt:VerhicleRequest = VerhicleRequest()
        
        dt.brandname = brandRe
        dt.name = txtFVerhicleName.text
        dt.desc = txtFDesc.text
        dt.flag_default = fdDefault
        dt.plate_number = txtFVerhiclePlate.text
        dt.type = type
        print(dt)
        presenter?.verhicle(dt)
        
                
    }
    
    
    
    @IBAction func brandTap(_ sender: Any) {
        dropDown.show()
    }
  


    override func viewDidLoad() {
        super.viewDidLoad()
        Initialization()
        dropDownView.layer.cornerRadius = 5
        dropDownView.layer.borderWidth = 1
        dropDownView.layer.borderColor = UIColor.darkGray.cgColor

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


extension AddVerhicleViewController:IAddVerhicleView{
    func Initialization() {
        presenter = AddVerhiclePresenter(self)
        setupDropDown()
        presenter?.loadBrandName()
    }
    
    func getBrandName(didResult data: [BrandNameEntity]?) {
        if let b = data{
            for i in b {
                self.brandName.append(i.name!)
                self.brandObj.append(i)
                self.brandRe = i
                
                dropDown.dataSource = self.brandName
                dropDown.selectRow(at: 0)
            }
        }
    }

    
    func setupDropDown(){
        dropDown.anchorView = dropDownView
        dropDown.dataSource = self.brandName
        dropDown.width = 100
        dropDown.direction = .any
        dropDown.dismissMode = .onTap
        dropDown.cancelAction = {() in
            self.imgDropDown.image = #imageLiteral(resourceName: "ic_action_arrow_up")
        }
        dropDown.willShowAction = {() in
            self.imgDropDown.image = #imageLiteral(resourceName: "ic_action_arrow_down")
        }
        dropDown.selectionAction = {(index, item) in
        self.imgDropDown.image = #imageLiteral(resourceName: "ic_action_arrow_down")
        self.lblBrandName.text = item
        self.index = index
        
            var i:Int = Int(index)
            self.brand = [self.brandObj[i]]
            
        }
    }
    func verhicle(error: NIPError){
        view.makeToast(error.type!)
    }
    func verhicles(){
        if isDefault {
            isDefault = false
            imgDefault.image = #imageLiteral(resourceName: "ic_action_gray_dot")
            fdDefault = 0
        }else {
            isDefault = true
            imgDefault.image = #imageLiteral(resourceName: "ic_action_green_dot")
            fdDefault = 1
        }
    }
    
   
}
