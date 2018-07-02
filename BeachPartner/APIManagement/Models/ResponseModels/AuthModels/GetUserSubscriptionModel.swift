//
//  GetUserSubscriptionModel.swift
//  BeachPartner
//
//  Created by Beach Partner LLC on 01/06/18.
//  Copyright © 2018 Beach Partner LLC. All rights reserved.
//

import Foundation
import Tailor

struct GetUserSubscriptionModel : SafeMappable {
    
    var subscriptions = [ActiveSubscription]()
    var addons = [ActiveSubscription]()
    
    init(_ map: [String : Any]) throws {
        
        subscriptions <- map.relations("subscriptions")
        addons <- map.relations("addons")
    }
}

struct ActiveSubscription: SafeMappable {
    var planName: String = ""
    var remainingDays: Int = 0
    
    init(_ map: [String : Any]) throws {
        planName <- map.property("planName")
        remainingDays <- map.property("remainingDays")
    }
}
