//
//  ProfileViewController.swift
//  VParking
//
//  Created by TD on 3/13/17.
//  Copyright © 2017 xtel. All rights reserved.
//

import UIKit
import DropDown
import Alamofire

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    let picker = UIImagePickerController()
    var localPath: String?
    var presenter:ProfilePresenter?
    @IBOutlet weak var imgCover: UIImageView!
    @IBOutlet weak var imageAvatar: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPhoneNumber: UITextField!
    @IBOutlet weak var imageActionUpload: UIImageView!
    
    var urlAvatar:String?
    private var _user:UserProfileEntity?
    var User:UserProfileEntity?{
        get{return _user}
        set{
            self._user = newValue
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        Initialization()
        self.txtEmail.delegate = self
        self.txtUserName.delegate = self
        self.txtPhoneNumber.delegate = self
       
        
    }
    
 
    
    //Update Avatar
    
    @IBAction func btnChangeAvatar(_ sender: Any) {
        
        view.endEditing(true)
        let imagePickerActionSheet = UIAlertController(title: "Cập nhập ảnh đại diện",
                                                       message: nil, preferredStyle: .actionSheet)
        let cameraButton = UIAlertAction(title: "Chụp ảnh",
                                         style: .default) { (alert) -> Void in
                                            let imagePicker = UIImagePickerController()
                                            imagePicker.delegate = self
                                            imagePicker.sourceType = .camera
                                            self.present(imagePicker,
                                                         animated: true,
                                                         completion: nil)
        }
        imagePickerActionSheet.addAction(cameraButton)
        let libraryButton = UIAlertAction(title: "Chọn ảnh",
                                          style: .default) { (alert) -> Void in
                                            let imagePicker = UIImagePickerController()
                                            imagePicker.delegate = self
                                            imagePicker.sourceType = .photoLibrary
                                            self.present(imagePicker,
                                                         animated: true,
                                                         completion: nil)
        }
        imagePickerActionSheet.addAction(libraryButton)
        let cancelButton = UIAlertAction(title: "Thoát",
                                         style: .cancel) { (alert) -> Void in
        }
        imagePickerActionSheet.addAction(cancelButton)
        present(imagePickerActionSheet, animated: true,
                completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            return
        }
        
        imgCover.image = image
        imageAvatar.image = image
        let documentDirectory: NSString = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! as NSString
        
        let imageName = "temp.jpg"
        let imagePath = documentDirectory.appendingPathComponent(imageName)
        
        if let data = UIImageJPEGRepresentation(image, 80) {
            try? data.write(to: URL(fileURLWithPath: imagePath), options: [.atomic])
        }
        localPath = imagePath
        dismiss(animated: true) {
            self.uploadAvatar()
        }
    }
    
    func uploadAvatar(){
        guard let path = localPath else {
            return
        }
        
        let filePath = URL(fileURLWithPath: path)
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append("Image Name".data(using: .utf8)!, withName: "name")
                multipartFormData.append(filePath, withName: "image")
            },
            to: "http://124.158.5.112:9190/upload/files",
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseString(completionHandler: { (response) in
                        let a = [AvatarEntity](json: response.value)
                       self.urlAvatar =  a[0].uri
                                            })
                   
                case .failure(let encodingError):
                    print(encodingError)
                }
                
            }
        )
        
    }
    

    //Ngay sinh

    @IBOutlet weak var txtFBirthday: UITextField!
    
    var datePiker = UIDatePicker()
    func setupDatePicker() {
        datePiker.datePickerMode = .date
        
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255,alpha: 1)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Xong", style: .plain, target: self, action: #selector(ProfileViewController.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Thoát", style: .plain, target: self, action: #selector(ProfileViewController.cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        txtFBirthday.inputView = datePiker
        txtFBirthday.inputAccessoryView = toolBar

    }
    
    func doneClick() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        txtFBirthday.text = dateFormatter.string(from: datePiker.date)
        txtFBirthday.resignFirstResponder()
    }
    func cancelClick() {
        txtFBirthday.resignFirstResponder()
    }
    
    var dropDown:DropDown = DropDown()
    let genderDic = ["Nam", "Nữ", "Khác"]
    var typeGender:Int = 1
    
    @IBOutlet weak var dropDownView: UIView!
    @IBOutlet weak var lblGender: UILabel!
    @IBOutlet weak var imgDropDown: UIImageView!
    @IBAction func btnGender(_ sender: Any) {
        dropDown.show()
        
    }
    
    func setupDropDown(){
        dropDownView.layer.cornerRadius = 5
        dropDownView.layer.borderWidth = 1
        dropDownView.layer.borderColor = UIColor.init(red: 205/255, green: 205/255, blue: 205/255, alpha: 1).cgColor
        dropDown.anchorView = dropDownView
        dropDown.dataSource = genderDic
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
            self.lblGender.text = item
            
            
        }
    }


    @IBAction func updateInfo(_ sender: Any) {
        if lblGender.text == "Nam"{
            typeGender = 1
        } else if lblGender.text == "Nữ"{
            typeGender = 2
        }else {
            typeGender = 3
        }
        var dt:ProfileRequest = ProfileRequest()
        dt.birthday = txtFBirthday.text
        dt.email = txtEmail.text
        dt.fullname = txtUserName.text
        dt.gender = typeGender
        dt.avatar = self.urlAvatar
//        dt.phone = txtPhoneNumber.text
        presenter?.putProfile(dt)
        
    }
    
    
 
}

extension ProfileViewController:IProfileView {
    func Initialization() {
        picker.allowsEditing = true
        picker.delegate = self
        self.imageAvatar.layer.cornerRadius = self.imageAvatar.frame.height/2
        self.imageActionUpload.layer.cornerRadius = self.imageActionUpload.frame.height/2
        presenter = ProfilePresenter(self)
        fillInfo()
        setupDatePicker()
        setupDropDown()
    }
    
    func fillInfo(){
        if let u = self.User {
            if let av = u.avatar {
                imageAvatar.downloadedFrom(link: av)
                imgCover.downloadedFrom(link: av)
                imgCover.contentMode = .scaleToFill
                imageAvatar.contentMode = .scaleToFill
                
            }
            if let fName = u.fullname {
                lblUserName.text = fName
            }else{
                lblUserName.text = u.phone!
            }
           typeGender = (u.gender)
            switch typeGender {
            case 1:
               lblGender.text = "Nam"
            case 2:
               lblGender.text = "Nữ"
            default:
                lblGender.text = "Khác"
            }
            txtFBirthday.text = u.birthday
            txtEmail.text = u.email
            txtUserName.text = u.fullname
            txtPhoneNumber.text = u.phone
        }
    }
    func profile() {
        print("ahihi")
    }
    func profile(error: NIPError?) {
        view.makeToast((error?.type!)!)
    }
    
    
}

extension ProfileViewController : UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.view.endEditing(true)
//    }
    
}


