//
//  WLMAssetPoolExtensions.swift
//  Playing Offline HLS
//
//  Created by Beach Partner LLC on 11/6/17.
//  Copyright © 2017 Beach Partner LLC. All rights reserved.
//

import Foundation
extension URL {
    func converToWlmScheme() -> URL? {
        return URL(string: WLMAssetPool.kWLMCacheScheme.appending(self.absoluteString))
    }
    func removeWlmScheme() -> URL? {
        var originURLString = self.absoluteString
        originURLString = originURLString.replacingOccurrences(of:  WLMAssetPool.kWLMCacheScheme, with: "")
        return URL(string: originURLString)
    }
}
extension Date {
    var timeStamp: String {
        return String(UInt64((self.timeIntervalSince1970 + 62_135_596_800) * 10_000_000))
    }
}
