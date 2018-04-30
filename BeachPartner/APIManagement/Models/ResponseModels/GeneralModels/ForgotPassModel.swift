//
//  ForgotPassModel.swift
//  BeachPartner
//
//  Created by Admin on 28/04/18.
//  Copyright © 2018 dev. All rights reserved.
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

