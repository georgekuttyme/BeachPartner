//
//  AuthModules.swift
//  BeachPartner
//
//  Created by Jerry K Mathew on 26/03/18.
//  Copyright © 2018 dev. All rights reserved.
//

import UIKit

extension APIManager{
    
    // MARK: - Login service
    // This service is used for both teacher and student login.
    
    /// Send a post request to server in which parameters will send in rquest boady
    ///
    /// - parameter email: The registerd email address of user.
    /// - parameter password: The password of user.
    /// - paramevarvar sucessResult: The parsed response (invoke when parsing sucessfuly complete).
    /// - parameter errorResult:  The error (invoke when an error occuars). "deviceId": "string",
//    "deviceToken": "string",
//    "fcmToken": "string",
    ///
    public func forInstaLogin(sucessResult:@escaping resultClosure,errorResult:@escaping errorClosure){
        let fcmToken = UserDefaults.standard.string(forKey: "FCM_TOKEN")
        let instaToken = UserDefaults.standard.string(forKey: "INSTATOKEN")
        print("fcm Token--->",fcmToken ?? "")
        let params = [
            "deviceId": "",
            "deviceToken": instaToken,
            "fcmToken": fcmToken,
            "password": "",
            "rememberMe": "",
            "username": ""
            ]
        
        APIClient.doRequest.inPost(method:ApiMethods.Login, params: params as! [String : String], sucess: { (response) in
            
            //            APIManager.printOnDebug(response: "\(response)")
            
            
            let jsonDict = response! as! JSONDictionary
            
            do {
                
                let loginModel = try LoginRespModel(jsonDict)
                sucessResult(loginModel)
                return
            } catch {
                print("Catched")
                errorResult(error.localizedDescription)
                APIManager.printOnDebug(response: "error:\(error.localizedDescription)")
                return
            }
            
        }) { (error) in
            self.busyOff()
            errorResult(error?.localizedDescription)
            APIManager.printOnDebug(response: "error:\(error?.localizedDescription)")
            return
        }
    }
    
    public func forFbLogin(sucessResult:@escaping resultClosure,errorResult:@escaping errorClosure){
        
        let device_UUID = UIDevice.current.identifierForVendor!.uuidString
        let token = UserDefaults.standard.string(forKey: "bP_token")
        let fcmToken = UserDefaults.standard.string(forKey: "FCM_TOKEN")
        let fbToken = UserDefaults.standard.string(forKey: "FBTOKEN")
        
        print("fcm Token--->",fcmToken ?? "")
        print("fcm Token--->",fbToken ?? "")
        print("fcm Token--->",token ?? "")
        print("fcm Token--->",device_UUID ?? "")
        
        let params = [
            "authToken":fbToken ?? "",
            "deviceId":device_UUID,
            "deviceToken":"",
            "fcmToken": fcmToken ?? "",
            "loginType": "FB",
            "rememberMe": "true",
            ]
        print(params)
        APIClient.doRequest.inPost(method:ApiMethods.LoginFb, params: params as! [String : String], sucess: { (response) in
            
            //            APIManager.printOnDebug(response: "\(response)")
            
            
            let jsonDict = response! as! JSONDictionary
            
            do {
                
                let loginModel = try LoginRespModel(jsonDict)
                sucessResult(loginModel)
                return
            } catch {
                print("Catched")
                errorResult(error.localizedDescription)
                APIManager.printOnDebug(response: "error:\(error.localizedDescription)")
                return
            }
            
        }) { (error) in
            self.busyOff()
            errorResult(error?.localizedDescription)
            APIManager.printOnDebug(response: "error:\(error?.localizedDescription)")
            return
        }
    }
    
    
    public func forLogin(email:String, password:String, rememberMe:String, sucessResult:@escaping resultClosure,errorResult:@escaping errorClosure){
        let fcmToken = UserDefaults.standard.string(forKey: "FCM_TOKEN")
        
        print("fcm Token--->",fcmToken ?? "")
        let params = [
            "username":email,
            "password":password,
            "rememberMe":rememberMe,
            "deviceId": ApiMethods.device_UUID,
            "deviceToken": "",
            "fcmToken": fcmToken,
            "deviceType": "iOS"
        ]

        APIClient.doRequest.inPost(method:ApiMethods.Login, params: params as! [String : String], sucess: { (response) in
            
            //            APIManager.printOnDebug(response: "\(response)")
            
            
            let jsonDict = response! as! JSONDictionary
            
            do {
                
                let loginModel = try LoginRespModel(jsonDict)
                sucessResult(loginModel)
                return
            } catch {
                print("Catched")
                errorResult(error.localizedDescription)
                APIManager.printOnDebug(response: "error:\(error.localizedDescription)")
                return
            }
            
        }) { (error) in
            self.busyOff()
            errorResult(error?.localizedDescription)
            APIManager.printOnDebug(response: "error:\(error?.localizedDescription)")
            return
        }
    }
    
    public func forRegistration(email:String, password:String, location:String, deviceId:String, dob:String, firstName:String, gender:String, lastName:String, mobileNo:String, userType:String, sucessResult:@escaping resultClosure,errorResult:@escaping errorClosure){
        let params = [
            "authToken":"null",
            "city":location,
            "deviceId":deviceId,
            "dob":dob,
            "email":email,
            "firstName":firstName,
            "gender":gender,
            "imageUrl":"null",
            "langKey":"null",
            "lastName":lastName,
            "location":location,
            "login":email,
            "loginType":"BP",
            "password":password,
            "phoneNumber":mobileNo,
            "userType":userType,
            ]
        
        APIClient.doRequest.inPost(method:ApiMethods.Registation, params: params, sucess: { (response) in
            
            //            APIManager.printOnDebug(response: "\(response)")
            
            
            let jsonDict = response! as! JSONDictionary

            do {
                if let status = jsonDict["status"] as? Int {
                    
                    if status != 201 {
                        let message = jsonDict["title"] as! String
                        errorResult(message)
                    }
                    else {
                        let loginModel = try LoginRespModel(jsonDict)
                        sucessResult(loginModel)
                    }
                }
                else {
                    let loginModel = try LoginRespModel(jsonDict)
                    sucessResult(loginModel)
                }
                
                return
            } catch {
                print("Catched")
                errorResult(error.localizedDescription)
                APIManager.printOnDebug(response: "error:\(error.localizedDescription)")
                return
            }
            
        }) { (error) in
            self.busyOff()
            errorResult(error?.localizedDescription)
            APIManager.printOnDebug(response: "error:\(error?.localizedDescription)")
            return
        }
    }
    
    
    

    public func getAccountDetails( sucessResult:@escaping resultClosure,errorResult:@escaping errorClosure){
        let params = [String:String]()
        
        APIGetClient.doGetRequest.inGet(method:ApiMethods.GetAccountDetails, params: params, sucess: { (response) in
            
                        APIManager.printOnDebug(response: "\(response)")
            let jsonDict = response! as! JSONDictionary
            
            do {
                
                let accRespModel = try AccountRespModel(jsonDict)
                sucessResult(accRespModel)
                return
            } catch {
                print("Catched")
                errorResult(error.localizedDescription)
                APIManager.printOnDebug(response: "error:\(error.localizedDescription)")
                return
            }
            
        }) { (error) in
            self.busyOff()
            errorResult(error?.localizedDescription)
            APIManager.printOnDebug(response: "error:\(error?.localizedDescription)")
            return
        }
    }
    public func updateUserDetails(userData:AccountRespModel, sucessResult:@escaping resultClosure,errorResult:@escaping errorClosure){
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        let showDate = inputFormatter.date(from:userData.inputDob)
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z"
        let resultString = inputFormatter.string(from: showDate!)
        
        let fcmToken = UserDefaults.standard.string(forKey: "FCM_TOKEN")
        
        let userProfile :[String:String] = [
                                            "cbvaFirstName": ((userData.userProfile?.cbvaFirstName) ?? "")!,
                                             "cbvaLastName": ((userData.userProfile?.cbvaLastName) ?? "")!,
                                             "cbvaPlayerNumber": ((userData.userProfile?.cbvaPlayerNumber) ?? "")!,
                                             "collage": ((userData.userProfile?.collage) ?? "")!,
                                             "collageClub": ((userData.userProfile?.collageClub) ?? "")!,
                                             "collegeBeach": ((userData.userProfile?.collegeBeach) ?? "")!,
                                             "collegeIndoor": ((userData.userProfile?.collegeIndoor) ?? "")!,
                                             "courtSidePreference": ((userData.userProfile?.courtSidePreference) ?? "")!,
                                             "description": ((userData.userProfile?.description) ?? "")!,
                                             "division": ((userData.userProfile?.division) ?? "")!,
                                             "experience": ((userData.userProfile?.experience) ?? "")!,
                                             "fundingStatus": ((userData.userProfile?.fundingStatus) ?? "")!,
                                             "height": ((userData.userProfile?.height) ?? "")!,
                                             "highSchoolAttended": ((userData.userProfile?.highSchoolAttended) ?? "")!,
                                             "highestTourRatingEarned": ((userData.userProfile?.highestTourRatingEarned) ?? "")!,
                                             "indoorClubPlayed": ((userData.userProfile?.indoorClubPlayed) ?? "")!,
                                             "numOfAthlets": ((userData.userProfile?.numOfAthlets) ?? "")!,
                                             "position": ((userData.userProfile?.position) ?? "")!,
                                             "programsOffered": ((userData.userProfile?.programsOffered) ?? "")!,
                                             "shareAthlets": ((userData.userProfile?.shareAthlets) ?? "")!,
                                             "topFinishes": ((userData.userProfile?.topFinishes) ?? "")!,
                                             "totalPoints": ((userData.userProfile?.totalPoints ) ?? "")!,
                                             "tournamentLevelInterest": ((userData.userProfile?.tournamentLevelInterest) ?? "")!,
                                             "toursPlayedIn": ((userData.userProfile?.toursPlayedIn) ?? "")!,
                                             "usaVolleyballRanking": ((userData.userProfile?.usaVolleyballRanking) ?? "")!,
                                             "willingToTravel": ((userData.userProfile?.willingToTravel) ?? "")!,
                                             "yearsRunning": ((userData.userProfile?.yearsRunning) ?? "")!
        ]
        
        let params: [String: [String:String]] = [
            "userInputDto": [
                "authToken": userData.authToken,
                "city": userData.city,
//                "deviceId": userData.deviceId,
                "dob": resultString,
//                "email": userData.email,
//                "fcmToken": fcmToken ?? "",
                "firstName": userData.firstName,
                "gender": userData.gender,
                "imageUrl": userData.imageUrl,
//                "langKey": userData.langKey,
                "lastName": userData.lastName,
                "location": userData.location,
                "phoneNumber": userData.phoneNumber,
                "userType": userData.userType,
//                "videoUrl": "",
                "parentUserId": ""
            ],
            "userProfileDto": userProfile
        ]
        
        
        let userId = UserDefaults.standard.string(forKey: "bP_userId") ?? ""
        let trimmeduserId = userId.trimmingCharacters(in: .whitespaces)
                
            APIClient.doRequest.inPutWithJsonData(method:ApiMethods.updateAllUserDetails  + "/\(trimmeduserId)" , params: params, sucess: { (response) in
            self.busyOff()
            
            //            APIManager.printOnDebug(response: "\(response)")
            
            
            let jsonDict = response! as! JSONDictionary
            
            do {
                
                let loginModel = try AccountRespModel(jsonDict)
                sucessResult(loginModel)
                return
            } catch {
                errorResult(error.localizedDescription)
                APIManager.printOnDebug(response: "error:\(error.localizedDescription)")
                return
            }
            

            
        }) { (error) in
            self.busyOff()
            errorResult(error?.localizedDescription)
            APIManager.printOnDebug(response: "error:\(error?.localizedDescription)")
            return
        }
    }
    
    func updateAtheleteProfilePicAndVideo(userimage:UIImage, videoData:NSData, sucessResult:@escaping resultClosure,errorResult:@escaping errorClosure){
        
        let userId = UserDefaults.standard.string(forKey: "bP_userId") ?? ""
        
        let params = ["userId":userId]
        
        busyOn()
        APIClient.doRequest.inPostForImageUpload(method:ApiMethods.AddProfileVideoImage, params: params, image: userimage, videoDataVal: videoData, sucess: { (response) in
            self.busyOff()
            APIManager.printOnDebug(response: "\(response)")
            
            if(response != nil){
                let jsonDict = response! as! JSONDictionary
                do {
                    let accountRespModel = try UpdateProfileImageVideoModel(jsonDict)
                    sucessResult(accountRespModel)
                    return
                } catch {
                    errorResult(error.localizedDescription)
                    APIManager.printOnDebug(response: "error:\(error.localizedDescription)")
                    return
                }
            }
            
        }) { (error) in
            self.busyOff()
            errorResult(error?.localizedDescription)
            APIManager.printOnDebug(response: "error:\(error?.localizedDescription)")
            return
        }
        
    }
    
 /*   func updateAtheleteProfilePic(userimage:UIImage, sucessResult:@escaping resultClosure,errorResult:@escaping errorClosure){
        
        let userId = UserDefaults.standard.string(forKey: "bP_userId") ?? ""
        
        let params = ["userId":userId]
        
        busyOn()
        APIClient.doRequest.inPostForImageUpload(method:ApiMethods.AddProfileVideoImage, params: params, image: userimage, videoDataVal: videoData, sucess: { (response) in
            self.busyOff()
            APIManager.printOnDebug(response: "\(response)")
            
            if(response != nil){
                let jsonDict = response! as! JSONDictionary
                do {
                    let accountRespModel = try UpdateProfileImageVideoModel(jsonDict)
                    sucessResult(accountRespModel)
                    return
                } catch {
                    errorResult(error.localizedDescription)
                    APIManager.printOnDebug(response: "error:\(error.localizedDescription)")
                    return
                }
            }
            
        }) { (error) in
            self.busyOff()
            errorResult(error?.localizedDescription)
            APIManager.printOnDebug(response: "error:\(error?.localizedDescription)")
            return
        }
        
    }

 */
    
    
    public func getUserConnectionList(status:String, sucessResult:@escaping resultClosure,errorResult:@escaping errorClosure){
        let params = [String:String]()
        
        let userId = UserDefaults.standard.string(forKey: "bP_userId") ?? ""
        let trimmeduserId = userId.trimmingCharacters(in: .whitespaces)
        APIGetClient.doGetRequest.inGetReqForArray(method:ApiMethods.GetAllConnections + "/\(trimmeduserId)"+"?\(status)"  , params: params, sucess: { (response) in
            
            APIManager.printOnDebug(response: " Resppp : \(response)")
            
            print(" Resppp :", response)
            
            let jsonDict = response! as! NSArray
            
            do {
                
                let connUserModel = try ConnectedUserModelArray(jsonDict)
                sucessResult(connUserModel)
                return
            } catch {
                print("Catched")
                errorResult(error.localizedDescription)
                APIManager.printOnDebug(response: "error:\(error.localizedDescription)")
                return
            }
            
        }) { (error) in
            self.busyOff()
            errorResult(error?.localizedDescription)
            APIManager.printOnDebug(response: "error:\(error?.localizedDescription)")
            return
        }
    }
    
    public func getUsersConnectionCount(status:String, sucessResult:@escaping resultClosure,errorResult:@escaping errorClosure){
        let params = [String:String]()
        let userId = UserDefaults.standard.string(forKey: "bP_userId") ?? ""
        let trimmeduserId = userId.trimmingCharacters(in: .whitespaces)
        
        APIGetClient.doGetRequest.inGet(method:ApiMethods.GetConnectedusersCount + "/\(trimmeduserId)"+"?\(status)"  , params: params, sucess: { (response) in
            
            APIManager.printOnDebug(response: " Resppp : \(response)")
            
            print(" Resppp :", response)
            
            let jsonDict = response! as! JSONDictionary
            
            do {
                let connUserModel = try ConnectedUsersCountModel(jsonDict)
                sucessResult(connUserModel)
                return
            } catch {
                print("Catched")
                errorResult(error.localizedDescription)
                APIManager.printOnDebug(response: "error:\(error.localizedDescription)")
                return
            }
            
        }) { (error) in
            self.busyOff()
            errorResult(error?.localizedDescription)
            APIManager.printOnDebug(response: "error:\(error?.localizedDescription)")
            return
        }
    }
    
    
    
    public func getUserConnections( sucessResult:@escaping sucessClosureOfArray, errorResult:@escaping errorClosure){
        let params = [String:String]()
        
         let userId = UserDefaults.standard.string(forKey: "bP_userId") ?? ""
        let trimmeduserId = userId.trimmingCharacters(in: .whitespaces)
        
        APIGetClient.doGetRequest.inGetReqForArray(method:ApiMethods.GetAllConnections + "/\(trimmeduserId)" , params: params, sucess: { (response) in
            
            APIManager.printOnDebug(response: "\(response)")
            
//            var taskArray = [String]()
//            if let array = response as? [[String: Any]] {
//
//                 taskArray = array.flatMap { $0["connectedUser"] as? String }
//
//            }
//            let newDict = JSONDictionary

//            let jsonDict = response! as! JSONDictionary
//
//            let data = NSJSONSerialization.dataWithJSONObject(array, options: nil, error: nil)
//            let string = NSString(data: data!, encoding: NSUTF8StringEncoding)
//
//            do {
//                let json = try JSONSerialization.data(withJSONObject: finalArray)
//                let accRespModel = try AccountRespModel(jsonDict)
                sucessResult(response)
//                return
//            } catch {
//                print("Catched")
//                errorResult(error.localizedDescription)
//                APIManager.printOnDebug(response: "error:\(error.localizedDescription)")
//                return
//            }
            
        }) { (error) in
            self.busyOff()
            errorResult(error?.localizedDescription)
            APIManager.printOnDebug(response: "error:\(error?.localizedDescription)")
            return
        }
    }
 
    public func getUserSubscriptionList(type:String, sucessResult:@escaping resultClosure,errorResult:@escaping errorClosure){
        let params = [String:String]()
        
        let userId = UserDefaults.standard.string(forKey: "bP_userId") ?? ""
        let trimmeduserId = userId.trimmingCharacters(in: .whitespaces)
        let type = "subscriptionType="+"\(type)"+"&hideConnectedUser=true&hideLikedUser=true&hideRejectedConnections=true&hideBlockedUsers=true&showReceived=true"
        
        APIGetClient.doGetRequest.inGetReqForArray(method:ApiMethods.getSubscription + "?\(type)"  , params: params, sucess: { (response) in
            
            APIManager.printOnDebug(response: " Resppp : \(response)")
            
            
            let jsonDict = response! as! NSArray
            print(" Resppp :", jsonDict)
            
            do {
                
                let connUserModel = try SubscriptionUserModelArray(jsonDict)
                sucessResult(connUserModel)
                return
            } catch {
                print("Catched")
                errorResult(error.localizedDescription)
                APIManager.printOnDebug(response: "error:\(error.localizedDescription)")
                return
            }
            
        }) { (error) in
            self.busyOff()
            errorResult(error?.localizedDescription)
            APIManager.printOnDebug(response: "error:\(error?.localizedDescription)")
            return
        }
    }
    
    public func getSearchList(endpoint:String, sucessResult:@escaping resultClosure,errorResult:@escaping errorClosure){
        let params = [String:String]()
        APIGetClient.doGetRequest.inGetReqForArray(method:ApiMethods.getSearch + "?\(endpoint)"  , params: params, sucess: { (response) in
            
            APIManager.printOnDebug(response: " Resppp : \(response)")
            
            
            let jsonDict = response! as! NSArray
            print(" Resppp :", jsonDict)
            
            do {
                
                let connUserModel = try SearchUserModelArray(jsonDict)
                sucessResult(connUserModel)
                return
            } catch {
                print("Catched")
                errorResult(error.localizedDescription)
                APIManager.printOnDebug(response: "error:\(error.localizedDescription)")
                return
            }
            
        }) { (error) in
            self.busyOff()
            errorResult(error?.localizedDescription)
            APIManager.printOnDebug(response: "error:\(error?.localizedDescription)")
            return
        }
    }
    
    public func getRecentChatDetails( sucessResult:@escaping resultClosure,errorResult:@escaping errorClosure){
        let params = [String:String]()
        
        APIGetClient.doGetRequest.inGetFcmMessages(method:ApiMethods.fcmMessages, params: params, sucess: { (response) in
            
            APIManager.printOnDebug(response: "\(response)")
            let jsonDict = response! as! JSONDictionary
            
            do {
                
                let accRespModel = try AccountRespModel(jsonDict)
                sucessResult(accRespModel)
                return
            } catch {
                print("Catched")
                errorResult(error.localizedDescription)
                APIManager.printOnDebug(response: "error:\(error.localizedDescription)")
                return
            }
            
        }) { (error) in
            self.busyOff()
            errorResult(error?.localizedDescription)
            APIManager.printOnDebug(response: "error:\(error?.localizedDescription)")
            return
        }
    }
    
    public func requestHiFi(userId:String, sucessResult:@escaping resultClosure,errorResult:@escaping errorClosure){
        let params = ["":""]
        APIClient.doRequest.inPost(method:ApiMethods.sendHiFiRequest + "\(userId)", params: params , sucess: { (response) in
            let jsonDict = response! as! JSONDictionary
            do {
                let accRespModel = try ConnectedUserModel(jsonDict)
                sucessResult(accRespModel)
                return
            } catch {
                print("Catched")
                errorResult(error.localizedDescription)
                APIManager.printOnDebug(response: "error:\(error.localizedDescription)")
                return
            }
            
            
        }) { (error) in
            self.busyOff()
            errorResult(error?.localizedDescription)
            APIManager.printOnDebug(response: "error:\(String(describing: error?.localizedDescription))")
            return
        }
        
 }
    public func requestFriendship(userId:String, sucessResult:@escaping resultClosure,errorResult:@escaping errorClosure){
        let params = ["":""]
        APIClient.doRequest.inPost(method:ApiMethods.sendFriendRequest + "\(userId)", params: params , sucess: { (response) in
            let jsonDict = response! as! JSONDictionary
            do {
                let accRespModel = try ConnectedUserModel(jsonDict)
                sucessResult(accRespModel)
                return
            } catch {
                print("Catched")
                errorResult(error.localizedDescription)
                APIManager.printOnDebug(response: "error:\(error.localizedDescription)")
                return
            }
        }) { (error) in
            self.busyOff()
            errorResult(error?.localizedDescription)
            APIManager.printOnDebug(response: "error:\(String(describing: error?.localizedDescription))")
            return
        }
        
 }
    public func rejectFriendship(userId:String, sucessResult:@escaping resultClosure,errorResult:@escaping errorClosure){
        let params = ["":""]
        APIClient.doRequest.inPost(method:ApiMethods.rejectFriendRequest + "\(userId)", params: params , sucess: { (response) in
            let jsonDict = response! as! JSONDictionary
            do {
                let accRespModel = try ConnectedUserModel(jsonDict)
                sucessResult(accRespModel)
                return
            } catch {
                print("Catched")
                errorResult(error.localizedDescription)
                APIManager.printOnDebug(response: "error:\(error.localizedDescription)")
                return
            }
            
        }) { (error) in
            self.busyOff()
            errorResult(error?.localizedDescription)
            APIManager.printOnDebug(response: "error:\(String(describing: error?.localizedDescription))")
            return
        }
        
 }
 
    public func undoSwipeAction(userId:String, sucessResult:@escaping resultClosure,errorResult:@escaping errorClosure){
        let params = ["":""]
        APIClient.doRequest.inPost(method:ApiMethods.undoSwipeAction + "\(userId)", params: params , sucess: { (response) in
            let jsonDict = response! as! JSONDictionary
            do {
                let accRespModel = try ConnectedUserModel(jsonDict)
                sucessResult(accRespModel)
                return
            } catch {
                print("Catched")
                errorResult(error.localizedDescription)
                APIManager.printOnDebug(response: "error:\(error.localizedDescription)")
                return
            }
            
        }) { (error) in
            self.busyOff()
            errorResult(error?.localizedDescription)
            APIManager.printOnDebug(response: "error:\(String(describing: error?.localizedDescription))")
            return
        }
        
    }
    
    
    public func setPushNotification(recipients:String,icon:String,title:String,body:String, sucessResult:@escaping resultClosure,errorResult:@escaping errorClosure){
        
        let params: [String: Any] = [
            "data": [
                "body": body,
                "title": title,
                "icon": icon,
            ],
            "to": recipients
        ]
        
        APIClient.doRequest.inPostPushNotification(method:ApiMethods.sendPushnotification , params: params , sucess: { (response) in
            let jsonDict = response! as! JSONDictionary
            do {
                print(jsonDict)
              //  let accRespModel = try JSONDictionary(jsonDict)
              //  sucessResult(jsonDict)
                return
            } catch {
                print("Catched")
                errorResult(error.localizedDescription)
                APIManager.printOnDebug(response: "error:\(error.localizedDescription)")
                return
            }
            
        }) { (error) in
            self.busyOff()
            errorResult(error?.localizedDescription)
            APIManager.printOnDebug(response: "error:\(String(describing: error?.localizedDescription))")
            return
        }
        
    }
    
    
    
    
    func getCookie(name:String)-> String{
        
        let cookie = HTTPCookieStorage.shared.cookies
        let cookieJar = HTTPCookieStorage.shared
        
        for cookie in cookieJar.cookies! {
            
            if(cookie.name == name ){
                
                return cookie.value
            }
            else{
                continue
            }
        }
        return ""
    }
    
    // reset password 1 call
    public func forgotPasswordEmailSent(email:String, sucessResult:@escaping resultClosure,errorResult:@escaping errorClosure){
        let params = email
        
        APIClient.doRequest.inPostForStr(method: ApiMethods.ReqPasswrodReset, params: params, sucess: { (response) in
            
            let jsonDict = response! as! JSONDictionary
            
            
            do {
                let accRespModel = try ForgotPassResponceModel(jsonDict)
                sucessResult(accRespModel)
                return
            } catch {
                print("Catched")
                errorResult(error.localizedDescription)
                APIManager.printOnDebug(response: "error:\(error.localizedDescription)")
                return
            }
            
        }){ (error) in
            self.busyOff()
            errorResult(error?.localizedDescription)
            APIManager.printOnDebug(response: "error:\(error?.localizedDescription)")
            return
        }
        
        
    }
    public func finishPasswordReset(key:String,newPassword:String, sucessResult:@escaping resultClosure,errorResult:@escaping errorClosure){
        let params = ["key":key,
                      "newPassword":newPassword]
        APIClient.doRequest.inPostForPass(method: ApiMethods.ResetPasswordFinish, params: params, sucess: {(response) in

            let jsonDict = response! as! JSONDictionary
            do {
                let accRespModel = try ForgotPassResponceModel(jsonDict)
                sucessResult(accRespModel)
                return
            } catch {
                print("Catched")
                errorResult(error.localizedDescription)
                APIManager.printOnDebug(response: "error:\(error.localizedDescription)")
                return
            }
                
        }, failure: {(error) in
            self.busyOff()
            errorResult(error?.localizedDescription)
            APIManager.printOnDebug(response: "error:\(error?.localizedDescription)")
            return})
        
    }
    
    public func changePassword(password:String, sucessResult:@escaping resultClosure,errorResult:@escaping errorClosure){
        let params = password
        APIClient.doRequest.inPostForStr(method: ApiMethods.ChangePassword, params: params, sucess: { (response) in
            
            let json = response as Any
            print(" rest model",json)
            
        }){ (error) in
            self.busyOff()
            errorResult(error?.localizedDescription)
            APIManager.printOnDebug(response: "error:\(error?.localizedDescription)")
            return
        }
    }
    public func blockConnectedUser(id:Int,sucessResult:@escaping resultClosure,errorResult:@escaping errorClosure){
        let params = [String:String]()
        let userId = id
    
        APIClient.doRequest.inPost(method:ApiMethods.GetBlockedUser + "/\(userId)"  , params: params, sucess: { (response) in
            
            APIManager.printOnDebug(response: " Resppp222 : \(response)")
            let jsonDict = response! as! JSONDictionary
            do {
                let accRespModel = try ConnectedUserModelArray(jsonDict)
                sucessResult(accRespModel)
                return
            } catch {
                print("Catched")
                errorResult(error.localizedDescription)
                APIManager.printOnDebug(response: "error:\(error.localizedDescription)")
                return
            }
            
        }) { (error) in
            self.busyOff()
            errorResult(error?.localizedDescription)
            APIManager.printOnDebug(response: "error:\(error?.localizedDescription)")
            return
        }
        
    }
    
    public func unBlockConnectedUser(id:Int,sucessResult:@escaping resultClosure,errorResult:@escaping errorClosure){
        let params = [String:String]()
        let userId = id
        
        APIClient.doRequest.inPost(method:ApiMethods.UnBlockUser + "/\(userId)"  , params: params, sucess: { (response) in
            
            APIManager.printOnDebug(response: " Resppp222 : \(response)")
            let jsonDict = response! as! JSONDictionary
            do {
                let accRespModel = try ConnectedUserModelArray(jsonDict)
                sucessResult(accRespModel)
                return
            } catch {
                print("Catched")
                errorResult(error.localizedDescription)
                APIManager.printOnDebug(response: "error:\(error.localizedDescription)")
                return
            }
            
        }) { (error) in
            self.busyOff()
            errorResult(error?.localizedDescription)
            APIManager.printOnDebug(response: "error:\(error?.localizedDescription)")
            return
        }
        
    }
    
    
    // create Note in connnections
    public func getNotes(fromUserId:Int,toUserId:Int,sucessResult:@escaping resultClosure,errorResult:@escaping errorClosure) {
        let fromUserId = fromUserId
        let toUserId = toUserId
        let params = [String:String]()
        
        APIGetClient.doGetRequest.inGetReqForArray(method:ApiMethods.GetAllNoteFrom + "/\(fromUserId)" + "/to/" + "\(toUserId)" , params: params, sucess: { (response) in
            
            APIManager.printOnDebug(response: " Resppp1111 : \(response)")
            
            
            let jsonDict = response!;
            print(jsonDict)
            do {
                
                let accRespModel = try GetNoteRespModelArray(jsonDict)
                sucessResult(accRespModel)
                return
            } catch {
                print("Catched")
                errorResult(error.localizedDescription)
                APIManager.printOnDebug(response: "error:\(error.localizedDescription)")
                return
            }
            
        }) { (error) in
            self.busyOff()
            errorResult(error?.localizedDescription)
            APIManager.printOnDebug(response: "error:\(error?.localizedDescription)")
            return
        }
    }
    // Click action of new note
    public func postNote(note:String,toUserId:Int,sucessResult:@escaping resultClosure,errorResult:@escaping errorClosure){
        let params = [
            "toUserId":toUserId,
            "note":note,
            ] as [String : Any]
        print(params)
        APIClient.doRequest.inPostReq(method:ApiMethods.CreateNote, params: params, sucess: { (response) in
            
            //            APIManager.printOnDebug(response: "\(response)")
            
            let jsonDict = response! as! JSONDictionary
            
            do {
                
                let loginModel = try GetNoteRespModel(jsonDict)
                sucessResult(loginModel)
                return
            } catch {
                print("Catched")
                errorResult(error.localizedDescription)
                APIManager.printOnDebug(response: "error:\(error.localizedDescription)")
                return
            }
            
        }) { (error) in
            self.busyOff()
            errorResult(error?.localizedDescription)
            APIManager.printOnDebug(response: "error:\(error?.localizedDescription)")
            return
        }
    }
    
    public func removeNote(withNoteId noteId:Int, sucessResult:@escaping resultClosure,errorResult:@escaping errorClosure){

        let params = [String:String]()
        APIClient.doRequest.inDelete(method:ApiMethods.DeleteNote + "/\(noteId)", params: params, sucess: { (response) in
            
            //            APIManager.printOnDebug(response: "\(response)")
            
            let jsonDict = response! as! JSONDictionary
            
            do {
                
                let loginModel = try GetNoteRespModel(jsonDict)
                sucessResult(loginModel)
                return
            } catch {
                print("Catched")
                errorResult(error.localizedDescription)
                APIManager.printOnDebug(response: "error:\(error.localizedDescription)")
                return
            }
            
        }) { (error) in
            self.busyOff()
            errorResult(error?.localizedDescription)
            APIManager.printOnDebug(response: "error:\(error?.localizedDescription)")
            return
        }
    }
    public func createNote(toUserId:Int,sucessResult:@escaping resultClosure,errorResult:@escaping errorClosure){
        let params = [
            "toUserId":toUserId,
            "note":" ",
            ] as [String : Any]
        print(params)
        APIClient.doRequest.inPostReq(method:ApiMethods.CreateNote, params: params, sucess: { (response) in
            
            //            APIManager.printOnDebug(response: "\(response)")
            
            let jsonDict = response! as! JSONDictionary
            
            do {
                
                let loginModel = try GetNoteRespModel(jsonDict)
                sucessResult(loginModel)
                return
            } catch {
                print("Catched")
                errorResult(error.localizedDescription)
                APIManager.printOnDebug(response: "error:\(error.localizedDescription)")
                return
            }
            
        }) { (error) in
            self.busyOff()
            errorResult(error?.localizedDescription)
            APIManager.printOnDebug(response: "error:\(error?.localizedDescription)")
            return
        }
    }
    
    public func updateNote(noteId: Int,note:String,toUserId:Int,sucessResult:@escaping resultClosure,errorResult:@escaping errorClosure){
        
        let params = [
            "note": note,
            "toUserId": toUserId,
            ] as [String : Any]
        
        APIClient.doRequest.inPutRawData(method:ApiMethods.UpdateNote  + "/\(noteId)" , params: params , sucess: { (response) in
            self.busyOff()
            
            //            APIManager.printOnDebug(response: "\(response)")
            
            
            let jsonDict = response! as! JSONDictionary
            
            do {
                
                let loginModel = try GetNoteRespModel(jsonDict)//GetNoteRespModel
                sucessResult(loginModel)
                return
            } catch {
                errorResult(error.localizedDescription)
                APIManager.printOnDebug(response: "error:\(error.localizedDescription)")
                return
            }
            
            
            
        }) { (error) in
            self.busyOff()
            errorResult(error?.localizedDescription)
            APIManager.printOnDebug(response: "error:\(error?.localizedDescription)")
            return
        }
    }
    
    
    // MARK:- Events
    public func getAllEvents(sucessResult:@escaping resultClosure,errorResult:@escaping errorClosure) {
        let params = [String:String]()
        
        
        APIGetClient.doGetRequest.inGetReqForArray(method: ApiMethods.GetAllEvents, params: params, sucess: { (response) in
            APIManager.printOnDebug(response: " Resppp1111 : \(response)")
            
            let jsonDict = response!
            
            do {
                
                let accRespModel = try GetEventsRespModelArray(jsonDict)
                sucessResult(accRespModel)
                return
            } catch {
                print("Catched")
                errorResult(error.localizedDescription)
                APIManager.printOnDebug(response: "error:\(error.localizedDescription)")
                return
            }
            
        }) { (error) in
            
            self.busyOff()
            errorResult(error?.localizedDescription)
            APIManager.printOnDebug(response: "error:\(error?.localizedDescription)")
            return
        }
    }
    
    public func getAllUserEvents(sucessResult:@escaping resultClosure,errorResult:@escaping errorClosure) {
        let params = [String:String]()
        
        let userId = UserDefaults.standard.string(forKey: "bP_userId") ?? ""
        APIGetClient.doGetRequest.inGetReqForArray(method: ApiMethods.GetUserEvents + "/\(userId)" , params: params, sucess: { (response) in
            APIManager.printOnDebug(response:"getAllUserEvents  --> : \(response)")
            
            let jsonDict = response!
            
            do {
                
                let accRespModel = try GetAllUserEventsRespModelArray(jsonDict)
                sucessResult(accRespModel)
                return
            } catch {
                print("Catched")
                errorResult(error.localizedDescription)
                APIManager.printOnDebug(response: "error:\(error.localizedDescription)")
                return
            }
            
        }) { (error) in
            
            self.busyOff()
            errorResult(error?.localizedDescription)
            APIManager.printOnDebug(response: "error:\(error?.localizedDescription)")
            return
        }
    }
    
    public func registerEvent(eventId: Int, registerType: String, partners: [Int], sucessResult:@escaping resultClosure,errorResult:@escaping errorClosure) {
        
        let params: [String: Any] = [
            "eventId": eventId,
            "registerType": registerType,
            "userIds": partners
        ]
        
        APIClient.doRequest.inPostReq(method: ApiMethods.RegisterEvent, params: params, sucess: { (response) in
            
            APIManager.printOnDebug(response: " Resppp1111 : \(String(describing: response))")
            
            sucessResult(nil)
            
//            let jsonDict = response!
//
//            do {
//                let accRespModel = try GetEventsRespModelArray(jsonDict as! [String : Any])
//                sucessResult(accRespModel)
//                return
//            } catch {
//                print("Catched")
//                errorResult(error.localizedDescription)
//                APIManager.printOnDebug(response: "error:\(error.localizedDescription)")
//                return
//            }
        }) { (error) in
            self.busyOff()
            errorResult(error?.localizedDescription)
            APIManager.printOnDebug(response: "error:\(String(describing: error?.localizedDescription))")
            return
        }
    }
    
    public func getAllEventInvitations(eventId: Int, calendarType: String, sucessResult:@escaping resultClosure,errorResult:@escaping errorClosure) {
        let params = [String:String]()
        
        APIGetClient.doGetRequest.inGet(method: ApiMethods.EventInvitations + "\(eventId)?calendarType=\(calendarType)", params: params, sucess: { (response) in
            
            let jsonDict = response! as! [String : Any]
            
            do {
                let accRespModel = try GetEventInvitationRespModel(jsonDict)
                sucessResult(accRespModel)
                return
            } catch {
                print("Catched")
                errorResult(error.localizedDescription)
                APIManager.printOnDebug(response: "error:\(error.localizedDescription)")
                return
            }
            
        }) { (error) in
            print("Catched")
            errorResult(error?.localizedDescription)
            APIManager.printOnDebug(response: "error:\(String(describing: error?.localizedDescription))")
            return
        }
    }
    
    public func respondToInvitation(eventId: Int, organiserId: Int, action: String, sucessResult:@escaping resultClosure,errorResult:@escaping errorClosure) {
     
        let params: [String: Any] = [
            "eventId": eventId,
            "orgUserId": organiserId,
            "responseType": action
        ]
        
        APIClient.doRequest.inPostReq(method: ApiMethods.InvitationResponse, params: params, sucess: { (response) in
            
            APIManager.printOnDebug(response: " Resppp1111 : \(String(describing: response))")
            
            sucessResult(nil)
            
            //            let jsonDict = response!
            //
            //            do {
            //                let accRespModel = try GetEventsRespModelArray(jsonDict as! [String : Any])
            //                sucessResult(accRespModel)
            //                return
            //            } catch {
            //                print("Catched")
            //                errorResult(error.localizedDescription)
            //                APIManager.printOnDebug(response: "error:\(error.localizedDescription)")
            //                return
            //            }
        }) { (error) in
            self.busyOff()
            errorResult(error?.localizedDescription)
            APIManager.printOnDebug(response: "error:\(String(describing: error?.localizedDescription))")
            return
        }
    }
    
    public func getAllEventBetweenDetails(sucessResult:@escaping resultClosure,errorResult:@escaping errorClosure){
        let params = [String:String]()
        
        let todayDate = Calendar.current.date(byAdding: .month, value: 0, to: Date())
        let futureDate = Calendar.current.date(byAdding: .month, value: 5, to: Date())
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let currentDate : String = dateFormatter.string(from: todayDate!)
        let dateAfterFiveMonth : String = dateFormatter.string(from: futureDate!)
        print("Result: ",currentDate)
        
        let fromDate = currentDate
        let toDate = dateAfterFiveMonth
        let userId = UserDefaults.standard.string(forKey: "bP_userId") ?? ""
        let type = "fromDate="+"\(fromDate)"+"&toDate="+"\(toDate)"+"&userId="+"\(userId)"
        //        let type = "subscriptionType="+"\(type)"
        
        APIGetClient.doGetRequest.inGetReqForArr(method:ApiMethods.GetAllUserEventsBetween + "?\(type)"  , params: params, sucess: { (response) in
            
            APIManager.printOnDebug(response: " Resppp1111 : \(response)")
            
            
            let jsonDict = response! as! NSArray
            
            do {
                
                let accRespModel = try GetAllEventsBetweenResponseModelArray(jsonDict)
                sucessResult(accRespModel)
                return
            } catch {
                print("Catched")
                errorResult(error.localizedDescription)
                APIManager.printOnDebug(response: "error:\(error.localizedDescription)")
                return
            }
            
        }) { (error) in
            self.busyOff()
            errorResult(error?.localizedDescription)
            APIManager.printOnDebug(response: "error:\(error?.localizedDescription)")
            return
        }
    }
}





extension NSDictionary {
    
    var json: String {
        let invalidJson = "Not a valid JSON"
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            return String(bytes: jsonData, encoding: String.Encoding.utf8) ?? invalidJson
        } catch {
            return invalidJson
        }
    }
    
    func printJson() {
        print(json)
    }
    
}

