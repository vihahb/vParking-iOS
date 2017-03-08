//
//  TestViewController.swift
//  VParking
//
//  Created by TD on 2/27/17.
//  Copyright © 2017 xtel. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    @IBOutlet weak var containerVew: UIView!

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let vc = (storyboard?.instantiateViewController(withIdentifier: "BottomSheetTest"))! as UIViewController
        self.addChildViewController(vc)
        self.view.addSubview(vc.view)
        vc.didMove(toParentViewController: self)
        vc.view.frame = CGRect(x: 0, y: self.view.frame.height-104, width: self.view.frame.width, height: self.view.frame.height)
    }
    
    
    

    func panGesture(_ recognizer: UIPanGestureRecognizer) {
        
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
