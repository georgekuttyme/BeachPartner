//
//  CalanderTableViewCell.swift
//  BeachPartner
//
//  Created by Jerry K Mathew on 21/03/18.
//  Copyright © 2018 dev. All rights reserved.
//

import UIKit

class CalanderTableViewCell: UITableViewCell {

    
    
    
    @IBOutlet weak var eventNameLbl: UILabel!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var invitationTypeImage: UIImageView!
    

    override func prepareForReuse() {
        super.prepareForReuse()
        
        //        mainImageView.af_cancelImageRequest() // NOTE: - Using AlamofireImage
        //        mainImageView.image = nil
        colorView.backgroundColor = .green
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
       contentView.layer.cornerRadius = 4.0
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.masksToBounds = false
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 4.0
        layer.shadowOpacity = 1.0
        layer.masksToBounds = false
        layer.cornerRadius = 8.0
        layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        layer.borderWidth = 1.0

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
