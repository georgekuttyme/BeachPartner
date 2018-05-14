//
//  EventInvitationCell.swift
//  BeachPartner
//
//  Created by seq-mary on 14/05/18.
//  Copyright © 2018 dev. All rights reserved.
//

import UIKit

class EventInvitationCell: UITableViewCell {

    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var viewDetailsButton: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
