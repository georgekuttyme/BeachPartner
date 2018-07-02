//
//  UITextField+Empty.swift
//  BeachPartner
//
//  Created by Beach Partner LLC on 26/03/18.
//  Copyright © 2018 Beach Partner LLC. All rights reserved.
//

import Foundation
import UIKit
extension UITextField {
    
    func isEmpty() -> Bool {
        guard let text = self.text else{
            return false
        }
        
        return text.isEmpty
    }
    func getText() -> String {
        guard let text = self.text else{
            return ""
        }
        
        return text
    }
    
    func lengthExceeds(maxLength:Int,range:NSRange,string:String) -> Bool{
        let currentCharacterCount = self.text?.characters.count ?? 0
        if (range.length + range.location > currentCharacterCount){
            return false
        }
        let newLength = currentCharacterCount + string.characters.count - range.length
        return newLength <= maxLength
    }
}
extension UITextView {
    
    func isEmpty() -> Bool {
        guard let text = self.text else{
            return false
        }
        
        return text.isEmpty
    }
    func getText() -> String {
        guard let text = self.text else{
            return ""
        }
        
        return text
    }
    
    
}


