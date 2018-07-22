//
//  CommmonWebViewController.swift
//  BeachPartner
//
//  Created by Beach Partner LLC on 22/04/18.
//  Copyright © 2018 Beach Partner LLC. All rights reserved.
//

import UIKit
import WebKit

class CommmonWebViewController: UIViewController,UIWebViewDelegate {
    
    //var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    @IBOutlet weak var cmnWebview: UIWebView!
    @IBOutlet var navigationView: UIView!
    @IBOutlet var backBtn: UIButton!
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet weak var topLayout: NSLayoutConstraint!
    
    var dismissActive = false
    
    var contentType = String()
    var titleText = String()
    override func viewWillAppear(_ animated: Bool) {
        print("override func viewDidLoad() {")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            let screenSize = UIScreen.main.bounds.size;
            if screenSize.height == 812.0{
                topLayout.constant = 20
            }
            else{
                topLayout.constant = 0
            }
        }

        
        let barButtonItemAppearance = UIBarButtonItem.appearance()
        barButtonItemAppearance.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.white], for: .normal)
        UIPickerView.appearance().tintColor = UIColor.red
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UIToolbar.self]).setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.statusBarTintColor], for: .normal)
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
