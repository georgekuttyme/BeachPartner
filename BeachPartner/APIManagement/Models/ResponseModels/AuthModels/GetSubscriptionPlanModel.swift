//
//  GetSubscriptionPlanModel.swift
//  BeachPartner
//
//  Created by seq-mary on 31/05/18.
//  Copyright © 2018 dev. All rights reserved.
//

import Foundation
import Tailor

struct GetSubscriptionPlansRespModelArray: SafeMappable {
    
    var subscriptionPlans = [SubscriptionPlanModel]()
    
    init(_ map: [String : Any]) throws {
        
    }
    
    init(_ map: NSArray) throws {
        for model in map {
            do {
                let respModel = try SubscriptionPlanModel(model as! [String : Any])
                subscriptionPlans.append(respModel)
            } catch {
                print(error)
            }
        }
    }
}

struct SubscriptionPlanModel : SafeMappable {
    
    var id: Int = 0
    var name: String = ""
    var description: String = ""
    var registrationFee: Int = 0
    var monthlycharge: Float = 0
    var benefits: [PlanBenefit] = []
    
    init(_ map: [String : Any]) throws {
        id <- map.property("subscriptionId")
        name <- map.property("planName")
        description <- map.property("planDescription")
        registrationFee <- map.property("regFee")
        monthlycharge <- map.property("monthlyCharge")
        benefits <- map.relations("benefitList")
    }
    
    struct PlanBenefit : SafeMappable {
        var code: String = ""
        var name: String = ""
        var status: String = ""
        var limitType: String = ""
        var limitNumber: Int = 0
        var userNote: String = ""
        
        init(_ map: [String : Any]) throws {
            code <- map.property("benefitCode")
            name <- map.property("benefitName")
            status <- map.property("benefitStatus")
            limitType <- map.property("limitType")
            limitNumber <- map.property("limitNumber")
            userNote <- map.property("userNote")
        }
    }
}

