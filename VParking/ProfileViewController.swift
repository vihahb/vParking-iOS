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
import AlamofireImage

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    let picker = UIImagePickerController()
    var localPath: String?
    var presenter:ProfilePresenter?
    @IBOutlet weak var imageAvatar: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPhoneNumber: UITextField!
    @IBOutlet weak var imageActionUpload: UIImageView!
    @IBOutlet weak var navHeight: NSLayoutConstraint!
    @IBOutlet weak var scrollview: UIScrollView!
    
    var isKeyboardHidden:Bool = true
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
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Initialization()
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
        
        imageAvatar.image   = image
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
        toolBar.barStyle        = .default
        toolBar.isTranslucent   = true
        toolBar.tintColor       = UIColor(red: 92/255, green: 216/255, blue: 255/255,alpha: 1)
        toolBar.sizeToFit()
        
        let doneButton      = UIBarButtonItem(title: "Xong", style: .plain, target: self, action: #selector(ProfileViewController.doneClick))
        let spaceButton     = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton    = UIBarButtonItem(title: "Thoát", style: .plain, target: self, action: #selector(ProfileViewController.cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        txtFBirthday.inputView = datePiker
        txtFBirthday.inputAccessoryView = toolBar

    }
    
    func doneClick() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
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
    @IBAction func btnGenders(_ sender: Any) {
        dropDown.show()
    }
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
        lblUserName.text = txtUserName.text
        if lblGender.text == "Nam"{
            typeGender = 1
        } else if lblGender.text == "Nữ"{
            typeGender = 2
        }else {
            typeGender = 3
        }
        let dt:ProfileRequest   = ProfileRequest()
//        dt.birthday             = txtFBirthday.text
        dt.birthday             = convertToPut(txtFBirthday.text!)
        dt.email                = txtEmail.text
        dt.fullname             = txtUserName.text
        dt.gender               = typeGender
        dt.avatar               = self.urlAvatar
        presenter?.putProfile(dt)
        
    }
    
    func convertDate(_ date: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        dateFormatter.locale = Locale.init(identifier: "en_GB")
        
        let dateObj = dateFormatter.date(from: date)
        
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let a = dateFormatter.string(from: dateObj!)
        return a
    }
    
    func convertToPut(_ date: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateFormatter.locale = Locale.init(identifier: "en_GB")
        
        let dateObj = dateFormatter.date(from: date)
        
        dateFormatter.dateFormat = "yyyy/MM/dd"
        let a = dateFormatter.string(from: dateObj!)
        return a
    }
    
    
    func keyboardWillShow(_ notification:Notification){
        adjustingHeight(true,notification: notification)
        self.isKeyboardHidden = false
    }
    
    func keyboardWillHidden(_ notification:Notification){
        adjustingHeight(false,notification: notification)
        self.isKeyboardHidden = true
    }
    
    func adjustingHeight(_ show:Bool, notification:Notification) {
        
        if (show == self.isKeyboardHidden){
            let userInfo = notification.userInfo!
            let keyboardFrame = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
            let changeInHeight = (keyboardFrame.height) * (show ? 1 : -1)
            self.scrollview.contentInset.bottom += changeInHeight
            self.scrollview.scrollIndicatorInsets.bottom += changeInHeight
        }
        
    }


}

extension ProfileViewController:IProfileView {
    func Initialization() {
        self.txtEmail.delegate                      = self
        self.txtUserName.delegate                   = self
        self.txtPhoneNumber.delegate                = self
        picker.allowsEditing                        = true
        picker.delegate                             = self
        self.imageAvatar.layer.cornerRadius         = self.imageAvatar.frame.height/2
        self.imageActionUpload.layer.cornerRadius   = self.imageActionUpload.frame.height/2
        presenter                                   = ProfilePresenter(self)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHidden(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        fillInfo()
        setupDatePicker()
        setupDropDown()
    }
    
    func fillInfo(){
        if let u = self.User {
            
            if let url = URL.init(string: u.avatar!){
                imageAvatar.af_setImage(withURL: url)
                
                imageAvatar.contentMode = .scaleToFill
            }
            
//            if let av = u.avatar {
//                imageAvatar.downloadedFrom(link: av)
//                imageAvatar.contentMode = .scaleToFill
//            }
            if let fName = u.fullname , fName.characters.count > 0 {
                lblUserName.text = fName
            }else{
                lblUserName.text = u.phone!
            }
           typeGender = (u.gender)
            switch typeGender {
            case 1:
               lblGender.text   = "Nam"
            case 2:
               lblGender.text   = "Nữ"
            default:
                lblGender.text  = "Khác"
            }
            txtEmail.text       = u.email
            txtUserName.text    = u.fullname
            if let b = u.birthday {
                txtFBirthday.text   = convertDate(b)
            }
            txtPhoneNumber.text = u.phone
            
            
        }
    }
    func profile() {
        view.makeToast("Cập nhập thông tin thành công")
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
    
}


