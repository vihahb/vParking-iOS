//
//  DemoFacebokViewController.swift
//  VParking
//
//  Created by TD on 2/16/17.
//  Copyright © 2017 xtel. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
class DemoFacebokViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        var login:FBSDKLoginButton = FBSDKLoginButton()
        login.center = self.view.center
        self.view.addSubview(login)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
