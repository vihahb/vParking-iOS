//
//  AddVerhicleViewController.swift
//  VParking
//
//  Created by Thanh Lee on 3/15/17.
//  Copyright © 2017 xtel. All rights reserved.
//

import UIKit
import DropDown

class AddVerhicleViewController: UIViewController, UITextFieldDelegate {
    
    var presenter:AddVerhiclePresenter?
    var dropDown:DropDown = DropDown()
    var brandName = [String]()
    var brandObj = [BrandNameEntity]()
    var brandRe:BrandNameEntity?
    var index:Int = 0
    var fdDefault:Int = 0
    var isDefault:Bool = true
    var isUpdate:Bool = false
    var id:Int = 0
    var type:Int = 1
    var z:Int = 0
    private var _verhicle:VerhicleEntity?
    var Verhicle:VerhicleEntity?{
        set{
            self._verhicle = newValue
        }
        get{
            return self._verhicle
        }
    }
    
    @IBOutlet weak var segVerhicleType: UISegmentedControl!
    @IBOutlet weak var dropDownView: UIView!
    @IBOutlet weak var imgDropDown: UIImageView!
    @IBOutlet weak var lblBrandName: UILabel!
    @IBOutlet weak var txtFVerhicleName: UITextField!
    @IBOutlet weak var txtFVerhiclePlate: UITextField!
    @IBOutlet weak var txtFDesc: UITextField!
    @IBOutlet weak var imgDefault: UIImageView!

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

        var dt:VerhicleRequest = VerhicleRequest()
        dt.brandname = brandRe
        dt.name = txtFVerhicleName.text
        dt.desc = txtFDesc.text
        dt.flag_default = fdDefault
        dt.plate_number = txtFVerhiclePlate.text
        dt.type = type
        presenter?.verhicle(dt)
        
        let navi = self.navigationController
        navi?.popToRootViewController(animated: true)
        
        
    }
    
    @IBAction func UpdateVerhicle(_ sender: Any) {
        
        var dt:VerhicleRequest = VerhicleRequest()
        dt.brandname = brandRe
        dt.name = txtFVerhicleName.text
        dt.desc = txtFDesc.text
        dt.flag_default = fdDefault
        dt.plate_number = txtFVerhiclePlate.text
        dt.type = type
        dt.id = id
        
        presenter?.putVerhicle(dt)
        let navi = self.navigationController
        navi?.popToRootViewController(animated: true)
       
        
        
        

   
    }
  
    @IBOutlet weak var btnAddVerhicle: UIButton!
    @IBOutlet weak var btnUpdateVerhicle: UIButton!

    @IBAction func brandTap(_ sender: Any) {
        dropDown.show()
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        Initialization()
        self.txtFDesc.delegate = self
        self.txtFVerhicleName.delegate = self
        self.txtFVerhiclePlate.delegate = self

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
}

extension AddVerhicleViewController:IAddVerhicleView{
    func Initialization() {
 
        if isUpdate == true {
            self.btnAddVerhicle.isHidden = true
            self.btnUpdateVerhicle.isHidden = false
            txtFVerhicleName.text = Verhicle?.name
            type = (Verhicle?.type)!
                if type == 1{
                    segVerhicleType.selectedSegmentIndex = 0
                }else {
                    segVerhicleType.selectedSegmentIndex = 1
                }
            txtFVerhiclePlate.text = Verhicle?.plate_number
            txtFDesc.text = Verhicle?.desc
            fdDefault = (Verhicle?.flag_default)!
                if fdDefault == 0 {
                    imgDefault.image = #imageLiteral(resourceName: "ic_action_gray_dot")
                } else {
                    imgDefault.image = #imageLiteral(resourceName: "ic_action_green_dot")
                }
                id = (Verhicle?.id)!
        }else {
            self.btnUpdateVerhicle.isHidden = true
            self.btnAddVerhicle.isHidden = false
        }

        
        presenter = AddVerhiclePresenter(self)
        presenter?.loadBrandName()
        setupDropDown()
 
    }
    
    func getBrandName(didResult data: [BrandNameEntity]?) {
        if let b = data{
            for i in b {
                self.brandName.append(i.name!)
                self.brandObj.append(i)
                dropDown.dataSource = self.brandName
            }
        }
        
        for j in 0...(self.brandName.count - 1) {
            if self.brandName[j] == Verhicle?.brandname.name {
                z = j
            }
        }
        
        dropDown.selectRow(at: z)
    }

    func setupDropDown(){
        dropDownView.layer.cornerRadius = 5
        dropDownView.layer.borderWidth = 1
        dropDownView.layer.borderColor = UIColor.init(red: 205/255, green: 205/255, blue: 205/255, alpha: 1).cgColor
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
            self.brandRe = self.brandObj[i]
                
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
