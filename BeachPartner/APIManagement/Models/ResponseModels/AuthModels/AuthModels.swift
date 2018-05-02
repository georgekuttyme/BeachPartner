//
//  AuthModels.swift
//  BeachPartner
//
//  Created by Jerry K Mathew on 26/03/18.
//  Copyright © 2018 dev. All rights reserved.
//

import Foundation
import Tailor

struct LoginRespModel:SafeMappable {

     var idToken: String = ""
    var details: String = ""
    init(_ map: [String : Any]) throws {
        //        print("mapp :",map)
        

        idToken  <- map.property("idToken")
        details  <- map.property("detail")
        
    }
}
struct LoginModel:SafeMappable {
    
    //   let result: ServiceResult
    //    let result: ServiceResult
   
    let response: ResponseDataModel?
    
    
    init(_ map: [String : Any]) throws {
        //        print("mapp :",map)
        
        response = map.relation("response")
        
    }
}




struct ResponseDataModel : SafeMappable{
    
    var success: Int = 0
    var message: String = ""
    var userinfoS: String?
    var exceptionId = 0
    
    
    let userinfo : UserInfoDataModel?
    
    //    print("userInfoo :", userinfo )
    
    init(_ map: [String : Any])throws {
        success <- map.property("success")
        message  <- map.property("message")
        exceptionId <- map.property("exceptionId")
        
        userinfoS <- map.property("userinfo")
        
        if(userinfoS != nil){
            userinfo = try UserInfoDataModel(convertToDictionary(text: userinfoS!)!)
            print("useribfoo :", userinfo!)
            
        }else{
            userinfo = nil
        }
        //        print("map :", map)
        //
        //
        //        print("userInfoo :", userinfo?.emailId )
        //        print("success :", success)
        
        
    }
    
}


struct UserInfoDataModel : SafeMappable {
    
    
    var firstName: String = ""
    var middleName: String = ""
    var lastName: String = ""
    var emailId: String = ""
    var phoneNumber: String = ""
    
    
    init(_ map: [String : Any])throws {
        firstName <- map.property("firstName")
        middleName <- map.property("middleName")
        lastName <- map.property("lastName")
        emailId <- map.property("emailId")
        phoneNumber <- map.property("phoneNumber")
        
        print("emailll", emailId)
    }
}






struct findByIdModel:SafeMappable {
    
    
    let response: FindResponseDataModel?
    
    
    init(_ map: [String : Any]) throws {
        //        print("mapp :",map)
        
        response = map.relation("response")
        
    }
}


struct FindResponseDataModel : SafeMappable{
    
    var success: Int = 0
    var message: String = ""
    var data = DataModelSingx()
    var exceptionId = 0
    
    
    //    print("userInfoo :", userinfo )
    
    init(_ map: [String : Any])throws {
        success <- map.property("success")
        message  <- map.property("message")
        exceptionId <- map.property("exceptionId")
        
        //        data = map.relation("data")
        if map["data"] != nil {
            data = map.relation("data")!
        }
        
        //        print("mapp :", map)
        //
        //        print("datapp :", data)
        //        print("success :", success)
        //        print("message :", message)
    }
    
    
    
    
}


struct DataModelSingx : SafeMappable {
    
    
    var customerTypeName: String = ""
    var primaryKey: String = ""
    var customerTypeId: String = ""
    var versionId: Int = 0
    var primaryDisplay: String = ""
    var contactId: String = ""
    var customerId: String = ""
    var countryId: String = ""
    var systemInfo = SystemInfoModel()
    
    init() {
        
    }
    
    init(_ map: [String : Any])throws {
        customerTypeName <- map.property("customerTypeName")
        primaryKey <- map.property("primaryKey")
        customerTypeId <- map.property("customerTypeId")
        versionId <- map.property("versionId")
        primaryDisplay <- map.property("primaryDisplay")
        contactId <- map.property("contactId")
        customerId <- map.property("customerId")
        countryId <- map.property("countryId")
        systemInfo = map.relation("systemInfo")!
        //        print("systemInfo :",systemInfo!)
        
    }
    
}

struct SystemInfoModel : SafeMappable {
    
    
    var activeStatus: Int = 0
    var txnAccessCode: CLong = 0
    
    init() {
    }
    
    init(_ map: [String : Any])throws {
        activeStatus <- map.property("activeStatus")
        txnAccessCode <- map.property("txnAccessCode")
        
        //        print("txnAccessCode @@:",txnAccessCode)
        //        print("activeStatus @@:",activeStatus)
        
    }
}



//================================================

struct indivProfRspModel:SafeMappable {
    
    
    let response: indivProfStatusDataModel?
    
    
    init(_ map: [String : Any]) throws {
        //        print("mapp :",map)
        
        response = map.relation("response")
        
    }
}

struct indivProfStatusDataModel : SafeMappable{
    
    var success: Int = 0
    var message: String = ""
    var exceptionId = 0
    
    var profdata = [ProfDataModel]()
    
    //    let profdata : ProfDataModel?
    
    
    init(_ map: [String : Any])throws {
        success <- map.property("success")
        message  <- map.property("message")
        exceptionId <- map.property("exceptionId")
        
        profdata <- map.relations("data")
        
        //        print("mapp :", map)
        //
        //        print("datapp :", data)
        //        print("success :", success)
        print("profdataaa :", profdata)
    }
    
    
    
    
}


struct ProfDataModel : SafeMappable {
    
    
    var profileStatus:Int = 0
    
    init(_ map: [String : Any])throws {
        profileStatus <- map.property("profileStatus")
        
        print("profileStatus :",profileStatus)
        
    }
    
}


//==================================================

func convertToDictionary(text: String) -> [String: Any]? {
    if let data = text.data(using: .utf8) {
        do {
            return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        } catch {
            print(error.localizedDescription)
        }
    }
    return nil
}

