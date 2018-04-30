//
//  TermsAndConditionVC.swift
//  BeachPartner
//
//  Created by seqato on 27/02/18.
//  Copyright © 2018 seqato. All rights reserved.
//

import UIKit
import M13Checkbox

class TermsAndConditionVC: UIViewController {

   // @IBOutlet weak var contentLabel: UILabel!
    
    
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
    override func viewDidLoad() {
        super.viewDidLoad()
        self.checkBox.boxType = .square
        
        // The tint color when in the selected state.
        self.checkBox.tintColor = .blue
        
        // The tint color when in the unselected state.
        self.checkBox.secondaryTintColor = .blue
        
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


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
