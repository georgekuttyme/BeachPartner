//
//  MyteamCell.swift
//  BeachPartner
//
//  Created by Beach Partner LLC on 28/03/18.
//  Copyright © 2018 Beach Partner LLC. All rights reserved.
//

import UIKit

class MyteamCell: UITableViewCell {

    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var delBtn: UIButton!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
