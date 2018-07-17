//
//  CheckAppVersionRespModel.swift
//  BeachPartner
//
//  Created by Beach Partner LLC on 6/11/18.
//  Copyright © 2018 Beach Partner LLC. All rights reserved.
//

import Foundation
import Tailor
struct CheckAppBuildNumber : SafeMappable{
    
    var status: String = ""
    var title: String = ""
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
        title <- map.property("title")
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

