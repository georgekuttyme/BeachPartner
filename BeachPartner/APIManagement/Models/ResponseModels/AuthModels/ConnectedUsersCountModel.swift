//
//  ConnectedUsersCountModel.swift
//  BeachPartner
//
//  Created by Georgekutty on 29/04/18.
//  Copyright © 2018 dev. All rights reserved.
//

import Foundation
import Tailor
struct ConnectedUsersCountModel:SafeMappable {
    
    var count: Int = 0
    var message: String = ""
    
    init(_ map: [String : Any])throws {
        count <- map.property("list_count")
    }
    
}
