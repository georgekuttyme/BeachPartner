//
//  WLMPoolData.swift
//  Playing Offline HLS
//
//  Created by Midhun P Mathew on 11/6/17.
//  Copyright © 2017 Midhun P Mathew. All rights reserved.
//

import Foundation

class WLMPoolRecord: NSObject, NSCoding {
    
    static private let urlArchiveKey               = "com.wlm.poolData.url"
    static private let dataPathArchiveKey          = "com.wlm.poolData.fileName"
    static private let isFullyDownloadedArchiveKey = "com.wlm.poolData.isFullyDownloaded"
    
    static private let contentLengthKey            = "com.wlm.poolData.contentLength"
    static private let contentTypeKey              = "com.wlm.poolData.contentType"
    static private let isAcceptRangesKey           = "com.wlm.poolData.isAcceptRanges"
    
    var url: String
    var fileName: String
    var isFullyDownloaded:Bool
    var contentLength:Int64
    var contentType:String
    var isAcceptRanges:Bool
    
    init(url:String, fileName: String, isFullyDownloaded:Bool,contentLength:Int64,contentType:String,isAcceptRanges:Bool) {
        self.url = url
        self.fileName = fileName
        self.isFullyDownloaded = isFullyDownloaded
        self.contentLength = contentLength
        self.contentType = contentType
        self.isAcceptRanges = isAcceptRanges
    }
    
    public convenience required init?(coder aDecoder: NSCoder) {
        let url = aDecoder.decodeObject(forKey: WLMPoolRecord.urlArchiveKey) as! String
        let fileName = aDecoder.decodeObject(forKey: WLMPoolRecord.dataPathArchiveKey) as! String
        let isFullyDownloaded = aDecoder.decodeBool(forKey: WLMPoolRecord.isFullyDownloadedArchiveKey)
        let contentLength = aDecoder.decodeInt64(forKey: WLMPoolRecord.contentLengthKey)
        let contentType = aDecoder.decodeObject(forKey: WLMPoolRecord.contentTypeKey) as! String
        let isAcceptRanges = aDecoder.decodeBool(forKey: WLMPoolRecord.isAcceptRangesKey)
        
        self.init(url: url, fileName: fileName, isFullyDownloaded: isFullyDownloaded,contentLength: contentLength,contentType: contentType,isAcceptRanges: isAcceptRanges)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.url, forKey: WLMPoolRecord.urlArchiveKey)
        aCoder.encode(self.fileName, forKey: WLMPoolRecord.dataPathArchiveKey)
        aCoder.encode(self.isFullyDownloaded, forKey: WLMPoolRecord.isFullyDownloadedArchiveKey)
        aCoder.encode(self.contentLength, forKey: WLMPoolRecord.contentLengthKey)
        aCoder.encode(self.contentType, forKey: WLMPoolRecord.contentTypeKey)
        aCoder.encode(self.isAcceptRanges, forKey: WLMPoolRecord.isAcceptRangesKey)
    }
}
