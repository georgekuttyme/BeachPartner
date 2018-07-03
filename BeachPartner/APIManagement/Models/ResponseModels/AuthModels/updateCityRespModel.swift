//
//  updateCityRespModel.swift
//  BeachPartner
//
//  Created by Admin on 03/07/18.
//  Copyright © 2018 Beach Partner LLC. All rights reserved.
//

import Foundation
import Tailor

struct updateCityRespModel : SafeMappable {
    
    var status: String = ""
    var message: String = ""
    var city: String = ""
    init(_ map: [String : Any]) throws {
        status <- map.property("status")
        message <- map.property("message")
        city <- map.property("city")
    }
}

