//
//  GeneralModels.swift
//  BeachPartner
//
//  Created by Jerry K Mathew on 26/03/18.
//  Copyright © 2018 dev. All rights reserved.
//

import Foundation
import Tailor
struct GeneralResponseModel:SafeMappable {
    
    
    let response: GeneralResponse?
    
    
    init(_ map: [String : Any]) throws {
        
        response = map.relation("response")
        
    }
}


struct GeneralResponse : SafeMappable{
    
    var success: Int = 0
    var message: String = ""
    var exceptionId = 0
    
    
    
    init(_ map: [String : Any])throws {
        success <- map.property("success")
        message  <- map.property("message")
        exceptionId <- map.property("exceptionId")
        
    }
    
}





