//
//  ForgotPassModel.swift
//  BeachPartner
//
//  Created by Beach Partner LLC on 28/04/18.
//  Copyright © 2018 Beach Partner LLC. All rights reserved.
//

import Foundation
import Tailor
struct ForgotPassResponceModel:SafeMappable {
    
    var status: Int = 0
    var message: String = ""

    init(_ map: [String : Any])throws {
        status <- map.property("status")
        message  <- map.property("title")
    }

}

