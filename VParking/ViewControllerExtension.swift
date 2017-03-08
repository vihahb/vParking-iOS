//
//  ViewControllerExtension.swift
//  VParking
//
//  Created by TD on 3/2/17.
//  Copyright © 2017 xtel. All rights reserved.
//

import Foundation

import SVProgressHUD
extension UIViewController{
    
    func showProgress(title:String?) {
        UIApplication.shared.beginIgnoringInteractionEvents()
        SVProgressHUD.setDefaultAnimationType(.flat)
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show(withStatus: title)
    }
    
    func closeProgress() {
        UIApplication.shared.endIgnoringInteractionEvents()
        SVProgressHUD.dismiss()
    }
    
    func showLoginForm(){
        let loginForm:LoginViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.present(loginForm, animated: true, completion: nil)
    }
}
