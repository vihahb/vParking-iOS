//
//  ProfileViewController.swift
//  VParking
//
//  Created by TD on 3/13/17.
//  Copyright © 2017 xtel. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var imageAvatar: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtBirthday: UITextField!
    @IBOutlet weak var txtGender: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPhoneNumber: UITextField!
    @IBOutlet weak var imageActionUpload: UIImageView!
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
    }
    
    @IBAction func changeAvatar(_ sender: Any) {
        
    }
    
    @IBAction func updateInfo(_ sender: Any) {
        
    }
    
    @IBAction func touchDownBirthday(_ sender: Any) {
        print("txtBirthDay Click")
    }
}

extension ProfileViewController:IProfileView {
    func Initialization() {
        self.imageAvatar.layer.cornerRadius = self.imageAvatar.frame.height/2
        self.imageActionUpload.layer.cornerRadius = self.imageActionUpload.frame.height/2
        self.txtBirthday.delegate = self
        fillInfo()
    }
    
    func fillInfo(){
        if let u = self.User {
            if let av = u.avatar {
                imageAvatar.downloadedFrom(link: av)
            }
            if let fName = u.fullname {
                lblUserName.text = fName
            }else{
                lblUserName.text = u.phone!
            }
            
            txtEmail.text = u.email
            txtUserName.text = u.fullname
            txtPhoneNumber.text = u.phone
        }
    }
}

extension ProfileViewController : UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return false
    }
}
