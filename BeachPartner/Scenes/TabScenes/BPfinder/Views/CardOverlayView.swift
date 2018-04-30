//
//  CustomOverlayView.swift
//  Koloda
//
//  Created by Eugene Andreyev on 7/27/15.
//  Copyright (c) 2015 CocoaPods. All rights reserved.
//

import UIKit
import Koloda

private let overlayRightImageName = "yesOverlayImage"
private let overlayLeftImageName = "noOverlayImage"
private let overlayTopImageName = "overlay_hi"

class CardOverlayView: OverlayView {
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
        
    }
    internal func commonInit(){
        self.layer.cornerRadius = 25.0
        
        self.clipsToBounds = true
    }
    
    @IBOutlet lazy var overlayImageView: UIImageView! = {
        [unowned self] in
        
        var imageView = UIImageView(frame: self.bounds)
        imageView.clipsToBounds = true
        self.addSubview(imageView)
        
        return imageView
        }()
    
    override var overlayState: SwipeResultDirection?  {
        didSet {
            switch overlayState {
            case .left? :
                overlayImageView.image = UIImage(named: overlayLeftImageName)
            case .right? :
                overlayImageView.image = UIImage(named: overlayRightImageName)
            case .up? :
                overlayImageView.image = UIImage(named: overlayTopImageName)
            default:
                overlayImageView.image = nil
            }
            
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        overlayImageView.frame = self.bounds
    }
}
