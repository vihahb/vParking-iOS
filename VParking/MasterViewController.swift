//
//  MasterViewController.swift
//  VParking
//
//  Created by TD on 3/6/17.
//  Copyright © 2017 xtel. All rights reserved.
//

import UIKit

enum PARKING_VIEW{
    case HOME_VIEW
    case FAVORITE_VIEW
    case VERHICLE_VIEW
    case CHECKIN_VIEW
}

class MasterViewController: UIPageViewController {

    @IBOutlet weak var btnMenu: UIBarButtonItem!
    @IBOutlet weak var btnCheckIn: UIBarButtonItem!


    var index:Int = 0
    
    var _VIEWS = [PARKING_VIEW:UIViewController]()
    
    var isAdd:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Initialization()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let current:FrontViewPosition = self.revealViewController().frontViewPosition
        if current != FrontViewPosition.left {
            self.revealViewController().revealToggle(animated: true)
        }
    }
    
    func viewControllerAtIndex(index: Int) -> UIViewController? {
        if index == NSNotFound || index < 0 || index >= 3 {
            return nil
        }
        
        return nil
    }

    @IBAction func checkInClicked(_ sender: Any) {
        if !isAdd {
            let qrVC = self.storyboard?.instantiateViewController(withIdentifier: "QRCodeScannerViewController")
            if let nav = self.navigationController {
                nav.pushViewController(qrVC!, animated: true)
            }
        }else{
            let qrVC = self.storyboard?.instantiateViewController(withIdentifier: "AddVerhicleViewController")
            if let nav = self.navigationController {
                nav.pushViewController(qrVC!, animated: true)
            }
        }
    }
    
    func updateAcionButton(_ isAdd:Bool){
        self.isAdd = isAdd
        if isAdd {
            self.btnCheckIn.image = #imageLiteral(resourceName: "Plus Math_32")
            self.btnCheckIn.title = nil
        }else{
           self.btnCheckIn.image = nil
            self.btnCheckIn.title = "CHECKIN"
        }
    }
    
    func setTitleNavi(_ title: String){
        self.title = title
    }
}

extension MasterViewController:IMasterView{
    func Initialization() {
        btnMenu.target = revealViewController()
        btnMenu.action = #selector(SWRevealViewController.revealToggle(_:))
        
        // init navigation bar
        navigationController?.navigationBar.barTintColor = ColorUtils.hexStringToUIColor(hex: "#5555ab")
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.barStyle = UIBarStyle.blackTranslucent
        
        // set homview controller
        
        if let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController"){
            _VIEWS[PARKING_VIEW.HOME_VIEW] = homeViewController
        }
        
        if let favoriveVC = self.storyboard?.instantiateViewController(withIdentifier: "FavoriteViewController"){
            _VIEWS[PARKING_VIEW.FAVORITE_VIEW] = favoriveVC
        }
        
        if let verhicleVC = self.storyboard?.instantiateViewController(withIdentifier: "VerhicleViewController"){
            _VIEWS[PARKING_VIEW.VERHICLE_VIEW] = verhicleVC
        }
        
        if let checkinVC = self.storyboard?.instantiateViewController(withIdentifier: "CheckInViewController"){
            _VIEWS[PARKING_VIEW.CHECKIN_VIEW] = checkinVC
        }
        
        setViewController(PARKING_VIEW.HOME_VIEW)
    }
    
    func setViewController(_ view:PARKING_VIEW){
        setViewControllers([_VIEWS[view]!], direction: .forward, animated: false, completion: nil)
        let current:FrontViewPosition = self.revealViewController().frontViewPosition
        if current != FrontViewPosition.left {
            self.revealViewController().revealToggle(animated: true)
        }
        
    }
}

extension MasterViewController : UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        index = index + 1
        return self.viewControllerAtIndex(index: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        index = index - 1
        return self.viewControllerAtIndex(index: index)
    }
}
