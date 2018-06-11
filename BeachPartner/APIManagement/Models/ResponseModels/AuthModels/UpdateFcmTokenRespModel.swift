//
//  UpdateFcmTokenRespModel.swift
//  BeachPartner
//
//  Created by Powermac on 6/11/18.
//  Copyright © 2018 dev. All rights reserved.
//

import Foundation
import Tailor
struct updateFcmTokenRespModel : SafeMappable{
    var status: String = ""
    var message: String = ""
    init(_ map: [String : Any]) throws {
        status <- map.property("status")
        message <- map.property("message")
    }
}


