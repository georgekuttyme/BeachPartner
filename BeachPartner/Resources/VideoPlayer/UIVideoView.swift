//
//  UIVideoView.swift
//  JerryCardView
//
//  Created by Midhun P Mathew on 3/29/18.
//  Copyright © 2018 Midhun P Mathew. All rights reserved.
//

import UIKit
import AVFoundation

class VideoAssetLoder: NSObject {
    public typealias VideoAssetLoderResultClosure = (_ playerItem:AVPlayerItem?,_ error:Error?)->Void
    internal struct AVAssetKey {
        var status:AVKeyValueStatus = .unknown
        let value:String
        init(_ value:String) {
            self.value = value
        }
    }
    public var videoAsset:AVURLAsset?
    
    
    internal var resultClouser:VideoAssetLoderResultClosure?
    internal var url:URL!
    
    
    
    internal lazy var playableKey = AVAssetKey("playable")
    internal lazy var durationkey = AVAssetKey("duration")
    internal lazy var tracksKey   = AVAssetKey("tracks")
    
    public var isAssetLoaded:Bool {
        get{
            return  self.playableKey.status == .loaded && self.durationkey.status == .loaded  && self.tracksKey.status == .loaded && self.videoAsset != nil
        }
    }
    
    override init() {
        super.init()
    }
    
    public func load(_ url:URL,withResultClouser completion:@escaping VideoAssetLoderResultClosure) {
        self.resultClouser = completion
        self.url = url
        self.videoAsset = AVURLAsset(url: self.url)
        self.loadKeys()
        
    }
    internal func returnPlayerItem() {
        guard let callback = self.resultClouser else {
            return
        }
        if let asset = self.videoAsset {
            DispatchQueue.main.async {
                let playerItem = AVPlayerItem(asset: asset)
                playerItem.canUseNetworkResourcesForLiveStreamingWhilePaused = true
                callback(playerItem, nil)
                self.resultClouser = nil
            }
            return
        }
    }
    internal func loadKeys() {
        guard let asset = self.videoAsset else {
            return
        }
        let requiredkeys = [playableKey.value,durationkey.value,tracksKey.value]
        asset.loadValuesAsynchronously(forKeys: requiredkeys) {
            var error: NSError? = nil
            for requiredkey in requiredkeys {
                let status:AVKeyValueStatus = asset.statusOfValue(forKey: requiredkey, error: &error)
                switch requiredkey {
                case self.playableKey.value:
                    self.playableKey.status = status
                case self.durationkey.value:
                    self.durationkey.status = status
                case self.tracksKey.value:
                    self.tracksKey.status = status
                default:break
                }
            }
            if self.playableKey.status == .loaded && self.durationkey.status == .loaded  && self.tracksKey.status == .loaded {
                self.returnPlayerItem()
                return
                
            } else {
                guard let callback = self.resultClouser else {
                    return
                }
                callback(nil, error)
                self.resultClouser = nil
                return
            }
        }
    }
}



public enum VideoViewGravityMode: Int {
    case resize
    case resizeAspect      // default
    case resizeAspectFill
}
fileprivate struct AVPlayerItemKVOKeys {
    static let status                  = "status"
    static let playbackBufferEmpty     = "playbackBufferEmpty"
    static let isPlaybackBufferFull    = "isPlaybackBufferFull"
    static let playbackLikelyToKeepUp  = "playbackLikelyToKeepUp"
    static let loadedTimeRanges        = "loadedTimeRanges"
}

fileprivate var playerItemObserverContext = 0
fileprivate var playerObserverContext = 0
class UIVideoView: UIView {
    override public class var layerClass: AnyClass {
        get {
            return AVPlayerLayer.self
        }
    }
    internal var _videoLayer: AVPlayerLayer {
        
        return self.layer as! AVPlayerLayer
    }
    internal var _player:AVPlayer? {
        get {
            return self._videoLayer.player
        }
        set {
            
            self._videoLayer.player = newValue
        }
    }
    
    internal var _playerItem:AVPlayerItem? {
        willSet{
            self.removePlayerObservers()
        }
        didSet{
            self.addPlayerObservers()
        }
    }
    internal let _playerRefreshCoverView = UIView(frame: .zero)
    
    internal let _activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
    
    internal var _assetLoader = VideoAssetLoder()
    
    public var isMuted:Bool {
        get {
            return self._player?.isMuted ?? false
        }
        set {
            self._player?.isMuted = newValue
        }
    }
    public var gravityMode : VideoViewGravityMode = .resizeAspect {
        didSet {
            switch gravityMode {
            case .resize:
                self._videoLayer.videoGravity = AVLayerVideoGravity(rawValue: "AVLayerVideoGravityResize")
            case .resizeAspect:
                self._videoLayer.videoGravity = AVLayerVideoGravity(rawValue: "AVLayerVideoGravityResizeAspect")
            case .resizeAspectFill:
                self._videoLayer.videoGravity = AVLayerVideoGravity(rawValue: "AVLayerVideoGravityResizeAspectFill")
            }
            
        }
    }
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
        
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
        _playerRefreshCoverView.backgroundColor = UIColor.black
        self.addSubview(_playerRefreshCoverView)
        self.addSubview(_activityIndicator)
        self._activityIndicator.isHidden = true
    }
    internal func commonInit(){
        self.layer.cornerRadius = 25.0
        _player = AVPlayer()
        self.clipsToBounds = true
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self._playerRefreshCoverView.frame = self.bounds
        self._activityIndicator.center = self.center
    }
}
extension UIVideoView {
    
    func load(_ url:URL) {
        self.refreshPlayer()
        self._assetLoader.load(url) { (playerItem, error) in
            if error == nil {
                self._playerItem = playerItem
                self._player?.replaceCurrentItem(with: playerItem)
            }
        }
    }
}

extension UIVideoView {
    func addPlayerObservers() {
        if let currentPlayerItem = self._playerItem {
            currentPlayerItem.safeAdd(observer: self, forKeyPath:  AVPlayerItemKVOKeys.status, options: [.new,.old], context: &playerItemObserverContext)
            currentPlayerItem.safeAdd(observer: self, forKeyPath: AVPlayerItemKVOKeys.playbackLikelyToKeepUp, options: [.new,.old], context: &playerItemObserverContext)
            currentPlayerItem.safeAdd(observer: self, forKeyPath: AVPlayerItemKVOKeys.playbackBufferEmpty, options: [.new,.old], context: &playerItemObserverContext)
            currentPlayerItem.safeAdd(observer: self, forKeyPath: AVPlayerItemKVOKeys.isPlaybackBufferFull, options: [.new,.old], context: &playerItemObserverContext)
            
        }
    }
    
    func removePlayerObservers() {
        if let currentPlayerItem = self._playerItem {
            currentPlayerItem.safeRemove(observer: self, forKeyPath: AVPlayerItemKVOKeys.status)
            currentPlayerItem.safeRemove(observer: self, forKeyPath: AVPlayerItemKVOKeys.playbackLikelyToKeepUp)
            currentPlayerItem.safeRemove(observer: self, forKeyPath: AVPlayerItemKVOKeys.playbackBufferEmpty)
            currentPlayerItem.safeRemove(observer: self, forKeyPath: AVPlayerItemKVOKeys.isPlaybackBufferFull)
            
        }
    }
}
// kvo observer.
extension UIVideoView {
    
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if context == &playerItemObserverContext {// KVO for playerItem
            guard let sender = object as? AVPlayerItem else {
                return
            }
            guard let currentItem = self._playerItem else {
                return
            }
            if sender !== currentItem {
                return
            }
            if keyPath == AVPlayerItemKVOKeys.status {
                let status: AVPlayerItemStatus
                if let statusNumber = change?[.newKey] as? NSNumber {
                    status = AVPlayerItemStatus(rawValue: statusNumber.intValue)!
                } else {
                    status = .unknown
                }
                self.playerItemStatusDidChanged(status)
            } else if keyPath == AVPlayerItemKVOKeys.playbackLikelyToKeepUp {
                self.playbackLikelyToKeepUpDidChanged()
            } else if keyPath == AVPlayerItemKVOKeys.playbackBufferEmpty {
                self.playbackBufferEmptyDidChanged()
            } else if keyPath == AVPlayerItemKVOKeys.isPlaybackBufferFull {
                self.isPlaybackBufferFullDidChanged()
            }
        }  else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    
    
    internal func playerItemStatusDidChanged(_ playerItemStatus:AVPlayerItemStatus) {
        
        switch playerItemStatus {
        case .readyToPlay:
            self.refreshingFinished()
        case .failed:
            print("playerItem status :- failed for ")
        case .unknown:
            print("playerItem status :- unknown ")
            
        }
    }
    
    internal func playbackLikelyToKeepUpDidChanged() {
        if let playerItem = self._playerItem {
            if playerItem.isPlaybackLikelyToKeepUp {
                
                self.hideIndicator()
            }
        }
    }
    
    internal func playbackBufferEmptyDidChanged() {
        if let playerItem = self._playerItem {
            if playerItem.isPlaybackBufferEmpty {
                self.showIndicator()
                
            }
        }
    }
    
    internal func isPlaybackBufferFullDidChanged() {
        if let playerItem = self._playerItem {
            if playerItem.isPlaybackBufferFull {
                self.hideIndicator()
                
            }
        }
    }
    
    
    
    
}
extension UIVideoView {
    func showIndicator() {
        DispatchQueue.main.async {
            self._activityIndicator.isHidden = false
            self._activityIndicator.startAnimating()
        }
        
    }
    func hideIndicator() {
        DispatchQueue.main.async {
            self._activityIndicator.stopAnimating()
            self._activityIndicator.isHidden = true
        }
    }
    func refreshingFinished() {
        DispatchQueue.main.async {
            self._playerRefreshCoverView.isHidden = true
        }
    }
    
    func refreshPlayer() {
        DispatchQueue.main.async {
            self.showIndicator()
            self._playerRefreshCoverView.isHidden = false
        }
        self._player?.pause()
        self.removePlayerObservers()
        self._player?.cancelPendingPrerolls()
    }
}
extension UIVideoView {
    func play() {
        self._player?.play()
    }
    func pause() {
        self._player?.pause()
    }
}


