//
//  DataModel.swift
//  JerryCardView
//
//  Created by Midhun P Mathew on 3/29/18.
//  Copyright © 2018 Midhun P Mathew. All rights reserved.
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
