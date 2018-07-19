//
//  FlagRespModel.swift
//  BeachPartner
//
//  Created by Admin on 19/07/18.
//  Copyright © 2018 Beach Partner LLC. All rights reserved.
//

import Foundation
import Tailor
struct FlagRespModel: SafeMappable {
    var flagReason : String = ""
    var flagUserId : Int = 0
    var message : String = ""
    var status : String = ""
    init(_ map: [String : Any]) throws {
        flagReason <- map.property("flagReason")
        flagUserId <- map.property("flagUserId")
        message <- map.property("message")
        status <- map.property("status")
    }
}
