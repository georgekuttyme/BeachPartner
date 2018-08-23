//
//  PaymentRequestModel.swift
//  BeachPartner
//
//  Created by Georgekutty on 26/07/18.
//  Copyright © 2018 Beach Partner LLC. All rights reserved.
//

import Foundation
import Tailor

struct PaymentModel:SafeMappable {
    var message : String = ""
    var status : String = ""
    var clientToken : String = ""
    var transactionId : String = ""
    var paymentAmount : Float = 0
    
    init(_ map: [String : Any]) throws {
        message <- map.property("message")
        status <- map.property("status")
        clientToken <- map.property("clientToken")
        transactionId <- map.property("transactionId")
        paymentAmount <- map.property("paymentAmount")
    }
}
