//
//  AppColors.swift
//  BeachPartner
//
//  Created by Georgekutty on 22/07/18.
//  Copyright © 2018 Beach Partner LLC. All rights reserved.
//

import Foundation
import UIKit

extension UIColor
{
    open class var navigationBarTintColor:UIColor
    {
      //  return UIColor.red
        return  UIColor(red: 41/255.0, green: 56/255.0, blue: 133/255.0, alpha:1.0)
    }
    
    open class var statusBarTintColor:UIColor
    {
        return  UIColor(red: 32.0/255.0, green: 48.0/255.0, blue: 127.0/255.0, alpha: 1.0)
    }
    
    open class var blackColorWithoutAlfa:UIColor
    {
        return  UIColor(red: 0, green: 0, blue: 0, alpha: 0)
    }
    
    open class var blackColorWithAlfaMin:UIColor
    {
        return  UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
    }
    
    open class var blackColor:UIColor
    {
        return  UIColor.black
    }
    
    open class var whiteColor:UIColor
    {
        return  UIColor.white
    }
    
    open class var clearColor:UIColor
    {
        return  UIColor.white
    }
}

