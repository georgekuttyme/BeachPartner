//
//  ConnectedUsersCountModel.swift
//  BeachPartner
//
//  Created by Beach Partner LLC on 29/04/18.
//  Copyright © 2018 Beach Partner LLC. All rights reserved.
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
