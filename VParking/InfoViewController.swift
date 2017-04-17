//
//  InfoViewController.swift
//  VParking
//
//  Created by Thanh Lee on 4/12/17.
//  Copyright © 2017 xtel. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {
    @IBOutlet weak var xtelWebView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: "http://124.158.5.112:9180/policy/parking/")
        let urlRequest = URLRequest(url: url!)
        xtelWebView.loadRequest(urlRequest)

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
