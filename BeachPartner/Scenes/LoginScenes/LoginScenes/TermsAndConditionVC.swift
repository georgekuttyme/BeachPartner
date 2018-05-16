//
//  TermsAndConditionVC.swift
//  BeachPartner
//
//  Created by seqato on 27/02/18.
//  Copyright © 2018 seqato. All rights reserved.
//

import UIKit
import M13Checkbox

class TermsAndConditionVC: UIViewController,UIWebViewDelegate {
    
    @IBAction func continueClicked(_ sender: Any) {
     
        if(self.checkBox.checkState == .checked){
        navigationController?.popViewController(animated: true)
        
        dismiss(animated: true, completion: nil)
        }
        else{
            
            self.checkBox.shake()
            self.iagreeLbl.shake()
        }
    }
    
     @IBOutlet weak var iagreeLbl: UILabel!
     @IBOutlet weak var continueBtn: UIButton!
    @IBOutlet weak var checkBox: M13Checkbox!
    @IBOutlet weak var webView: UIWebView!
    var contentType = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentType = "https://www.beachpartner.com/terms.html"
        webView.delegate = self
        webView.scrollView.bounces = false
        webView.loadRequest(URLRequest(url: NSURL(string:contentType )! as URL))
        
        
        self.checkBox.boxType = .square
        
        // The tint color when in the selected state.
        self.checkBox.tintColor = UIColor(red: 41/255.0, green: 56/255.0, blue: 133/255.0, alpha:1.0)
        
        // The tint color when in the unselected state.
        self.checkBox.secondaryTintColor = UIColor(red: 41/255.0, green: 56/255.0, blue: 133/255.0, alpha:1.0)
        
        // The color of the checkmark when the animation is a "fill" style animation.
        self.checkBox.secondaryCheckmarkTintColor = .red
        
        // Whether or not to display a checkmark, or radio mark.
        self.checkBox.markType = .checkmark
        
        // The line width of the checkmark.
        self.checkBox.checkmarkLineWidth = 3.0

        // The line width of the box.
        self.checkBox.boxLineWidth = 3.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}
