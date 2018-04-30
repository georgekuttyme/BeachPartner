//
//  UIView+IBInspectable.swift
//  BeachPartner
//
//  Created by Jerry K Mathew on 28/03/18.
//  Copyright © 2018 dev. All rights reserved.
//
import Foundation
import UIKit
extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
}
extension UIView {
    class func loadNib(name: String, bundle : Bundle? = nil) -> UIView? {
        return UINib(
            nibName: name,
            bundle: bundle
            ).instantiate(withOwner: nil, options: nil)[0] as? UIView
    }
}

