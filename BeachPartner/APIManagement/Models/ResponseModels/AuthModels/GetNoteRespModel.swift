//
//  File.swift
//  BeachPartner
//
//  Created by Admin on 27/04/18.
//  Copyright © 2018 dev. All rights reserved.
//

import Foundation
import Tailor

struct GetNoteRespModelArray: SafeMappable {
    
    var getNoteRespModel = [GetNoteRespModel]()
    
    init(_ map: [String : Any]) throws {
        
    }
    
    init(_ map: NSArray) throws {
        for model in map {
            
            do {
                let respModel = try GetNoteRespModel(model as! [String : Any])
                getNoteRespModel.append(respModel)
            } catch {
                print(error)
            }
        }
    }
    
}
struct GetNoteRespModel : SafeMappable {
    
    var createdDate : String = ""
    var loginType : String = ""
    var fromUser_:fromUser?
    var toUser_:toUser?
    init(_ map: [String : Any]) throws {
        createdDate <- map.property("createdDate")
        fromUser_ <- map.relation("fromUser")
        toUser_ <- map.relation("toUser")
    }
    struct fromUser: SafeMappable {
        var fromUserId : Int = 0
        var note : String = ""
        init(_ map: [String : Any]) throws {
            fromUserId <- map.property("id")
            note <- map.property("note")
        }
        
    }
    struct toUser: SafeMappable {
        var toUserId : Int = 0
        var note : String = ""
        init(_ map: [String : Any]) throws {
            toUserId <- map.property("id")
            note <- map.property("note")
        }
    }
}

