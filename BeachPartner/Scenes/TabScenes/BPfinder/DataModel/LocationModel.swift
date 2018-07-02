//
//  LocationData.swift
//  BeachPartner
//
//  Created by Beach Partner LLC on 30/03/18.
//  Copyright © 2018 Beach Partner LLC. All rights reserved.
//

import Foundation
import Foundation
struct LocationModel {
    var name:String
    
    var code:String
    
    init( name:String, code:String) {
//        self.imageUrl = DataModel.makeImageUrl(fromImageName: imgName)
        self.name = name
        self.code = code
    }
    
    
//    static func makeImageUrl(fromImageName name:String) -> String {
//        return "http://seqato.com/bp/images/" + name
//    }
}
