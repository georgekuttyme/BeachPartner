//
//  CardView.swift
//  JerryCardView
//
//  Created by Midhun P Mathew on 3/29/18.
//  Copyright © 2018 Midhun P Mathew. All rights reserved.
//

import UIKit
import SDWebImage
class CardView: UIView {
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
        self.nameLabel.text = data.firstName + "," + " " + String(data.age )
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
        let ageValue = getAgeValue(dob: data.doblong)
        self.nameLabel.text = data.firstName  + "," + " " + "\(ageValue)"
        self.placeLabel?.text = data.userType
        
    }
    
    func showVideo() {
        self.imageView.isHidden = true
        self.videoDisplayView.isHidden = false
        self.videoView?.play()
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
    
}







