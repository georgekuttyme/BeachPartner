//
//  WLMAssetPool.swift
//  Playing Offline HLS
//
//  Created by Beach Partner LLC on 11/6/17.
//  Copyright © 2017 Beach Partner LLC. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

class WLMAssetPool: NSObject {
    public enum WLMPoolBufferingPriority : Int {
        case high
        
        case medium
        
        case low
        
        case none
    
    }
    static private let kBufferingQueue   = "wlm.buffering.queue"
    static private let kDownloadingQueue = "wlm.downloading.queue"
    static  let kWLMCacheScheme   = "wlmcache://"
    
    
    static let shared = WLMAssetPool()
    let memory = WLMPoolMemory()
    let bufferingQueue = DispatchQueue(label: WLMAssetPool.kBufferingQueue, qos: DispatchQoS.userInteractive)
    //let bufferingQueue = DispatchQueue.main
    let downloadingQueue = OperationQueue()
    var downloadSession :URLSession!
    lazy var onGoingBuffering = [URL:WLMAssetBuffer]()
    
    private override init() {
        super.init()
        
        self.downloadingQueue.name = WLMAssetPool.kDownloadingQueue
        self.downloadingQueue.qualityOfService = .userInteractive
       
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.httpMaximumConnectionsPerHost = 1
        sessionConfiguration.timeoutIntervalForRequest     = 100
        sessionConfiguration.timeoutIntervalForResource    = 0
        sessionConfiguration.httpShouldUsePipelining  = true
        
        
        self.downloadSession = URLSession(configuration: sessionConfiguration, delegate: self, delegateQueue: downloadingQueue)
        self.addApplicationObservers()
    }
    
    
    public func prepareAsset(forUrl url:URL,withCompletion completion:@escaping (_ asset:AVURLAsset)->()) {
      
           completion(self.makeAsset(url))
        
    }
    
    internal func makeAsset(_ url:URL) -> AVURLAsset {
        guard let asset = self.memory.canRemember(thisUrl: url) else {
            if let urlInWLMScheme = url.converToWlmScheme() {
               let asset = AVURLAsset(url:urlInWLMScheme)
               let assetBuffer = WLMAssetBuffer(forUrl: url, in: self.downloadSession)
               asset.resourceLoader.setDelegate(assetBuffer , queue: bufferingQueue)
               assetBuffer.delegate = self
               self.memory.memorize(thisAsset: asset)
               self.onGoingBuffering[url] = assetBuffer
               //giveBufferingPriority(toUrl: url, withPriority: .medium)
               return asset
            }
            return AVURLAsset(url: url)
        }
        //giveBufferingPriority(toUrl: url, withPriority: .medium)
        return asset
    }
    
    func giveBufferingPriority(toUrl url:URL,withPriority priority:WLMPoolBufferingPriority) {
        
            
        if (self.onGoingBuffering[url] == nil) {
            return
        }
        for download in self.onGoingBuffering.values {
            download.forceToStopBuffering()
        }
        
        switch priority {
        case .high:
            if let priorityBuffering = self.onGoingBuffering[url] {
               priorityBuffering.activate()
            }
        case .medium:
            for download in self.onGoingBuffering.values {
                if download.url?.absoluteString == url.absoluteString {
                    download.activate(withPriority: 1.0)
                }else {
                    download.activate(withPriority: 0.0)
                }
            }
        case .low:
            for download in self.onGoingBuffering.values {
                if download.url?.absoluteString == url.absoluteString {
                    download.activate(withPriority: 1.0)
                }else {
                    download.activate(withPriority: 0.5)
                }
            }
        case .none:
            for download in self.onGoingBuffering.values {
               download.activate(withPriority: 0.5)
            }
        }
            
    }
    

    internal func addApplicationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleApplicationDidEnterBackground(_:)), name: .UIApplicationDidEnterBackground, object: UIApplication.shared)
        NotificationCenter.default.addObserver(self, selector: #selector(handleApplicationDidBecomeActive(_:)), name: .UIApplicationDidBecomeActive, object: UIApplication.shared)
        NotificationCenter.default.addObserver(self, selector: #selector(handleMemoryWarning(_:)), name: .UIApplicationDidReceiveMemoryWarning, object: UIApplication.shared)
    }
    internal func removeApplicationObservers() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc internal func handleApplicationDidEnterBackground(_ aNotification: Notification) {
        WLMAssetPoolBackgroundTask.run(application: UIApplication.shared) { backgroundTask in
            for download in self.onGoingBuffering.values {
                download.pause()
            }
            backgroundTask.end()
        }
    }
    
    @objc internal func handleApplicationDidBecomeActive(_ aNotification: Notification) {
        for download in self.onGoingBuffering.values {
            download.resume()
        }
    }
    
    @objc internal func handleMemoryWarning(_ aNoticiation: Notification) {
        for download in self.onGoingBuffering.values {
            download.cancel()
        }
        self.onGoingBuffering.removeAll()
        self.memory.forgetAll()
    }
    deinit {
        self.removeApplicationObservers()
    }
    
}
extension WLMAssetPool : WLMAssetBufferDelegate {
    func assetBuffer(_ buffer: WLMAssetBuffer, completedWith state: WLMAssetBuffer.CompletionStatus, forUrl url: URL) {
        if state == .canceled || state == .completed {
            if self.onGoingBuffering[url] != nil {
                self.onGoingBuffering[url] = nil
            }
        }else if state == .paused {
            print("pauused = \(url.absoluteString)")
        }else if state == .started {
           print("started = \(url.absoluteString)")
        }
    }
}
extension WLMAssetPool : URLSessionDelegate, URLSessionDataDelegate {
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        bufferingQueue.async {
            if let url =  task.originalRequest?.url {
                if let buffer = self.onGoingBuffering[url] {
                    buffer.bufferingDownloadEvents?.assetBuffer(buffer, didCompleteWithError: error)
                }
            }
        }
    }
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Swift.Void) {
        bufferingQueue.async {
            if let url =  dataTask.originalRequest?.url {
                if let buffer = self.onGoingBuffering[url] {
                    buffer.bufferingDownloadEvents?.assetBuffer(buffer, didReceive: response, completionHandler: { (responseDisposition) in
                        completionHandler(responseDisposition)
                    })
                }
            }
        }
    }
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
         bufferingQueue.async {
            if let url =  dataTask.originalRequest?.url {
                if let buffer = self.onGoingBuffering[url] {
                    buffer.bufferingDownloadEvents?.assetBuffer(buffer, didReceive: data)
                }
            }
        }
     }
}
