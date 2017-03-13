//
//  SideMenuViewController.swift
//  VParking
//
//  Created by TD on 2/16/17.
//  Copyright © 2017 xtel. All rights reserved.
//

import UIKit

struct MenuData {
    var title:String!
    var icon:UIImage!
}

class SideMenuViewController: UIViewController,ISideMenuView,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var tableMenu: UITableView!
    
    
    var presenter:SideMenuPresenter?
    var menuData = [MenuData]()
    var selectedIndex:Int = 0
    var user:UserProfileEntity?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        Initialization()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         presenter?.loadProfile()
        // init selected index
        if (selectedIndex == 4) {
            let rowToSelect:IndexPath = IndexPath(row: 0, section: 0)
            self.tableMenu.selectRow(at: rowToSelect, animated: true, scrollPosition: UITableViewScrollPosition.none)
        }
        self.view.makeToast("viewWillAppear")
        
    }

    func Initialization() {
        // round image
        imgAvatar.layer.cornerRadius = imgAvatar.frame.width/2
        imgAvatar.clipsToBounds = true
        
        // init presenter
        presenter = SideMenuPresenter(view: self);
       

        // build menu
        menuData = [MenuData(title:"Trang chủ",icon:UIImage(named:"ic_home_white_48dp.png")),
                    MenuData(title:"Yêu thích",icon:UIImage(named: "ic_favorite_border_white_48dp.png")),
                    MenuData(title:"Phương tiện",icon:UIImage(named: "ic_directions_transit_white_48dp.png")),
                    MenuData(title:"Xe đang đỗ",icon:UIImage(named: "ic_check_in.png")),
                    MenuData(title:"Đăng xuất",icon:UIImage(named: "ic_logout.png"))]
        tableMenu.delegate = self
        tableMenu.dataSource = self
    }
    
    func onLoadProfileFail(message: String?) {
        
    }
    
    func onLoadProfileSuccess(info: UserProfileEntity) {
        self.user = info
        if info.fullname != nil {
            lblName.text = info.fullname
        }else{
            lblName.text = info.phone
        }
        if (info.avatar != nil){
            imgAvatar.downloadedFrom(link: info.avatar!)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:MenuTableViewCell = Bundle.main.loadNibNamed("MenuTableViewCell", owner: self, options: nil)?.first as! MenuTableViewCell
        cell.backgroundColor = UIColor.clear
        cell.menuTitle.text = menuData[indexPath.row].title
        cell.menuIcon.image = menuData[indexPath.row].icon
        let backgroudSelectedView = UIView()
        backgroudSelectedView.backgroundColor = ColorUtils.hexStringToUIColor(hex: "#000000",alpha: 0.2)
        cell.selectedBackgroundView = backgroudSelectedView
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedIndex == indexPath.row {
            return
        }
        selectedIndex = indexPath.row
        
        switch selectedIndex {
        case 0:
            if let mView = (revealViewController().frontViewController as? UINavigationController)?.viewControllers.first as? MasterViewController{
                mView.setViewController(PARKING_VIEW.HOME_VIEW)
            }
        case 1:
            if let mView = (revealViewController().frontViewController as? UINavigationController)?.viewControllers.first as? MasterViewController{
                mView.setViewController(PARKING_VIEW.FAVORITE_VIEW)
            }
        case 2:
            if let mView = (revealViewController().frontViewController as? UINavigationController)?.viewControllers.first as? MasterViewController{
                mView.setViewController(PARKING_VIEW.VERHICLE_VIEW)
            }
        case 3:
            if let mView = (revealViewController().frontViewController as? UINavigationController)?.viewControllers.first as? MasterViewController{
                mView.setViewController(PARKING_VIEW.CHECKIN_VIEW)
            }
        case 4:
            presenter?.logout()
        default:
            print("not define")
        }
    }

    func onLogoutSuccess() {
        let loginForm:LoginViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.present(loginForm, animated: true, completion: nil)
    }
    
    @IBAction func showProfile(_ sender: Any) {
        if let profileVC:ProfileViewController = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController {
            profileVC.User = self.user
            if let nav = self.navigationController {
                nav.pushViewController(profileVC, animated: true)
            }
        }
    }
    
}
