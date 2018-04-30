//
//  WLMPoolRegister.swift
//  Playing Offline HLS
//
//  Created by Midhun P Mathew on 11/6/17.
//  Copyright © 2017 Midhun P Mathew. All rights reserved.
//

import Foundation
class WLMPoolRegister: NSObject {
    static private let WLMPoolRegisterKey = "com.wlm.poolRegister"
    static let open = WLMPoolRegister()
    
    
    var poolRecords:[String:WLMPoolRecord]? {
        get{
            let offlinedAssetDefaults = UserDefaults.standard
            guard let  poolRegisterArchived:Data  = offlinedAssetDefaults.object(forKey: WLMPoolRegister.WLMPoolRegisterKey) as? Data else {
                return nil
            }
            guard let  poolRegisterUnarchived  = NSKeyedUnarchiver.unarchiveObject(with: poolRegisterArchived) as? [String : WLMPoolRecord] else {
                return nil
            }
            return poolRegisterUnarchived
        }
    }
    
    private override init() {
        
    }
    func isRecordExist(forUrl url:URL) ->Bool {
        guard let currentRecords = self.poolRecords else {
            return false
        }
        guard let _ =  currentRecords[url.absoluteString] else {
            return false
        }
        return true
    }
    func record(forUrlString url:String) -> WLMPoolRecord? {
        guard let currentRecords = self.poolRecords else {
            return nil
        }
        guard let record =  currentRecords[url] else {
            return nil
        }
        return record
    }
    
    func record(forUrl url:URL) -> WLMPoolRecord? {
        guard let currentRecords = self.poolRecords else {
            return nil
        }
        guard let record =  currentRecords[url.absoluteString] else {
            return nil
        }
        return record
    }
    
    func record(forUrl url:URL,forFullyDownloded isFullyDownloded:Bool) -> WLMPoolRecord? {
        guard let record = self.record(forUrl: url) else {
            return nil
        }
        if isFullyDownloded {
            if record.isFullyDownloaded {
                return record
            }else {
                return nil
            }
        }else {
            return record
        }
    }
    
    func addRecord(_ newRecord:WLMPoolRecord) {
        guard var currentRecords = self.poolRecords else {
            var newRecords = [String:WLMPoolRecord]()
            newRecords[newRecord.url] = newRecord
            self._save(newRecords)
            return
        }
        if currentRecords[newRecord.url] == nil {
            currentRecords[newRecord.url] = newRecord
            self._save(currentRecords)
        }else {
            print("allready present stop")
        }
    }
    func updateRecord(withNewRecord newRecord:WLMPoolRecord) {
       
        guard var currentRecords = self.poolRecords else {
            return
        }
        currentRecords[newRecord.url] = newRecord
        self._save(currentRecords)
    }
    func updateRecord(downlaodStats isFullyDownloaded:Bool,forUrl url:URL) {
        guard let record = self.record(forUrl: url) else {
            return
        }
        if !record.isFullyDownloaded {
            record.isFullyDownloaded = isFullyDownloaded
        }
        guard var currentRecords = self.poolRecords else {
            return
        }
        currentRecords[url.absoluteString] = record
        self._save(currentRecords)
    }
    
    func updateRecord(contentLength:Int64,contentType:String,isAcceptRanges:Bool,forUrl url:URL) {
        guard let record = self.record(forUrl: url) else {
            return
        }
        record.contentLength = contentLength
        record.contentType = contentType
        record.isAcceptRanges = isAcceptRanges
        guard var currentRecords = self.poolRecords else {
            return
        }
        currentRecords[url.absoluteString] = record
        self._save(currentRecords)
    }
    
    func deleteRecord(forUrlSting url:String) {
        guard var currentRecords = self.poolRecords else {
            return
        }
        if currentRecords[url] == nil {
            print("no info present stop")
        }else {
            currentRecords[url] = nil
            self._save(currentRecords)
        }
    }
    
    func deleteRecord(forUrl url:URL) {
        guard var currentRecords = self.poolRecords else {
            return
        }
        if currentRecords[url.absoluteString] == nil {
            print("no info present stop")
        }else {
            currentRecords[url.absoluteString] = nil
            self._save(currentRecords)
        }
    }
    
    func deleteRecord(_ record:WLMPoolRecord) {
        guard var currentRecords = self.poolRecords else {
            return
        }
        if currentRecords[record.url] == nil {
            print("no info present stop")
        }else {
            currentRecords[record.url] = nil
            self._save(currentRecords)
        }
    }
    
    func deleteAllRecords() {
        self._deleteAll()
    }
    
    private func _deleteAll(){
        let offlinedAssetDefaults = UserDefaults.standard
        offlinedAssetDefaults.removeObject(forKey: WLMPoolRegister.WLMPoolRegisterKey)
        
    }
    
    private func _save(_ assetInfo:[String:WLMPoolRecord]) {
        let offlinedAssetDefaults = UserDefaults.standard
        let encodedData:Data = NSKeyedArchiver.archivedData(withRootObject: assetInfo )
        offlinedAssetDefaults.set(encodedData, forKey: WLMPoolRegister.WLMPoolRegisterKey)
        offlinedAssetDefaults.synchronize()
    }
    
}
