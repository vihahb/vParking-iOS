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
    
    func close(completion:(()->Void)? = nil){
        
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
            if let c = completion {
                c()
            }
        }else{
            self.dismiss(animated: true, completion: completion)
        }
    }
    
    func showUpdateDialog(_ id:String){
        let alert = UIAlertController(title: "Thông báo", message: "Đã có bản cập nhập mới. Vui lòng cập nhập để sử dụng.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cập nhập", style: .default, handler: { (a) in
            let url  = URL(string: "itms-apps://itunes.apple.com/app/id\(id)")
            if UIApplication.shared.canOpenURL(url!) {
                UIApplication.shared.openURL(url!)
            }
        }))
        alert.addAction(UIAlertAction(title: "Đóng", style: .default, handler: { (a) in
            exit(0)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
}
