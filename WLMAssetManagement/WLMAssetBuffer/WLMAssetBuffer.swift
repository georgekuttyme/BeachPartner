//
//  WLMAssetBuffer.swift
//  Playing Offline HLS
//
//  Created by Midhun P Mathew on 11/6/17.
//  Copyright © 2017 Midhun P Mathew. All rights reserved.
//

import Foundation
import AVFoundation
import MobileCoreServices
protocol WLMAssetBufferingDownloadSessionEvents : class {
    func assetBuffer(_ buffer:WLMAssetBuffer, didReceive data: Data)
    func assetBuffer(_ buffer:WLMAssetBuffer, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Swift.Void)
    func assetBuffer(_ buffer:WLMAssetBuffer, didCompleteWithError error: Error?)
}
protocol WLMAssetBufferDelegate : class {
    func assetBuffer(_ buffer:WLMAssetBuffer,completedWith state:WLMAssetBuffer.CompletionStatus,forUrl url:URL)
}
struct WLMBufferingContentInformation {
    let contentLength:Int64
    let contentType:String
    let isAcceptRanges:Bool
    
    init(contentLength:Int64,contentType:String,isAcceptRanges:Bool) {
        self.contentLength = contentLength
        self.contentType = contentType
        self.isAcceptRanges = isAcceptRanges
    }
}
class WLMAssetBuffer: NSObject {
    public enum CompletionStatus : Int {
        case completed
        
        case error
        
        case canceled
        
        case retry
        
        case paused
        
        case stoped
        
        case started
    }
    public enum State : Int {
        case unknown
        
        case error
        
        case running
        
        case suspended
        
        case canceling
        
        case completed
    }
    var isObserveBufferingDownloadEvents:Bool {
        get {
            return self.bufferingDownloadEvents == nil
        }
        set {
            self.bufferingDownloadEvents = newValue == true ? self : nil
        }
    }
    internal var state:WLMAssetBuffer.State = .unknown
    internal var isRetrying = false
    internal var isForceToStop = false
    internal weak var sessoin:URLSession?
    internal var task: URLSessionDataTask?
    internal var url:URL?
    internal var videoData:Data?
    internal var bufferingContentInformation:WLMBufferingContentInformation?
    internal var error:Error?
    lazy internal var pendingRequests = [AVAssetResourceLoadingRequest]()
    
    internal weak var bufferingDownloadEvents:WLMAssetBufferingDownloadSessionEvents?
    internal weak var delegate :WLMAssetBufferDelegate?
    
    init(forUrl url:URL,in session:URLSession) {
        super.init()
        self.sessoin = session
        self.url = url
        self.bufferingDownloadEvents = self
    }
    func activate() {
        let request = self.createSuitableRequest(forUrl: self.url!)
        self.task = self.sessoin?.dataTask(with: request)
        self.resume()
        print("buffering started -\(String(describing: self.url?.lastPathComponent))")
    }
    
    func activate(withPriority priority:Float) {
        let request = self.createSuitableRequest(forUrl: self.url!)
        self.task = self.sessoin?.dataTask(with: request)
        self.task?.priority = priority
        self.resume()
        print("buffering started -\(String(describing: self.url?.lastPathComponent))")
    }
    
    func resume() {
        guard let task = self.task else {
            return
        }
        task.resume()
        self.state = .running
         self.delegate?.assetBuffer(self, completedWith: .started, forUrl: self.url!)
    }
    
    func pause() {
        guard let task = self.task else {
            return
        }
        task.suspend()
        self.state = .suspended
        WLMAssetPool.shared.memory.memorize(thisVideoData: self.videoData!, forUrl: self.url!)
        self.delegate?.assetBuffer(self, completedWith: .paused, forUrl: self.url!)
    }
    
    func forceToStopBuffering(){
        self.isForceToStop = true
        self.cancel()
        self.task = nil
    }
    
    func cancel() {
        guard let task = self.task else {
            return
        }
        task.cancel()
        self.state = .canceling
        WLMAssetPool.shared.memory.memorize(thisVideoData: self.videoData!, forUrl: self.url!)
        
    }
    internal func createSuitableRequest(forUrl url:URL) -> URLRequest {
        self.videoData = Data()
        if let availableData = WLMAssetPool.shared.memory.videoData(forUrl: url) {
            self.bufferingContentInformation = WLMAssetPool.shared.memory.contentInformation(forUrl: url)
            self.videoData?.append(availableData)
        }
        let availableBytes = self.videoData?.count ?? 0
        var mutableRequest = URLRequest(url: url)
        mutableRequest.setValue("0", forHTTPHeaderField: "Content-Length")
        let range = "bytes=\(availableBytes)-"
        mutableRequest.setValue(range, forHTTPHeaderField: "Range")
        return mutableRequest
    }
    
    
    internal func fileCorruptedReuestingFromStart(){
       self.refreshForRetry()
       self.videoData = Data()
       self.task = self.sessoin?.dataTask(with: self.url!)
    }
    internal func networkProblemRequestingFromStart() {
       self.refreshForRetry()
       self.task = self.sessoin?.dataTask(with: createSuitableRequest(forUrl: self.url!))
    }
    
    func refreshForRetry() {
        self.isRetrying = true
        self.cancel()
        self.task = nil
        self.delegate?.assetBuffer(self, completedWith: .retry, forUrl: self.url!)
    }
    func distroy() {
        print("**distroying... \(String(describing: self.url?.absoluteString))")
        self.isObserveBufferingDownloadEvents = false
        self.cancel()
        self.pendingRequests.removeAll()
        self.videoData = nil
        self.url = nil
        self.bufferingContentInformation = nil
        
    }
    
    deinit {
        self.distroy()
    }
}

extension WLMAssetBuffer : WLMAssetBufferingDownloadSessionEvents {
    
    func isCorrupted(receivedFileRanges rangeString:String) -> Bool{
        var requestedStartRange:Int64 = 0
        var contentLenght:Int64 = 0
        var startRange:Int64 = 0
        var endRange:Int64 = 0
        
        if let data =  self.videoData {
            requestedStartRange = Int64(data.count)
        }
        
        var  filteredString = rangeString.replacingOccurrences(of: " ", with: "")
        filteredString = rangeString.replacingOccurrences(of: "bytes", with: "")
        let seperatedStringArray = filteredString.components(separatedBy: "/")
        if seperatedStringArray.count == 2 {
            if let contentLenghtString = seperatedStringArray.last {
               contentLenght = Int64(contentLenghtString) ?? 0
            }
            if var rangesString = seperatedStringArray.first {
                rangesString = rangesString.replacingOccurrences(of: " ", with: "")
                let ranges = rangesString.components(separatedBy: "-")
                
                if ranges.count > 1 {
                    if var startRangeString = ranges.first {
                       startRangeString = startRangeString.replacingOccurrences(of: " ", with: "")
                       startRange = Int64(startRangeString) ?? 0
                    }
                    if var endRangeString = ranges.last {
                        endRangeString = endRangeString.replacingOccurrences(of: " ", with: "")
                        endRange = Int64(endRangeString) ?? 0
                    }
                    
                    
                }
                
            }
        }
        print("contentLenght recived = \(contentLenght) endRange = \(endRange)")
        if requestedStartRange == startRange {
            return false
        } else if requestedStartRange <  startRange { // data missing
          //  print("data missing = \(startRange - requestedStartRange)")
            return true
        } else { // cut down the extra data for synching with received data.
            let range = Range(Int(0)..<Int(startRange))
            if let data = self.videoData {
                let newData = data.subdata(in: range)
                self.videoData = newData
            }
            return false
        }

    }
    
    
    func assetBuffer(_ buffer:WLMAssetBuffer, didReceive data: Data){
        self.videoData?.append(data)
        self.processPendingRequests()
    }
    func assetBuffer(_ buffer:WLMAssetBuffer, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Swift.Void){
        if let mimeType = response.mimeType {
            if (mimeType.range(of: "video/") == nil) &&
                (mimeType.range(of: "audio/") == nil  &&
                    mimeType.range(of: "application") == nil){
                completionHandler(.cancel)
                return
            } else {
                
                guard let response:HTTPURLResponse = response as? HTTPURLResponse else {
                    completionHandler(.cancel)
                    return
                }
                self.isRetrying = false
                var contentLength = Int64(0)
                var contentType = "public.mpeg-4"
                var isAcceptRanges = false
                var rangeString = ""
                let headerFields = response.allHeaderFields
                    // Accept-Ranges.
                    if let acceptRanges:String = headerFields["Accept-Ranges"] as? String {
                        if acceptRanges == "bytes" {
                            // yes, it accept ranges.
                            isAcceptRanges = true
                        }else {
                            // no, does not accept ranges.
                            isAcceptRanges = false
                        }
                    }
                    // content length.
                    
                    if let contentLength1:String = headerFields["content-range"] as? String {
                        rangeString = contentLength1
                        if let length = contentLength1.components(separatedBy: "/").last {
                            contentLength = Int64(length) ?? 0
                        }
                    }
                    // OR
                    if let contentLength2:String = headerFields["Content-Range"] as? String {
                        rangeString = contentLength2
                        if let length = contentLength2.components(separatedBy: "/").last {
                            contentLength = Int64(length) ?? 0
                        }
                    }
                    // content type.
                    if let mimeType = response.mimeType {
                        let type =  UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType, mimeType as CFString, nil)
                        if let takeUnretainedValue = type?.takeUnretainedValue() {
                            contentType = takeUnretainedValue as String
                        }
                    }
                if self.isCorrupted(receivedFileRanges:rangeString){
                   self.fileCorruptedReuestingFromStart()
                }
                
                if bufferingContentInformation == nil {
                    bufferingContentInformation = WLMBufferingContentInformation(contentLength:contentLength , contentType: contentType, isAcceptRanges: isAcceptRanges)
                }
                if let url = self.url {
                    let record =  WLMPoolRecord(url: url.absoluteString, fileName: url.lastPathComponent, isFullyDownloaded: false, contentLength: contentLength, contentType: contentType, isAcceptRanges: isAcceptRanges)
                    WLMAssetPool.shared.memory.memorize(thisVideoData: nil, with: record)
                }
                self.processPendingRequests()
                completionHandler(.allow)
             }
        }
     }
    func assetBuffer(_ buffer:WLMAssetBuffer, didCompleteWithError error: Error?){
        self.processPendingRequests()
        if error == nil {
            self.state = .completed
            if let data = self.videoData {
                if let url = self.url {
                   let isCompleted =  WLMAssetPool.shared.memory.memorize(thisVideoData: data, forUrl: url)
                    if isCompleted {
                       self.delegate?.assetBuffer(self, completedWith: .completed, forUrl: url)
                    } else {
                       self.delegate?.assetBuffer(self, completedWith: .stoped, forUrl: url)
                    }
                }
            }
        }else {
            self.error = error
            self.state = .error
            let errorCode = (error! as NSError).code
            switch errorCode {
            case -999:
                print("Buffering canceled \(String(describing: self.url?.lastPathComponent))")
                if !self.isRetrying && !self.isForceToStop {
                    self.delegate?.assetBuffer(self, completedWith: .canceled, forUrl: self.url!)
                } else {
                    if self.isForceToStop {
                        self.isForceToStop = false
                    }
                }
            case -1009:
                print("no connection")
            case -1001:
                print("time out")
                self.networkProblemRequestingFromStart()
            case -1003:
                print("time out")
                self.networkProblemRequestingFromStart()
            case -1005:
                print("conection lost")
                self.networkProblemRequestingFromStart()
            case -1200:
                print("attempt to establish a secure connection fails")
                self.networkProblemRequestingFromStart()
            default:
                print(errorCode)
            }
        }
    }
}
extension WLMAssetBuffer : AVAssetResourceLoaderDelegate {
    
    func resourceLoader(_ resourceLoader: AVAssetResourceLoader, didCancel loadingRequest: AVAssetResourceLoadingRequest) {
       // print("didCancel didCancel")
        if let index = self.pendingRequests.index(of: loadingRequest) {
            if !loadingRequest.isFinished{
                loadingRequest.finishLoading()
            }
            self.pendingRequests.remove(at: index)
            self.pause()
        }
    }
    
    func resourceLoader(_ resourceLoader: AVAssetResourceLoader, shouldWaitForLoadingOfRequestedResource loadingRequest: AVAssetResourceLoadingRequest) -> Bool {
        
        self.pendingRequests.append(loadingRequest)
        print("append requests")
        if self.state == .completed {
            self.processPendingRequests()
            return true
        }
        
        if self.state == .suspended {
            
            self.resume()
            self.processPendingRequests()
            return true
        }
        if self.task == nil {
            self.activate()
        }
        self.processPendingRequests()
        return true
    }
    
    func processPendingRequests() {
        var completedRequests = [AVAssetResourceLoadingRequest]()
        for request in self.pendingRequests {
            self.fill(resourceLoadingContentInformation: request.contentInformationRequest)
            let didRespondCompletely = self.respond(withResourceLoadingDataRequest: request.dataRequest)
            if didRespondCompletely {
                
                if !request.isFinished  {
                    request.finishLoading()
                    completedRequests.append(request)
                }
                
            }
        }
        for completedRequest in completedRequests {
            if let index = self.pendingRequests.index(of: completedRequest) {
                self.pendingRequests.remove(at: index)
            }
        }
    }
    
    func fill(resourceLoadingContentInformation contentInformationRequest:AVAssetResourceLoadingContentInformationRequest?){
        
        
        guard let preparedContentInformation =  self.bufferingContentInformation else {
            return
        }
        guard let contentInformation =  contentInformationRequest else {
            return
        }
        contentInformation.contentType = preparedContentInformation.contentType
        contentInformation.isByteRangeAccessSupported = preparedContentInformation.isAcceptRanges
        contentInformation.contentLength = preparedContentInformation.contentLength
        
     }
    
    func respond(withResourceLoadingDataRequest resourceLoadingDataRequest:AVAssetResourceLoadingDataRequest?) -> Bool {
        guard let dataRequest = resourceLoadingDataRequest else {
            return false
        }
        var startOffset = dataRequest.requestedOffset
        
        if  dataRequest.currentOffset != 0 {
            
            startOffset = dataRequest.currentOffset;
        }
        
        guard let videoData =  self.videoData else {
            return false
        }
        
        // Don't have any data at all for this request
        if (Int64(videoData.count) < startOffset){
            
            return false;
        }
        
        // This is the total data we have from startOffset to whatever has been downloaded so far
        let unreadBytes = Int64(videoData.count) - startOffset
        // Respond with whatever is available if we can't satisfy the request fully yet
        let numberOfBytesToRespondWith =  min(Int(dataRequest.requestedLength) , Int(unreadBytes))
        // let range: ClosedRange = Int(startOffset)...numberOfBytesToRespondWith
        //        let range =  Range(uncheckedBounds: (lower: Int(startOffset), upper: numberOfBytesToRespondWith))
//        print("buffering ... \(String(describing: self.url?.lastPathComponent))")
//        print("data:\(videoData.count),,,(\(startOffset),\(numberOfBytesToRespondWith))")
        
        let range = Range(Int(startOffset)..<(numberOfBytesToRespondWith + Int(startOffset) ))
       // print("range = \(range.lowerBound),\(range.upperBound)")
        let requestedData = videoData.subdata(in: range)
        
        dataRequest.respond(with: requestedData)
        
        let endOffset:Int64 = Int64(startOffset) + Int64(dataRequest.requestedLength)
        
        let didRespondFully = Int64(videoData.count) >= endOffset
       // print("didRespondFully == \(didRespondFully)" )
        return didRespondFully
    }

}



