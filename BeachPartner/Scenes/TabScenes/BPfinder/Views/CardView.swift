//
//  CardView.swift
//  JerryCardView
//
//  Created by Beach Partner LLC on 3/29/18.
//  Copyright © 2018 Beach Partner LLC. All rights reserved.
//

import UIKit
import SDWebImage
class CardView: UIView {
    @IBOutlet weak var toastLabel: UILabel!
    @IBOutlet weak var muteButton: UIButton!
     @IBOutlet weak var moveDown: UIButton!
    
    weak var videoView:UIVideoView? {
        
        willSet{
            if let view = self.videoView {
                view.removeFromSuperview()
            }
        }
        
        didSet{
            if let view = self.videoView {
                self.videoDisplayView.addSubview(view)
                view.sizeToFitByAutoresizing(toView: self.videoDisplayView)
                
                self.videoDisplayView.bringSubview(toFront: self.muteButton)
               
                view.isMuted = false
                self.muteButton.isHidden = true
                self.muteButton.isUserInteractionEnabled = false
                if view.isMuted {
                    
                    self.muteButton.isSelected = true
                } else {
                    
                    self.muteButton.isSelected = false
                }
            }
        }
    }
    @IBOutlet weak var videoDisplayView: UIView!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
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
        self.backgroundColor = UIColor.gray
        
        self.clipsToBounds = true
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        toastLabel.isHidden = true
        // border radius
        
        self.layer.cornerRadius = 25.0
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 1.5
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        self.layer.shadowOpacity = 0.8
        self.layer.shadowRadius = 3.0
        
        
    }
    @IBAction func muteButtonCliked(_ sender: UIButton) {
        if let videoView =  self.videoView {
            if videoView.isMuted {
                videoView.isMuted = false
                sender.isSelected = false
            } else {
                videoView.isMuted = true
                sender.isSelected = true
            }
        }
    }
}

extension CardView {
    
    func displayDataOnCard(displayData data:ConnectedUserModel.ConnectedUser) {
        
        if let imageUrl = URL(string: data.imageUrl) {
            self.imageView.sd_setIndicatorStyle(.whiteLarge)
            self.imageView.sd_setShowActivityIndicatorView(true)
            self.imageView.sd_setImage(with: imageUrl, placeholderImage: #imageLiteral(resourceName: "user"))
        }
         self.muteButton.isHidden = true
        self.nameLabel.text = data.firstName + " " + data.lastName  + "," + " " + String(data.age )
        self.placeLabel?.text = data.userType
    }
    
    func displaySubscribeDataOnCard(displayData data:SubscriptionUserModel.SubscribedUser) {

        if let imageUrl = URL(string: data.imageUrl) {
            self.imageView.sd_setIndicatorStyle(.whiteLarge)
            self.imageView.sd_setShowActivityIndicatorView(true)
            self.imageView.sd_setImage(with: imageUrl, placeholderImage: #imageLiteral(resourceName: "user"))
        }
         self.muteButton.isHidden = true
        self.nameLabel.text = data.firstName //+ "," + " " + String(data.age ?? 0)
        self.placeLabel?.text = data.userType
    }
    
    func displaySearchDetailsOnCard(displayData data:SearchUserModel) {
        
        if let imageUrl = URL(string: data.imageUrl) {
            self.imageView.sd_setIndicatorStyle(.whiteLarge)
            self.imageView.sd_setShowActivityIndicatorView(true)
            self.imageView.sd_setImage(with: imageUrl, placeholderImage: #imageLiteral(resourceName: "user"))
        }
        self.muteButton.isHidden = true
//        let ageValue = getAgeValue(dob: data.doblong)
        let ageValue = data.age
        self.nameLabel.text = data.firstName + " " + data.lastName + "," + " " + "\(ageValue)"
        self.placeLabel?.text = data.userType
        
    }
    
    func showVideo() {
        toastLabel.isHidden = true
        self.imageView.isHidden = true
        self.videoDisplayView.isHidden = false
        self.videoView?.play()
    }
    func pauseVideo(){
        toastLabel.isHidden = true
        self.imageView.isHidden = false
        self.videoDisplayView.isHidden = true
        self.videoView?.pause()
    }
    
    func hideVideo() {
        self.imageView.isHidden = false
        self.videoDisplayView.isHidden = true
    }
    
    func getAgeValue(dob:Double) -> String
    {
        let date = Date(timeIntervalSince1970: TimeInterval(dob/1000))
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dayTimePeriodFormatter.string(from: date as Date)
        let originDate = dayTimePeriodFormatter.date(from: dateString)
        let calendar: NSCalendar! = NSCalendar(calendarIdentifier: .gregorian)
        let now = Date()
        let calcYrDiff = calendar.components(.year, from: originDate!, to: now, options: [])
        let yrDifference = calcYrDiff.year
        return String(yrDifference ?? 0)
    }
    func showLabel(){
        toastLabel.isHidden = false
        self.toastLabel.alpha = 1.0
        self.toastLabel.isHidden = false
        self.toastLabel.text = "No video available for this profile"
        self.toastLabel.textColor = UIColor.white
        toastLabel.layer.shadowColor = UIColor.gray.cgColor
        toastLabel.layer.shadowOpacity = 1.0
        toastLabel.layer.shadowRadius = 3.0
        toastLabel.layer.shadowOffset = CGSize(width: 4, height: 4)
        toastLabel.layer.masksToBounds = false
    }
    
}







