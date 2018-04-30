//
//  LocationData.swift
//  BeachPartner
//
//  Created by Jerry K Mathew on 30/03/18.
//  Copyright © 2018 dev. All rights reserved.
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
