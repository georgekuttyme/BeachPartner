//
//  WLMPoolMemory.swift
//  Playing Offline HLS
//
//  Created by Midhun P Mathew on 11/6/17.
//  Copyright © 2017 Midhun P Mathew. All rights reserved.
//

import Foundation
import AVFoundation
class WLMPoolMemory: NSObject {
    
    lazy var shortTermMemory = WLMPoolShortMemory()
    lazy var longTermMemory  = WLMPoolLongMemory()
    
    func canRemember(thisUrl url:URL) ->AVURLAsset? {
        guard let asset = self.shortTermMemory.getAsset(forUrl: url) else {
            guard let asset = self.longTermMemory.getFullyDownloadedAsset(forUrl: url) else {
                return nil
            }
            return asset
        }
        return asset
    }
    
    func memorize(thisAsset asset:AVURLAsset) {
        self.shortTermMemory.add(asset)
    }
    @discardableResult
    func memorize(thisVideoData data:Data,forUrl url:URL) ->Bool {
        return self.longTermMemory.update(data, forUrl: url)
    }
    func memorize(thisVideoData data:Data?,with record:WLMPoolRecord)  {
         self.longTermMemory.add(data, withPoolRecord: record)
    }
    func videoData(forUrl url:URL) -> Data? {
        let videoData = self.longTermMemory.getVideoData(atUrl: url)
        return videoData
    }
    
    func contentInformation(forUrl url:URL) -> WLMBufferingContentInformation? {
        return self.longTermMemory.getBufferingContentInformation(forUrl: url)
    }
    
    func forgetAll(){
        self.shortTermMemory.freeUp()
    }
}
