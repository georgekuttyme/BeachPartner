//
//  WLMPoolLongMemory.swift
//  Playing Offline HLS
//
//  Created by Midhun P Mathew on 11/6/17.
//  Copyright © 2017 Midhun P Mathew. All rights reserved.
//

import Foundation
import AVFoundation
class WLMPoolLongMemory {
    let fileManager = FileManager()
    func add(_ videoData:Data?, withPoolRecord record:WLMPoolRecord){
        guard let _ = WLMPoolRegister.open.record(forUrlString: record.url) else {
            WLMPoolRegister.open.addRecord(record)
            guard let cachedPath = self.cacheDirectory() else {
                return
            }
            let location = cachedPath.appendingPathComponent(record.fileName)
            self.createFile(inLoaction: location)
            return
        }
        if let videoData = videoData {
            
            self.update(videoData, forUrl: URL(string:record.url)!)
        }
        //WLMPoolRegister.open.updateRecord(withNewRecord: record)
        
    }
    func getFullyDownloadedAsset(forUrl url:URL) -> AVURLAsset? {
        
        guard let record = WLMPoolRegister.open.record(forUrl: url, forFullyDownloded: true) else {
            return nil
        }
        guard let cachedPath = self.cacheDirectory() else {
            return nil
        }
        let assetUrl = cachedPath.appendingPathComponent(record.fileName)
        
        return AVURLAsset(url: assetUrl)
    }
    func getAsset(forUrl url:URL) -> AVURLAsset? {
        
        guard let record = WLMPoolRegister.open.record(forUrl: url) else {
            return nil
        }
        guard let cachedPath = self.cacheDirectory() else {
            return nil
        }
        let assetUrl = cachedPath.appendingPathComponent(record.fileName)
        
       return AVURLAsset(url: assetUrl)
    }
    
    func getVideoData(atUrl url:URL) -> Data? {
        guard let record = WLMPoolRegister.open.record(forUrl: url) else {
            return nil
        }
        guard let cachedPath = self.cacheDirectory() else {
            return nil
        }
        let file = cachedPath.appendingPathComponent(record.fileName)
        do {
            let availableData = try Data.init(contentsOf: file)
            return availableData
        }catch {
            print(error)
            return nil
        }
    
    }
    
    func getBufferingContentInformation(forUrl url:URL) -> WLMBufferingContentInformation?{
        guard let record = WLMPoolRegister.open.record(forUrl: url) else {
            return nil
        }
        
        return WLMBufferingContentInformation(contentLength: record.contentLength, contentType: record.contentType, isAcceptRanges: record.isAcceptRanges)
    }
    @discardableResult
    func update(_ videoData:Data,forUrl url:URL) -> Bool{
        guard let record = WLMPoolRegister.open.record(forUrl: url) else {
            return false
        }
        guard let cachedPath = self.cacheDirectory() else {
            return false
        }
        var isFullyDownloaded = false
        let currentSize:Int64 = Int64(videoData.count)
        let actualSize:Int64 = record.contentLength
        if currentSize >= actualSize {
            WLMPoolRegister.open.updateRecord(downlaodStats: true, forUrl: URL(string:record.url)!)
            isFullyDownloaded = true
        }
        let location = cachedPath.appendingPathComponent(record.fileName)
        self.automaticSave(theData: videoData, toFile: location)
        return isFullyDownloaded
    }
    func update(_ videoData:Data,forUrl url:URL,andIsDownloadedFully isDownloadedFully:Bool) {
        guard let record = WLMPoolRegister.open.record(forUrl: url) else {
            return
        }
        guard let cachedPath = self.cacheDirectory() else {
            return
        }
        WLMPoolRegister.open.updateRecord(downlaodStats: isDownloadedFully, forUrl: URL(string:record.url)!)
        let location = cachedPath.appendingPathComponent(record.fileName)
        self.automaticSave(theData: videoData, toFile: location)
        
    }
    @discardableResult
    private func automaticSave(theData data:Data,toFile location:URL) ->(Bool,URL?,Error?) {
        if fileManager.fileExists(atPath: location.path) {
            let result = self.save(theData:data,toFile:location)
            return (result.0,location,result.1)
        }else{
            fileManager.createFile(atPath: location.path, contents: nil, attributes: nil)
            self.addSkipBackupAttributeToItemAtURL(filePath: location.path)
            let result = self.save(theData:data,toFile:location)
            return (result.0,location,result.1)
        }
        
    }
    @discardableResult
    private func save(theData data:Data,toFile location:URL) ->(Bool,Error?) {
        if fileManager.fileExists(atPath: location.path) {
            do {
                try data.write(to: location, options: .atomicWrite)
            } catch  {
                print(error)
                return (false,error)
            }
            return (true,nil)
        }
        return (false,nil)
    }
    
    private func createFile(inLoaction loaction:URL) {
        if !fileManager.fileExists(atPath: loaction.path) {
            fileManager.createFile(atPath: loaction.path, contents: nil, attributes: nil)
            self.addSkipBackupAttributeToItemAtURL(filePath: loaction.path)
        }
    }
    
    @discardableResult
    private func addSkipBackupAttributeToItemAtURL(filePath:String) -> Bool {
        var url = URL(fileURLWithPath: filePath)
        assert(fileManager.fileExists(atPath: filePath), "File \(filePath) does not exist")
        var success: Bool
        do {
            var resourceValues = URLResourceValues()
            resourceValues.isExcludedFromBackup = true
            try url.setResourceValues(resourceValues)
            success = true
        } catch let error as NSError {
            success = false
            print("Error excluding \(url.lastPathComponent) from backup \(error)");
        }
        
        return success
    }
    private func documentDirectory() -> URL? {
        guard let documentDirectory =  fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        return documentDirectory
    }
    
    private func cacheDirectory() -> URL? {
        
        guard let documentDirectory = self.documentDirectory() else {
            return nil
        }
        let cacheDirectory = documentDirectory.appendingPathComponent("WLMVideoCache")
        if directoryExistsAtPath(cacheDirectory.absoluteString) {
            return cacheDirectory
        }else {
            do {
                try fileManager.createDirectory(atPath:cacheDirectory.path, withIntermediateDirectories: true, attributes: nil)
                return cacheDirectory
            } catch let error as NSError {
                NSLog("Unable to create directory \(error.debugDescription)")
                return nil
            }
        }
    }
    fileprivate func directoryExistsAtPath(_ path: String) -> Bool {
        var isDirectory = ObjCBool(true)
        let exists = fileManager.fileExists(atPath: path, isDirectory: &isDirectory)
        return exists && isDirectory.boolValue
    }
}
