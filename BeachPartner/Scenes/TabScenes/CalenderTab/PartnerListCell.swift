//
//  PartnerListCell.swift
//  BeachPartner
//
//  Created by Beach Partner LLC on 16/05/18.
//  Copyright © 2018 Beach Partner LLC. All rights reserved.
//

import UIKit

class PartnerListCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var noteButton: UIButton!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
