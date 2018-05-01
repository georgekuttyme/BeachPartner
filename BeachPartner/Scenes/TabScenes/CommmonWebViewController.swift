//
//  CommmonWebViewController.swift
//  BeachPartner
//
//  Created by Georgekutty on 22/04/18.
//  Copyright © 2018 dev. All rights reserved.
//

import UIKit
import WebKit

class CommmonWebViewController: UIViewController,UIWebViewDelegate {
    
    //var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    @IBOutlet weak var cmnWebview: UIWebView!
    @IBOutlet var navigationView: UIView!
    @IBOutlet var backBtn: UIButton!
    @IBOutlet var titleLbl: UILabel!
    
    var contentType = String()
    var titleText = String()
    override func viewWillAppear(_ animated: Bool) {
        print("override func viewDidLoad() {")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLbl.text = titleText
        if titleText == "About Us"{
            contentType = "https://www.beachpartner.com/about_us.html"
        }
        else{
             contentType = "https://www.beachpartner.com/feedback.html"
        }
    //    ActivityIndicatorView.show("Loading...")
        cmnWebview.delegate = self
        cmnWebview.scrollView.bounces = false
        cmnWebview.loadRequest(URLRequest(url: NSURL(string:contentType )! as URL))
       
        
    }
    func webViewDidFinishLoad(_ webView: UIWebView)
    {
        ActivityIndicatorView.hiding()
    }
    
    @IBAction func backBtnClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
}
