//
//  CalanderTableViewCell.swift
//  BeachPartner
//
//  Created by Beach Partner LLCon 21/03/18.
//  Copyright © 2018 Beach Partner LLC. All rights reserved.
//

import UIKit

class CalanderTableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var shadowLayer: UIView!
    @IBOutlet weak var mainBackground: UIView!
    
    @IBOutlet weak var eventNameLbl: UILabel!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var invitationTypeImage: UIImageView!
    

    override func prepareForReuse() {
        super.prepareForReuse()
        
        //        mainImageView.af_cancelImageRequest() // NOTE: - Using AlamofireImage
        //        mainImageView.image = nil
//        colorView.backgroundColor = .green
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//       contentView.layer.cornerRadius = 4.0
//        contentView.layer.borderWidth = 1.0
//        contentView.layer.borderColor = UIColor.clear.cgColor
//        contentView.layer.masksToBounds = false
//        layer.shadowColor = UIColor.lightGray.cgColor
//        layer.shadowOffset = CGSize(width: 0, height: 0)
//        layer.shadowRadius = 4.0
//        layer.shadowOpacity = 1.0
//        layer.masksToBounds = false
//        layer.cornerRadius = 8.0
//        layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
//        layer.borderWidth = 1.0
//
//        contentView.layer.shadowPath = UIBezierPath(roundedRect: contentView.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 8, height: 8)).cgPath
//        contentView.layer.shouldRasterize = true
//        contentView.layer.rasterizationScale = UIScreen.main.scale
        
//        shadowLayer.layer.cornerRadius = 8
//        mainBackground.layer.cornerRadius = 8
//        mainBackground.layer.masksToBounds = true
//        
//        shadowLayer.layer.masksToBounds = false
//        shadowLayer.layer.shadowOffset = CGSize(width: 0, height: 0)
//        shadowLayer.layer.shadowColor = UIColor.black.cgColor
//        shadowLayer.layer.shadowOpacity = 0.23
//        shadowLayer.layer.shadowRadius = 4
//        
//        shadowLayer.layer.shadowPath = UIBezierPath(roundedRect: shadowLayer.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 8, height: 8)).cgPath
//        shadowLayer.layer.shouldRasterize = true
//        shadowLayer.layer.rasterizationScale = UIScreen.main.scale
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

class ShadowView: UIView {
    override var bounds: CGRect {
        didSet {
            setupShadow()
        }
    }
    
    private func setupShadow() {
        self.layer.cornerRadius = 8
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.3
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 8, height: 8)).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
}
