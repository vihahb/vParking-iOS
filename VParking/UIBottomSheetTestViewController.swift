//
//  UIBottomSheetTestViewController.swift
//  VParking
//
//  Created by TD on 2/28/17.
//  Copyright © 2017 xtel. All rights reserved.
//

import UIKit

class UIBottomSheetTestViewController: UIViewController {
    @IBOutlet weak var scroll: UIScrollView!

    @IBOutlet weak var UIVewParent: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var contentView: UIScrollView!
    
    var sortHeight:CGFloat = 0
    var fullHeight:CGFloat = 0
    var bHeight:CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(UIBottomSheetTestViewController.panGesture))
        view.addGestureRecognizer(gesture)
        sortHeight = headerView.frame.height
        fullHeight = view.frame.height
        bHeight = fullHeight - sortHeight

    }
    
    
    func panGesture(_ recognizer: UIPanGestureRecognizer) {
        
        let transaction = recognizer.translation(in: self.view)
        let p_frame = self.contentView.frame
        
        let y1 = transaction.y * sortHeight / (fullHeight - sortHeight)
        

        if(self.view.frame.minY + transaction.y >= 0){
            print(self.view.frame.minY + transaction.y)
            self.contentView.frame = CGRect(x: 0, y: p_frame.minY + y1, width: view.frame.width, height: fullHeight)
            self.view.frame = CGRect(x: 0, y: self.view.frame.minY + transaction.y, width: view.frame.width, height: fullHeight)
        }
        
        recognizer.setTranslation(CGPoint.zero, in: self.view)
        
        
        
    }
    

}
