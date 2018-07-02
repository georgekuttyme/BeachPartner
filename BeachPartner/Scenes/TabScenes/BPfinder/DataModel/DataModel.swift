//
//  DataModel.swift
//  JerryCardView
//
//  Created by Beach Partner LLC on 3/29/18.
//  Copyright © 2018 Beach Partner LLC. All rights reserved.
//

import Foundation
struct DataModel {
    var name:String
    var place:String
    var imageUrl:String
    var videoUrl:String
    var userId:String
    
    init(_ name:String, place:String, imageName imgName:String, videoUrl:String, userId:String) {
        self.imageUrl = DataModel.makeImageUrl(fromImageName: imgName)
        self.videoUrl = videoUrl
        self.name = name
        self.place = place
        self.userId = userId
    }
    
    
    static func makeImageUrl(fromImageName name:String) -> String {
        return "http://seqato.com/bp/images/" + name
    }
}
