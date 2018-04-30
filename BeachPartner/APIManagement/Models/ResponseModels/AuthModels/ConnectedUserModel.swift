
import Foundation
import Tailor

struct ConnectedUserModelArray: SafeMappable {
    
    var connectedUserModel = [ConnectedUserModel]()
    
    init(_ map: [String : Any]) throws {
        
    }
    
    init(_ map: NSArray) throws {
        for model in map {
            
            do {
                let respModel = try ConnectedUserModel(model as! [String : Any])
                connectedUserModel.append(respModel)
            } catch {
                print(error)
            }
        }
    }
}

struct ConnectedUserModel:SafeMappable {
    
    
    var status: String = ""
    
    var id: Int = 0
    var connectedUser: ConnectedUser?
    
    init(_ map: [String : Any]) throws {
        
        status <- map.property("status")
        
        id  <- map.property("id")
        connectedUser = map.relation("connectedUser")
        
    }
    
    struct ConnectedUser:SafeMappable {
        
        var activated: Int = 0
        var authToken: Int = 0
        var city: String = ""
        var age: Int = 0
        var createdDate: String = ""
        var deviceId: String = ""
        var email: String = ""
        var firstName: String = ""
        var gender: String = ""
        var imageUrl: String = ""
        var langKey: String = ""
        var lastModifiedDate: String = ""
        var lastName: String = ""
        var location: String = ""
        var login: String = ""
        var loginType: String = ""
        var phoneNumber: String = ""
        var videoUrl: String = ""
        var userId: Int = 0
        var userType: String = ""
        var isBlocked: Bool = false
        
        init() {
            
        }
        
        init(_ map: [String : Any]) throws {
            
            activated <- map.property("activated")
            age <- map.property("age")
            authToken  <- map.property("authToken")
            city <- map.property("city")
            createdDate <- map.property("createdDate")
            deviceId  <- map.property("deviceId")
            email <- map.property("email")
            
            firstName <- map.property("firstName")
            imageUrl <- map.property("imageUrl")
            
            langKey <- map.property("langKey")
            lastModifiedDate  <- map.property("lastModifiedDate")
            lastName <- map.property("lastName")
            
            location <- map.property("location")
            login  <- map.property("login")
            loginType <- map.property("loginType")
            
            phoneNumber <- map.property("phoneNumber")
            videoUrl <- map.property("videoUrl")
            userId  <- map.property("id")
            userType <- map.property("userType")
        }
    }
}





