//
//  CustomCell.swift
//  BeachPartner
//
//  Created by krishnapillai on 21/12/1939 Saka.
//  Copyright © 1939 dev. All rights reserved.
//

import UIKit

class CustomCell: UICollectionViewCell {
   
    @IBOutlet weak var expandBtn: UIButton!
    @IBOutlet weak var profileImgView: UIImageView!
   
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var ageLbl: UILabel!
    @IBOutlet weak var blockBtn: UIButton!
    @IBOutlet weak var messageBtn: UIButton!
    @IBOutlet weak var notesBtn: UIButton!
    @IBOutlet weak var btnMsgHeight: NSLayoutConstraint!
    
    @IBOutlet weak var didSelectBtn: UIButton!
    @IBOutlet weak var connScrollView: UIScrollView!
    @IBOutlet weak var bgView: UIView!
    
    @IBAction func expandBtnClicked(_ sender: Any) {
 
        UIView.animate(withDuration: 0.5, animations: {
            let point = CGPoint(x: 0, y: 92) // 200 or any value you like.
            if(self.connScrollView.contentOffset.y < point.y){
                
                self.connScrollView.contentOffset = point
            }
            else{
                let point = CGPoint(x: 0, y: 0)
                self.connScrollView.contentOffset = point
            }
            
        }, completion: nil)
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        let point = CGPoint(x: 0, y: 0)
        self.connScrollView.contentOffset = point
    }
}
