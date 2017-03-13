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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Initialization()
    }
    
    @IBAction func changeAvatar(_ sender: Any) {
        
    }
    
    @IBAction func updateInfo(_ sender: Any) {
        
    }
    
}

extension ProfileViewController:IProfileView {
    func Initialization() {
        self.imageAvatar.layer.cornerRadius = self.imageAvatar.frame.height/2
        self.imageActionUpload.layer.cornerRadius = self.imageActionUpload.frame.height/2
    }
}
