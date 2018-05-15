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
        
//        if(self.)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
