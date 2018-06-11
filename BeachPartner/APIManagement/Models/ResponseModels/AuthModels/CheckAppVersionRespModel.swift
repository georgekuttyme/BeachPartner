//
//  CheckAppVersionRespModel.swift
//  BeachPartner
//
//  Created by Powermac on 6/11/18.
//  Copyright © 2018 dev. All rights reserved.
//

import Foundation
import Tailor
struct CheckAppBuildNumber : SafeMappable{
    
    var status: String = ""
    var message: String = ""
    var deviceType: String = ""
    var currentVersion: Int = 0
    var latestVersion: Int = 0
    var currentBuild: Int = 0
    var latestBuild: Int = 0
    var updateAvailable: Bool?
    var mandatoryUpdate: Bool?
    
    init(_ map: [String : Any]) throws {
        status <- map.property("status")
        message <- map.property("message")
        deviceType <- map.property("deviceType")
        currentVersion <- map.property("currentVersion")
        latestVersion <- map.property("latestVersion")
        currentBuild <- map.property("currentBuild")
        latestBuild <- map.property("latestBuild")
        updateAvailable <- map.property("updateAvailable")
        mandatoryUpdate <- map.property("mandatoryUpdate")
    }
    
}

