//
//  LoginViewController.swift
//  VParking
//
//  Created by TD on 2/16/17.
//  Copyright © 2017 xtel. All rights reserved.
//

import UIKit
import AccountKit
class LoginViewController: UIViewController,ILoginView {

    @IBOutlet weak var btnLoginWithPhone: UIButton!
    @IBOutlet weak var btnLoginWithFacebook: UIButton!
    var presenter:LoginPresenter?
    var accountKit:AKFAccountKit!
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        Initialization()
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
    
    func Initialization() {
        // init button login with phonenumber
        btnLoginWithPhone.layer.cornerRadius = 0
        btnLoginWithPhone.layer.borderWidth = 1
        btnLoginWithPhone.layer.borderColor = UIColor.white.cgColor
        
        // init button login with facebook
        btnLoginWithFacebook.backgroundColor = ColorUtils.hexStringToUIColor(hex: "#3b5998")
        
        // init login presenter
        presenter = LoginPresenter(view: self)
        
        // init accountKit
        
        if accountKit == nil{
            self.accountKit = AKFAccountKit(responseType: AKFResponseType.authorizationCode);
        }
    }
    
    func onLoginSucces() {
        let homeForm:SWRevealViewController = self.storyboard?.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
        self.present(homeForm, animated: true, completion: nil)
    }
    
    func onLoginError(messageError: String) {
        self.view.makeToast(messageError, duration: 0.5, position: .bottom)
    }
    
    
    @IBAction func onLoginWithPhoneNumber(_ sender: Any) {
        let inputState: String = UUID().uuidString
        let viewController:AKFViewController = accountKit.viewControllerForPhoneLogin(with: nil, state: inputState)  as! AKFViewController
        viewController.enableSendToFacebook = true
        self.prepareLoginViewController(viewController)
        self.present(viewController as! UIViewController, animated: true, completion: nil)
    }
    
    @IBAction func onLoginWithFacebook(_ sender: Any) {
        presenter?.loginWithFacebook(controller: self)
    }
    
    func prepareLoginViewController(_ loginViewController: AKFViewController) {
        
        loginViewController.delegate = presenter
        loginViewController.defaultCountryCode = "VN"
        loginViewController.advancedUIManager = nil
        
        //Costumize the theme
        let theme:AKFTheme = AKFTheme.default()
        theme.textColor = UIColor.white
        theme.titleColor = UIColor.white
        theme.headerBackgroundColor = ColorUtils.hexStringToUIColor(hex: "#5a5ca6")
        // theme button
        theme.buttonBackgroundColor = UIColor.clear
        theme.buttonBorderColor = UIColor.white
        theme.buttonTextColor = UIColor.white
        theme.buttonDisabledBorderColor = UIColor.white
        theme.buttonDisabledBackgroundColor = UIColor.clear
        theme.buttonDisabledTextColor = UIColor.white
        
        // theme input text
        theme.inputTextColor = UIColor.white
        theme.inputBorderColor = UIColor.white
        theme.inputBackgroundColor = UIColor.clear
        
        
        // background
        theme.backgroundColor = UIColor.clear
        theme.backgroundImage  = UIImage(named: "ic_bgr.png")
//        theme.headerBackgroundColor = UIColor(red: 0.325, green: 0.557, blue: 1, alpha: 1)
//        theme.headerTextColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
//        theme.iconColor = UIColor(red: 0.325, green: 0.557, blue: 1, alpha: 1)
//        theme.inputTextColor = UIColor(white: 0.4, alpha: 1.0)
//        theme.statusBarStyle = .default
//        theme.textColor = UIColor(white: 0.3, alpha: 1.0)
//        theme.titleColor = UIColor(red: 0.247, green: 0.247, blue: 0.247, alpha: 1)
        loginViewController.theme = theme
        
        
    }

}
