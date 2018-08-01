//
//  String+Validation.swift
//  BeachPartner
//
//  Created by Beach Partner LLC on 26/03/18.
//  Copyright © 2018 Beach Partner LLC. All rights reserved.
//

import Foundation

import libPhoneNumber_iOS
extension String {
    func isValidEmailAddress() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
//    ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.+-]+\.edu$
    func isValid() -> Bool {
        let emailRegEx = "[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.+-]+\\.edu"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
        func isValidName() -> Bool {
            // here, `try!` will always succeed because the pattern is valid
            let regex = try! NSRegularExpression(pattern: "[A-Za-z]", options: .caseInsensitive)
            return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
        }

    func isValidPhoneNumber(_ countryCode:String)->Bool{
        let phoneUtil = NBPhoneNumberUtil()
        do {
            let phoneNumber: NBPhoneNumber = try phoneUtil.parse(self, defaultRegion: countryCode)
            if phoneUtil.isValidNumber(phoneNumber) {
                return true
            }else{
                return false
            }
        }catch let error as NSError {
            print(error)
            return false
        }
        
    }
    func extractRegionCodeAndPhoneNumber() -> String {
        let phoneUtil = NBPhoneNumberUtil()
        guard let number = Int(self) else{
            return ""
        }
        let nsNumber = NSNumber(value: number as Int)
        let regionCode = phoneUtil.getRegionCode(forCountryCode: nsNumber)
        return regionCode!
    }
    func extractCountryCodeAndPhoneNumber() -> (coutryCode:String,phoneNumber:String) {
        let phoneUtil = NBPhoneNumberUtil()
        var phoneNumber:NSString?
        let code = phoneUtil.extractCountryCode(self, nationalNumber: &phoneNumber) ?? NSNumber(value: 0 as Int)
        guard let phoneNumberString = phoneNumber as? String else {
            return (code.stringValue,"")
        }
        return (code.stringValue,phoneNumberString)
    }
    
    func fillWithEmptyString() -> String {
        if self.characters.count > 0 {
            return self
        }else{
            return "Not Available"
        }
    }
    func fillWithEmptyCharecter() -> String {
        if self.characters.count > 0 {
            return self
        }else{
            return "***********"
        }
    }
    
}

