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
    
    var dismissActive = false
    
    var contentType = String()
    var titleText = String()
    override func viewWillAppear(_ animated: Bool) {
        print("override func viewDidLoad() {")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let barButtonItemAppearance = UIBarButtonItem.appearance()
        barButtonItemAppearance.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.white], for: .normal)
        UIPickerView.appearance().tintColor = UIColor.red
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UIToolbar.self]).setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor(red: 32.0/255.0, green: 48.0/255.0, blue: 127.0/255.0, alpha: 1.0)], for: .normal)
//        (red: 41/255.0, green: 56/255.0, blue: 133/255.0, alpha:1.0)
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
    
        dismissActive = true
        dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)?) {
        if self.presentedViewController != nil  {
            super.dismiss(animated: flag, completion: completion)
        }
        if dismissActive {
            let barButtonItemAppearance = UIBarButtonItem.appearance()
            barButtonItemAppearance.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.clear], for: .normal)
                UIBarButtonItem.appearance(whenContainedInInstancesOf: [UIToolbar.self]).setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.clear], for: .normal)
            super.dismiss(animated: flag, completion: completion)
        }
    }
}
