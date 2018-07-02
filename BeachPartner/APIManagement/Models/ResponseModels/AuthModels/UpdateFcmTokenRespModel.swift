//
//  UpdateFcmTokenRespModel.swift
//  BeachPartner
//
//  Created by Beach Partner LLC on 6/11/18.
//  Copyright © 2018 Beach Partner LLC. All rights reserved.
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


