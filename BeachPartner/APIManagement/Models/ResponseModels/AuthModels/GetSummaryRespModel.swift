//
//  GetSummaryRespModel.swift
//  BeachPartner
//
//  Created by ADMIN on 8/22/18.
//  Copyright © 2018 Beach Partner LLC. All rights reserved.
//

import Foundation
import Tailor
struct GetSummaryPayment : SafeMappable{
    
    var endDate: String = ""
    var regFee: Int = 0
    var monthlyCharge: Float = 0
    var planId: Int = 0
    var message: String = ""
    var planCode: String = ""
    var startDate: String = ""
    var userRegistered: String = ""
    var payableAmount:  Float = 0
    var status: String = ""
    
    init(_ map: [String : Any]) throws {
        endDate <- map.property("endDate")
        regFee <- map.property("regFee")
        monthlyCharge <- map.property("monthlyCharge")
        planId <- map.property("planId")
        message <- map.property("message")
        planCode <- map.property("planCode")
        startDate <- map.property("startDate")
        userRegistered <- map.property("isRegFeePaid ")
        payableAmount <- map.property("payableAmount")
        status <- map.property("status")
    }
    
}

