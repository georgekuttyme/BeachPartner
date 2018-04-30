//
//  noteResponseModel.swift
//  BeachPartner
//
//  Created by Admin on 25/04/18.
//  Copyright © 2018 dev. All rights reserved.
//

import Foundation
import Tailor
//struct NoteRespModel : SafeMappable {
//    
//    var idToken: String = ""
//    
//    init(_ map: [String : Any]) throws {
//        //        print("mapp :",map)
//        
//        
//        idToken  <- map.property("idToken")
//        
//        
//    }
//}

struct NoteModel : SafeMappable {
    var note : String = ""
    var toUserId : Int = 0
        init(_ map: [String : Any]) throws {
        
    
            note  <- map.property("note")
    
    
        }
}
