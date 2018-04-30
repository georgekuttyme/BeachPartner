//
//  CommmonWebViewController.swift
//  BeachPartner
//
//  Created by Georgekutty on 22/04/18.
//  Copyright © 2018 dev. All rights reserved.
//

import UIKit

class CommmonWebViewController: UIViewController,UIWebViewDelegate {
    @IBOutlet weak var cmnWebview: UIWebView!
    var contentType = String()
    override func viewDidLoad() {
        super.viewDidLoad()
    //    self.tabBarController?.tabBar.isHidden = true
        self.navigationController!.navigationBar.topItem!.title = ""
        title = contentType
    }
    override func viewWillAppear(_ animated: Bool) {

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

}
