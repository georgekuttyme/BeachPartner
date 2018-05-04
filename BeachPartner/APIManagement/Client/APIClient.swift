//
//  APIClient.swift
//  BeachPartner
//
//  Created by Jerry K Mathew on 26/03/18.
//  Copyright © 2018 dev. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
final class APIClient{
    
    typealias sucessClosure = (_ result: NSDictionary?) -> Void
    typealias failureClosure = (_ error: Error?) -> Void
    static  let doRequest = APIClient()
    private var sessionManager = Alamofire.SessionManager.default
    
    //    sessionManager.adapter = oauthHandler
    //    sessionManager.retrier = oauthHandler
    private init() {
        
    }
    
    // MARK: - POST Request
    
    /// Send a post request to server in which parameters will send in rquest boady
    ///
    /// - parameter url:        The URL.
    /// - parameter parameters: The parameters. cannot be `nil`.
    /// - parameter sucess:     The sucessClosure whinch invoke in sucessfull request.
    /// - parameter failure:    The failureClosure which invoke in falure request.
    ///
    
    //    public func inPost(url:String,params:[String:String],sucess:@escaping sucessClosure, failure:@escaping failureClosure){
    //
    //
    ////        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    //        DispatchQueue.main.async(execute: {
    //            /* Do UI work here */
    //
    //        do{
    //            print("inside do")
    //            let headers = [
    //                "Content-Type": "application/json",
    //                "Cache-Control": "no-cache",
    //                ]
    //            let parameters = params
    //
    //            let postData = try JSONSerialization.data(withJSONObject: parameters, options: [])
    //
    //            let request = NSMutableURLRequest(url: NSURL(string: url)! as URL,
    //                                              cachePolicy: .useProtocolCachePolicy,
    //                                              timeoutInterval: 10.0)
    //            request.httpMethod = "POST"
    //            request.allHTTPHeaderFields = headers
    //            request.httpBody = postData as Data
    //
    //            let session = URLSession.shared
    //            let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
    //                if (error != nil) {
    //                    print(error)
    //                } else {
    //                    let httpResponse = response as? HTTPURLResponse
    //                    print(httpResponse , data)
    //
    //                    let responseString = String(data: data!, encoding: .utf8) ?? ""
    //                    print("responseString = ",responseString)
    //
    //                    do {
    //                        let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:Any]
    //                        print("responses :: ", json)
    //                        sucess(json as NSDictionary?)
    //                        return
    //                    } catch let error as NSError {
    //                        print(error)
    //                        failure(error)
    //                        return
    //                    }
    //                }
    //            })
    //
    //            dataTask.resume()
    //
    //        }catch {
    //            print(error)
    //        }
    //
    //        })
    //    }
    
    
    public func inPost(url:String,params:[String:String],sucess:@escaping sucessClosure, failure:@escaping failureClosure){
        
        
        
        
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        print("####### API Request ....url :", url, "\n #### parameters :", params)
        
        //        let cookie = HTTPCookieStorage.shared.cookies
        let cookieJar = HTTPCookieStorage.shared
        //        print("\n ####### Request cookie...elements : ", cookieJar.cookies?.count as Any , "\n")
        
        for cookie in cookieJar.cookies! {
            print(cookie.name+"="+cookie.value)
        }
        
        
        let token = UserDefaults.standard.string(forKey: "bP_token") ?? ""
        var headders: HTTPHeaders = [:]
        
        
        if( token != ""){
            headders = [
                "Accept": "application/json, text/plain, */*",
                "Content-Type" :"application/json ; charset=utf-8",
                "Authorization" : "Bearer " + token
            ]
        }
        else{
            headders = [
                "Accept": "application/json, text/plain, */*",
                "Content-Type" :"application/json; charset=utf-8"
            ]
        }
        
//        headders: HTTPHeaders = [
//            "Accept": "application/json, text/plain, */*",
//            "Content-Type" :"application/json ; charset=utf-8"
//        ]
        
        
        let postRequest = self.sessionManager.request(url, method: .post, parameters: params as [String:Any], encoding: JSONEncoding.default, headers:headders
        )
        
        //""
        
        print("####### API response String :", postRequest.responseString,"\n")
        
        
        postRequest.responseJSON { (responseObject) in
            
            
            print("####### API response :", responseObject,"\n")
            
            let cookieJar = HTTPCookieStorage.shared
            
            //            print("# Cookie data count :", cookieJar.cookies?.count as Any)
            
            for cookie in cookieJar.cookies! {
                print(cookie.name+"="+cookie.value)
            }
            print("_________________________________________________\n\n\n")
            
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            switch  responseObject.result {
            case .success:
                
                let json = responseObject.result.value
                
                sucess(json as! NSDictionary?)
                return
            case .failure:
                let error = responseObject.result.error
                failure(error)
                return
            }
            }.responseString { (jsonString) in
                APIManager.printOnDebug(response: jsonString)
        }
    }
    
    
    
    public func inPostReq(url:String,params: [String:Any],sucess:@escaping sucessClosure,failure:@escaping failureClosure){
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        print("####### API Request ....url :", url, "\n #### parameters :", params)
        
        //        let cookie = HTTPCookieStorage.shared.cookies
        let cookieJar = HTTPCookieStorage.shared
        //        print("\n ####### Request cookie...elements : ", cookieJar.cookies?.count as Any , "\n")
        
        for cookie in cookieJar.cookies! {
            //            print(cookie.name+"="+cookie.value)
            //             cookieJar.deleteCookie(cookie)
        }
        
        
        let token = UserDefaults.standard.string(forKey: "bP_token") ?? ""
        
        var headders: HTTPHeaders = [:]
        
        if( token != ""){
            headders = [
                "Accept": "application/json, text/plain, */*",
                "Content-Type" :"application/json; charset=utf-8",
                "Authorization" : "Bearer " + token
            ]
        }
        else{
            headders = [
                "Accept": "application/json, text/plain, */*",
                "Content-Type" :"application/json; charset=utf-8"
            ]
        }
        
        let postRequest = self.sessionManager.request(url, method: .post, parameters: params as [String:Any], encoding: JSONEncoding.default, headers:headders
        )
        
        //""
        
        print("####### API response String :", postRequest.responseString,"\n")
        
        
        
        postRequest.responseJSON { (responseObject) in
            
            
            print("####### API response :", responseObject,"\n")
            
            let cookieJar = HTTPCookieStorage.shared
            
            //            print("# Cookie data count :", cookieJar.cookies?.count as Any)
            
            for cookie in cookieJar.cookies! {
                print(cookie.name+"="+cookie.value)
            }
            print("_________________________________________________\n\n\n")
            
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            switch  responseObject.result {
            case .success:
                
                let json = responseObject.result.value
                
                sucess(json as! NSDictionary?)
                return
            case .failure:
                let error = responseObject.result.error
                failure(error)
                return
            }
            }.responseString { (jsonString) in
                APIManager.printOnDebug(response: jsonString)
        }
    }
    
    
    
    public func inPostSentPushnotification(url:String,params:[String:Any],sucess:@escaping sucessClosure, failure:@escaping failureClosure){
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        print("####### API Request ....url :", url, "\n #### parameters :", params)
        
        //        let cookie = HTTPCookieStorage.shared.cookies
        let cookieJar = HTTPCookieStorage.shared
        //        print("\n ####### Request cookie...elements : ", cookieJar.cookies?.count as Any , "\n")
        
        for cookie in cookieJar.cookies! {
            print(cookie.name+"="+cookie.value)
        }
        
        let token = API.FCM_AUTH_TOKEN
        var headders: HTTPHeaders = [:]
        
        
        if( token != ""){
            headders = [
                "Accept": "application/json, text/plain, */*",
                "Content-Type" :"application/json ; charset=utf-8",
                "Authorization" : "key=" + token
            ]
        }
        else{
            headders = [
                "Accept": "application/json, text/plain, */*",
                "Content-Type" :"application/json; charset=utf-8"
            ]
        }
        
        //        headders: HTTPHeaders = [
        //            "Accept": "application/json, text/plain, */*",
        //            "Content-Type" :"application/json ; charset=utf-8"
        //        ]
        
        
        let postRequest = self.sessionManager.request(url, method: .post, parameters: params as [String:Any], encoding: JSONEncoding.default, headers:headders
        )
        
        //""
        
        print("####### API response String :", postRequest.responseString,"\n")
        
        
        postRequest.responseJSON { (responseObject) in
            
            
            print("####### API response :", responseObject,"\n")
            
            let cookieJar = HTTPCookieStorage.shared
            
            //            print("# Cookie data count :", cookieJar.cookies?.count as Any)
            
            for cookie in cookieJar.cookies! {
                print(cookie.name+"="+cookie.value)
            }
            print("_________________________________________________\n\n\n")
            
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            switch  responseObject.result {
            case .success:
                
                let json = responseObject.result.value
                
                sucess(json as! NSDictionary?)
                return
            case .failure:
                let error = responseObject.result.error
                failure(error)
                return
            }
            }.responseString { (jsonString) in
                APIManager.printOnDebug(response: jsonString)
        }
    }
    
    
    
    
    
    // MARK: - PUT Request
    
    /// Send a post request to server in which parameters will send in rquest boady
    ///
    /// - parameter url:        The URL.
    /// - parameter parameters: The parameters. cannot be `nil`.
    /// - parameter sucess:     The sucessClosure whinch invoke in sucessfull request.
    /// - parameter failure:    The failureClosure which invoke in falure request.
    ///
    
    public func inPut(url:String,params:[String:String],sucess:@escaping sucessClosure,failure:@escaping failureClosure){
       
        do{
            
            let token = UserDefaults.standard.string(forKey: "bP_token") ?? ""
            var headders: HTTPHeaders = [:]
            
            
            if( token != ""){
                headders = [
                    "Accept": "application/json",
                    "Content-Type" :"application/json ; charset=utf-8",
                    "Authorization" : "Bearer " + token,
                    "Cache-Control": "no-cache",
                ]
            }
            else{
                headders = [
                    "Accept": "application/json, text/plain, */*",
                    "Content-Type" :"application/json; charset=utf-8",
                    "Cache-Control": "no-cache",
                ]
            }

            let parameters = params
            
            let postData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            
            let request = NSMutableURLRequest(url: NSURL(string: url)! as URL,
                                              cachePolicy: .useProtocolCachePolicy,
                                              timeoutInterval: 10.0)
            request.httpMethod = "PUT"
            request.allHTTPHeaderFields = headders
            request.httpBody = postData as Data
            
            let session = URLSession.shared
            let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                if (error != nil) {
                    print(error)
                } else {
                    let httpResponse = response as? HTTPURLResponse
                    print(httpResponse , data)
                    
                    let responseString = String(data: data!, encoding: .utf8) ?? ""
                    print("responseString = ",responseString)
                    
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:Any]
                        print("responses :: ", json)
                        sucess(json as NSDictionary?)
                        return
                    } catch let error as NSError {
                        print(error)
                        failure(error)
                        return
                    }
                }
            })
            
            dataTask.resume()
            
        }catch {
            print(error)
        }
        
        
        //            }.responseString { (jsonString) in
        //                APIManager.printOnDebug(response: jsonString)
        //        }
    }
    
    
    public func inPutJsonData(url:String,params:[String:[String:String]],sucess:@escaping sucessClosure,failure:@escaping failureClosure){
        
        do{
            print("####### API Request ....url :", url, "\n #### parameters :", params)
            
            let token = UserDefaults.standard.string(forKey: "bP_token") ?? ""
            var headders: HTTPHeaders = [:]
            
            
            if( token != ""){
                headders = [
                    "Accept": "application/json",
                    "Content-Type" :"application/json ; charset=utf-8",
                    "Authorization" : "Bearer " + token,
                    "Cache-Control": "no-cache",
                ]
            }
            else{
                headders = [
                    "Accept": "application/json, text/plain, */*",
                    "Content-Type" :"application/json; charset=utf-8",
                    "Cache-Control": "no-cache",
                ]
            }
            
            let parameters = params
            
            let postData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            
            let request = NSMutableURLRequest(url: NSURL(string: url)! as URL,
                                              cachePolicy: .useProtocolCachePolicy,
                                              timeoutInterval: 10.0)
            request.httpMethod = "PUT"
            request.allHTTPHeaderFields = headders
            request.httpBody = postData as Data
            
            let session = URLSession.shared
            let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                if (error != nil) {
                    print(error)
                } else {
                    let httpResponse = response as? HTTPURLResponse
                    print(httpResponse , data)
                    
                    let responseString = String(data: data!, encoding: .utf8) ?? ""
                    print("responseString = ",responseString)
                    
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:Any]
                        print("responses :: ", json)
                        sucess(json as NSDictionary?)
                        return
                    } catch let error as NSError {
                        print(error)
                        failure(error)
                        return
                    }
                }
            })
            
            dataTask.resume()
            
        }catch {
            print(error)
        }
        //            }.responseString { (jsonString) in
        //                APIManager.printOnDebug(response: jsonString)
        //        }
    }
    
    
    
    
    
    
    public func inPutRawData(url:String,params:[String:Any],sucess:@escaping sucessClosure,failure:@escaping failureClosure){
        let token = UserDefaults.standard.string(forKey: "bP_token") ?? ""
        print(token,"tokkkkkkkkken")
        var headers: HTTPHeaders = [:]
        do{
            print("inside do")
            headers = [
                "Accept": "application/json",
                "Content-Type" :"application/json ; charset=utf-8",
                "Authorization" : "Bearer " + token,
                "Cache-Control": "no-cache",
            ]
            let parameters = params
            
            let postData = try JSONSerialization.data(withJSONObject: parameters)
            //            request.HTTPBody = data
            
            //            let postData = try JSONSerialization.data(withJSONObject: parameters)
            
            let request = NSMutableURLRequest(url: NSURL(string: url)! as URL,
                                              cachePolicy: .useProtocolCachePolicy,
                                              timeoutInterval: 10.0)
            request.httpMethod = "PUT"
            request.allHTTPHeaderFields = headers
            request.httpBody = postData as! Data
            
            
            //            print ("request : ", postData.str)
            let session = URLSession.shared
            let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                if (error != nil) {
                    print(error)
                } else {
                    let httpResponse = response as? HTTPURLResponse
                    print(httpResponse , data)
                    
                    let responseString = String(data: data!, encoding: .utf8) ?? ""
                    print("responseString = ",responseString)
                    
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:Any]
                        print("responses :: ", json)
                        sucess(json as NSDictionary?)
                        return
                    } catch let error as NSError {
                        print(error)
                        failure(error)
                        return
                    }
                }
            })
            
            dataTask.resume()
            
        }catch {
            print(error)
        }

    }
    
    
    
    
    // MARK: - GET Request
    
    /// Send a get request to server.
    ///
    /// - parameter url:        The URL.
    /// - parameter parameters: The parameters. cannot be `nil` but may empty.
    /// - parameter sucess:     The sucessClosure whinch invoke in sucessfull request.
    /// - parameter failure:    The failureClosure which invoke in falure request.
    ///
    
    public func inGet(url:String,params:[String:String],sucess:@escaping sucessClosure,failure:@escaping failureClosure){
        
        //        do{
        //            print("inside do")
        //            let headers = [
        //                "Content-Type": "application/json",
        //                "Cache-Control": "no-cache",
        //                ]
        //            let parameters = params
        //
        //            let postData = try JSONSerialization.data(withJSONObject: parameters, options: [])
        //
        //            let request = NSMutableURLRequest(url: NSURL(string: url)! as URL,
        //                                              cachePolicy: .useProtocolCachePolicy,
        //                                              timeoutInterval: 10.0)
        //            request.httpMethod = "GET"
        //            request.allHTTPHeaderFields = headers
        //            request.httpBody = postData as Data
        //
        //
        ////            print ("request : ", postData.str)
        //            let session = URLSession.shared
        //            let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
        //                if (error != nil) {
        //                    print(error)
        //                } else {
        //                    let httpResponse = response as? HTTPURLResponse
        //                    print(httpResponse , data)
        //
        //                    let responseString = String(data: data!, encoding: .utf8) ?? ""
        //                    print("responseString = ",responseString)
        //
        //                    do {
        //                        let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:Any]
        //                        print("responses :: ", json)
        //                        sucess(json as NSDictionary?)
        //                        return
        //                    } catch let error as NSError {
        //                        print(error)
        //                        failure(error)
        //                        return
        //                    }
        //                }
        //            })
        //
        //            dataTask.resume()
        //
        //        }catch {
        //            print(error)
        //        }
        //
        //
        
        
//        if(params.array(<#T##name: String##String#>))
        
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        print("####### API Request ....url :", url, "\n #### parameters :", params)
        
        let token = UserDefaults.standard.string(forKey: "bP_token") ?? ""
       
        var headders: HTTPHeaders = [:]
        
        if( token != ""){
         headders = [
            "Accept": "application/json, text/plain, */*",
            "Content-Type" :"application/json",
            "Authorization" : "Bearer " + token
        ]
        }
        else{
             headders = [
                "Accept": "application/json, text/plain, */*",
                "Content-Type" :"application/json"
                
            ]
        }
        let getRequest = sessionManager.request(url, method: .get, parameters: params, encoding: JSONEncoding.default, headers: headders)
        getRequest.responseJSON { (responseObject) in
            
            print("####### API response :", responseObject,"\n")
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            switch  responseObject.result {
            case .success:
                let json = responseObject.result.value
                sucess(json as! NSDictionary?)
                return
            case .failure:
                let error = responseObject.result.error
                failure(error)
                return
            }
        }
        
    }
    
//    func inPostForImageUpload(url:String,params:[String:String],image:UIImage,sucess:@escaping sucessClosure,failure:@escaping failureClosure){
//        UIApplication.shared.isNetworkActivityIndicatorVisible = true
//
//
//        _ = sessionManager.upload(
//            multipartFormData: { multipartFormData in
//                if let imageData = UIImageJPEGRepresentation(image, 0.6) {
//                    multipartFormData.append(imageData, withName: "userimage", fileName: "profilePic.png", mimeType:  "image/png")
//                }
//
//                for (key, value) in params {
//                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
//                }
//        },
//            to: url,
//            encodingCompletion: { encodingResult in
//
//                switch encodingResult {
//                case .success(let upload, _, _):
//                    print("s")
//                    upload.responseJSON {
//                        responseObject in
//                        print(responseObject.request!)  // original URL request
//                        print(responseObject.response!) // URL response
//                        print(responseObject.data!)     // server data
//
//                        let json = responseObject.result.value
//                        print("JSON: \(json)")
//                        sucess(json as! NSDictionary?)
//                        return
//
//                    }
//                case .failure(let encodingError):
//                    let error = encodingError
//                    print("error: \(error)")
//                    failure(error)
//                    return
//                }
//        }
//        )
//    }
    
    public func inPostForString(url:String,params:String,sucess:@escaping sucessClosure,failure:@escaping failureClosure){
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        print("####### API Request ....url :", url, "\n #### parameters :", params)
        let cookieJar = HTTPCookieStorage.shared
        for cookie in cookieJar.cookies! {
            print(cookie.name+"="+cookie.value)
        }
        let token = UserDefaults.standard.string(forKey: "bP_token") ?? ""
        
        var headders: HTTPHeaders = [:]
        if( token != ""){
            headders = [
                "Content-Type" :"application/json ; charset=utf-8",
                "Authorization" : "Bearer " + token
            ]
        }
        else{
            headders = [
                "Content-Type" :"application/json; charset=utf-8"
            ]
        }
        do{
            //        let param = ["mail":params]
            let parameters = params
            
            let postData = try parameters.data(using: .utf8)!
            
            let request = NSMutableURLRequest(url: NSURL(string: url)! as URL,
                                              cachePolicy: .useProtocolCachePolicy,
                                              timeoutInterval: 10.0)
            request.httpMethod = "POST"
            request.allHTTPHeaderFields = headders
            request.httpBody = postData as Data
            
            
            //            print ("request : ", postData.str)
            let session = URLSession.shared
            let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                if (error != nil) {
                    print(error)
                } else {
                    let httpResponse = response as? HTTPURLResponse
                    print(httpResponse , data)
                    
                    let responseString = String(data: data!, encoding: .utf8) ?? ""
                    print("responseString = ",responseString)
                    
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:Any]
                        print("responses :: ", json)
                        sucess(json as NSDictionary?)
                        return
                    } catch let error as NSError {
                        print(error)
                        failure(error)
                        return
                    }
                }
            })
            
            dataTask.resume()
            
        }catch {
            print(error)
        }
        
    }
    
    
    public func inPostForPass(url:String,params:[String:String],sucess:@escaping sucessClosure, failure:@escaping failureClosure){
        
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        print("####### API Request ....url :", url, "\n #### parameters :", params)
        
        //        let cookie = HTTPCookieStorage.shared.cookies
        let cookieJar = HTTPCookieStorage.shared
        //        print("\n ####### Request cookie...elements : ", cookieJar.cookies?.count as Any , "\n")
        
        for cookie in cookieJar.cookies! {
            print(cookie.name+"="+cookie.value)
        }
        
        
        let headders: HTTPHeaders = [
            "Accept": "application/json, text/plain, */*",
            "Content-Type" :"application/json ; charset=utf-8"
        ]
        
        
        let postRequest = self.sessionManager.request(url, method: .post, parameters: params as [String:Any], encoding: JSONEncoding.default, headers:headders
        )
        
        //""
        
        print("####### API response String :", postRequest.responseString,"\n")
        
        
        postRequest.responseJSON { (responseObject) in
            
            
            print("####### API response :", responseObject,"\n")
            
            let cookieJar = HTTPCookieStorage.shared
            
            //            print("# Cookie data count :", cookieJar.cookies?.count as Any)
            
            for cookie in cookieJar.cookies! {
                print(cookie.name+"="+cookie.value)
            }
            print("_________________________________________________\n\n\n")
            
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
            switch  responseObject.result {
            case .success:
                
                let json = responseObject.result.value
                
                sucess(json as! NSDictionary?)
                return
            case .failure:
                let error = responseObject.result.error
                failure(error)
                return
            }
            }.responseString { (jsonString) in
                APIManager.printOnDebug(response: jsonString)
        }
    }
    
    func inPostForImageUpload(url:String,params:[String:String],image:UIImage, videodata: NSData, sucess:@escaping sucessClosure,failure:@escaping failureClosure){
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let moviedata = Data(referencing: videodata)
        
        _ = sessionManager.upload(
            multipartFormData: { multipartFormData in
                if let imageData = UIImageJPEGRepresentation(image, 0.6) {
                    multipartFormData.append(imageData, withName: "profileImg", fileName: "profilePic.png", mimeType:  "image/png")
                }
                
                //                let data = NSData(videodata) as Data?
                
                
                if (moviedata != nil) {
                    
                    multipartFormData.append(moviedata, withName: "profileVideo", fileName: "profileVideo.mp4", mimeType:  "video/mp4")
                }
                
                for (key, value) in params {
                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                }
        },
            to: url,
            encodingCompletion: { encodingResult in
                
                switch encodingResult {
                case .success(let upload, _, _):
                    print("s")
                    upload.responseJSON {
                        responseObject in
                        //                        print(responseObject.request!)  // original URL request
                        //                        print(responseObject.response!) // URL response
                        //                        print(responseObject.data!)     // server data
                        
                        let json = responseObject.result.value
                        print("JSON: \(json)")
                        sucess(json as! NSDictionary?)
                        
                        
                        return
                        
                    }
                case .failure(let encodingError):
                    let error = encodingError
                    print("error: \(error)")
                    failure(error)
                    return
                }
        }
        )
    }
    public func inDelete(url:String,params:[String:String],sucess:@escaping sucessClosure, failure:@escaping failureClosure){
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        print("####### API Request ....url :", url, "\n #### parameters :", params)
        let cookieJar = HTTPCookieStorage.shared
        for cookie in cookieJar.cookies! {
            print(cookie.name+"="+cookie.value)
        }
        let token = UserDefaults.standard.string(forKey: "bP_token") ?? ""
        
        var headders: HTTPHeaders = [:]
        if( token != ""){
            headders = [
                "Content-Type" :"application/json ; charset=utf-8",
                "Authorization" : "Bearer " + token
            ]
        }
        else{
            headders = [
                "Content-Type" :"application/json; charset=utf-8"
            ]
        }
        do{
            let parameters = params
            let postData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            let request = NSMutableURLRequest(url: NSURL(string: url)! as URL,
                                              cachePolicy: .useProtocolCachePolicy,
                                              timeoutInterval: 10.0)
            request.httpMethod = "DELETE"
            request.allHTTPHeaderFields = headders
            request.httpBody = postData as Data
            
            
            //            print ("request : ", postData.str)
            let session = URLSession.shared
            let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                if (error != nil) {
                    print(error)
                } else {
                    let httpResponse = response as? HTTPURLResponse
                    print(httpResponse , data)
                    
                    let responseString = String(data: data!, encoding: .utf8) ?? ""
                    print("responseString = ",responseString)
                    
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:Any]
                        print("responses :: ", json)
                        sucess(json as NSDictionary?)
                        return
                    } catch let error as NSError {
                        print(error)
                        failure(error)
                        return
                    }
                }
            })
            
            dataTask.resume()
            
        }catch {
            print(error)
        }
        
    }
    
    
    
}

extension APIClient{
    
    // MARK: - POST Request
    
    /// Send a post request to server in which parameters will send in rquest boady
    ///
    /// Custamizes method more suitable for current API strecture
    /// - parameter parameters: The parameters. cannot be `nil`.
    /// - parameter sucess:     The sucessClosure whinch invoke in sucessfull request.
    /// - parameter failure:    The failureClosure which invoke in falure request.
    ///
    
    public func inPostReq(method:String, params: [String:Any],sucess:@escaping sucessClosure,failure:@escaping failureClosure){
        
        self.inPostReq(url: BaseUrl.makeUrl(forProduction: false)+method, params: params, sucess: { (response) in
            sucess(response)
        }) { (error) in
            failure(error)
        }
    }
    
    public func inPost(method:String, params:[String:String],sucess:@escaping sucessClosure,failure:@escaping failureClosure){
        
        self.inPost(url: BaseUrl.makeUrl(forProduction: false)+method, params: params, sucess: { (response) in
            sucess(response)
        }) { (error) in
            failure(error)
        }
    }
    
    public func inPostPushNotification(method:String, params:[String:Any],sucess:@escaping sucessClosure,failure:@escaping failureClosure){
        
        self.inPostSentPushnotification(url: BaseUrl.fcmMessageUrl + method, params: params, sucess: { (response) in
            sucess(response)
        }) { (error) in
            failure(error)
        }
    }
    
    
        public func inDelete(method:String, params:[String:String],sucess:@escaping sucessClosure,failure:@escaping failureClosure){
    
            self.inDelete(url: BaseUrl.makeUrl(forProduction: false)+method, params: params, sucess: { (response) in
                sucess(response)
            }) { (error) in
                failure(error)
            }
        }
    
    public func inPut(method:String, params:[String:String],sucess:@escaping sucessClosure,failure:@escaping failureClosure){
        
        inPut(url: BaseUrl.makeUrl(forProduction: false)+method, params: params, sucess: { (response) in
            sucess(response)
        }) { (error) in
            failure(error)
        }
    }
    
    public func inPutWithJsonData(method:String, params:[String:[String:String]],sucess:@escaping sucessClosure,failure:@escaping failureClosure){
        inPutJsonData(url: BaseUrl.makeUrl(forProduction: false)+method, params: params, sucess: { (response) in
            sucess(response)
        }) { (error) in
            failure(error)
        }
    }
    
    public func inPutRawData(method:String, params:[String:Any],sucess:@escaping sucessClosure,failure:@escaping failureClosure){
        print(method,"^^^^^^^method put for upload")
        inPutRawData(url: BaseUrl.makeUrl(forProduction: false)+method, params: params, sucess: { (response) in
            sucess(response)
        }) { (error) in
            failure(error)
        }
    }
    
//    func inPostForImageUpload(params:[String:String],image:UIImage,sucess:@escaping sucessClosure,failure:@escaping failureClosure){
//        inPostForImageUpload(url: BaseUrl.makeUrl(forProduction: false), params: params, image: image, sucess: { (response) in
//            sucess(response)
//        }) { (error) in
//            failure(error)
//        }
//    }
    func inPostForImageUpload(method:String,params:[String:String],image:UIImage,videoDataVal : NSData, sucess:@escaping sucessClosure,failure:@escaping failureClosure){
        
        inPostForImageUpload(url: BaseUrl.makeUrl(forProduction: false)+method, params: params, image: image,videodata: videoDataVal, sucess: { (response) in
            sucess(response)
        }) { (error) in
            failure(error)
        }
    }
    
    
    public func inPostForStr(method:String,params:String,sucess:@escaping sucessClosure,failure:@escaping failureClosure){
        self.inPostForString(url: BaseUrl.makeUrl(forProduction: false)+method, params: params, sucess: { (response) in
            sucess(response)
        }) { (error) in
            failure(error)
        }
    }
    
    public func inPostForPass(method:String, params:[String:String],sucess:@escaping sucessClosure,failure:@escaping failureClosure){
        
        self.inPostForPass(url: BaseUrl.makeUrl(forProduction: false)+method, params: params, sucess: { (response) in
            sucess(response)
        }) { (error) in
            failure(error)
        }
    }
    
    
    
    
}

