//
//  GetUserSubscriptionModel.swift
//  BeachPartner
//
//  Created by seq-mary on 01/06/18.
//  Copyright © 2018 dev. All rights reserved.
//

import Foundation
import Tailor

struct GetUserSubscriptionModel : SafeMappable {
    
    var subscriptions: [Subscription] = [Subscription]()
    var addons: [Subscription] = [Subscription]()
    
    init(_ map: [String : Any]) throws {
        
        subscriptions <- map.relations("subscriptions")
        addons <- map.relations("addons")
    }
    
    struct Subscription: SafeMappable {
        var planName: String = ""
        var remainingDays: Int = 0
        
        init(_ map: [String : Any]) throws {
            planName <- map.property("planName")
            remainingDays <- map.property("remainingDays")
        }
    }
}
