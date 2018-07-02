//
//  UpdateNoteRespModel.swift
//  BeachPartner
//
//  Created by Beach Partner LLC on 27/04/18.
//  Copyright © 2018 Beach Partner LLC. All rights reserved.
//

import Foundation
import Tailor


struct UpdateNoteRespModel: SafeMappable {
    var id : Int = 0
    var note : String = ""
    init(_ map: [String : Any]) throws {
        id <- map.property("id")
        note <- map.property("note")
    }
}

