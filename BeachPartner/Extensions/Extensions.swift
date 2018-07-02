//
//  File.swift
//  JerryCardView
//
//  Created by Beach Partner LLCon 3/29/18.
//  Copyright © 2018 Beach Partner LLC. All rights reserved.
//

import Foundation
import UIKit
extension UIView {
    public class func instantiateFromNib<T: UIView>(viewType: T.Type) -> T {
        let bundle =  Bundle(for: viewType)
        return bundle.loadNibNamed(String(describing: viewType), owner: nil, options: nil)!.first as! T
    }
    
    public class func instantiateFromNib() -> Self {
        return instantiateFromNib(viewType: self)
    }
    public func sizeToFitByAutoresizing(toView view:UIView) {
        self.frame = view.bounds
        self.translatesAutoresizingMaskIntoConstraints = true
        self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
}

