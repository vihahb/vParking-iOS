//
//  LaunchScreenViewController.swift
//  VParking
//
//  Created by TD on 2/20/17.
//  Copyright © 2017 xtel. All rights reserved.
//

import UIKit

class LaunchScreenViewController: UIViewController {
    var prensenter:LaunchScreenPresenter?
    
    override func viewDidAppear(_ animated: Bool) {
        Initialization()
    }
    
    

}

extension LaunchScreenViewController: ILaunchScreenView{
    func Initialization() {
        prensenter = LaunchScreenPresenter(view:self)
        prensenter?.checkLogin()
    }
    func showLogin() {
        let loginForm:LoginViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.present(loginForm, animated: true, completion: nil)
        
    }
    
    func showHome() {
        let homeForm:SWRevealViewController = self.storyboard?.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
        self.present(homeForm, animated: true, completion: nil)
        
    }

}
