//
//  UpdateNoteRespModel.swift
//  BeachPartner
//
//  Created by seq-mary on 27/04/18.
//  Copyright © 2018 dev. All rights reserved.
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

