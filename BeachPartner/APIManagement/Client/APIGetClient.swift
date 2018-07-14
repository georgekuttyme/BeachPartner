//
//  APIGetClient.swift
//  BeachPartner
//
//  Created by Beach Partner LLC on 26/03/18.
//  Copyright © 2018 Beach Partner LLC. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
final class APIGetClient{
    
    typealias sucessClosure = (_ result: NSDictionary?) -> Void
    
    typealias sucessClosureOfArray = (_ result: NSArray?) -> Void
   
    typealias failureClosure = (_ error: Error?) -> Void
    //    static  let doRequest = APIClient()
    static  let doGetRequest = APIGetClient()
    
    private var sessionManager = Alamofire.SessionManager.default
    
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
    
    public func inPost(url:String,params:[String:String],sucess:@escaping sucessClosure, failure:@escaping failureClosure){
        
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        do{
            print("inside do")
            let headers = [
                "Content-Type": "application/json",
                "Cache-Control": "no-cache",
                ]
            let parameters = params
            
            let postData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            
            let request = NSMutableURLRequest(url: NSURL(string: url)! as URL,
                                              cachePolicy: .useProtocolCachePolicy,
                                              timeoutInterval: 10.0)
            request.httpMethod = "POST"
            request.allHTTPHeaderFields = headers
            request.httpBody = postData as Data
            request.timeoutInterval = 10
            //            request.retr\\\
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
    
    
    
    // MARK: - PUT Request
    
    /// Send a post request to server in which parameters will send in rquest boady
    ///
    /// - parameter url:        The URL.
    /// - parameter parameters: The parameters. cannot be `nil`.
    /// - parameter sucess:     The sucessClosure whinch invoke in sucessfull request.
    /// - parameter failure:    The failureClosure which invoke in falure request.
    ///
    
    public func inPut(url:String,params:[String:String],sucess:@escaping sucessClosure,failure:@escaping failureClosure){
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        
        print("####### API Request ....url :", url, "\n #### parameters :", params)
        
        //        let cookie = HTTPCookieStorage.shared.cookies
        let cookieJar = HTTPCookieStorage.shared
        print("\n ####### Request cookie...elements : ", cookieJar.cookies?.count as Any , "\n")
        
        for cookie in cookieJar.cookies! {
            print(cookie.name+"="+cookie.value)
        }
        
        let headders: HTTPHeaders = [
            "Accept": "application/json, text/plain, */*",
            "Content-Type" :"application/json"
        ]
        
        let postRequest = sessionManager.request(url, method: .put, parameters: params as [String:Any], encoding: JSONEncoding.default, headers: headders)
        
        
        
        postRequest.responseJSON { (responseObject) in
            //            print("respobjj :",responseObject)
            
            print("####### API response :", responseObject,"\n")
            
            let cookieJar = HTTPCookieStorage.shared
            
            print("# Cookie data count :", cookieJar.cookies?.count as Any)
            
            for cookie in cookieJar.cookies! {
                print(cookie.name+"="+cookie.value)
            }
            print("_________________________________________________\n\n\n")
            
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            switch  responseObject.result {
            case .success:
                
                
                //                print("Cookie data :",HTTPCookieStorage.shared.cookies! , " ### END !")
                
                
                let json = responseObject.result.value
                //                print("resppppp : ", json!);
                
                //                var data: Data = JSON.data(using: .utf8)!
                //                let anyObj = try! JSONSerialization.jsonObject(with: data, options: .allowFragments)
                //
                //
                //                let str = json.replacingOccurrences(of: "\\", with: "", options: .regularExpression, range: nil)
                //                print(str)
                
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
    
    
    
    // MARK: - GET Request
    
    /// Send a get request to server.
    ///
    /// - parameter url:        The URL.
    /// - parameter parameters: The parameters. cannot be `nil` but may empty.
    /// - parameter sucess:     The sucessClosure whinch invoke in sucessfull request.
    /// - parameter failure:    The failureClosure which invoke in falure request.
    ///
    
    public func inGetReqForArr(url:String,params:[String:String],sucess:@escaping sucessClosureOfArray,failure:@escaping failureClosure){
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        print("####### API Request ....url :", url, "\n #### parameters :", params)
        
        //        sessionManager.session.
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10 // seconds
        configuration.timeoutIntervalForResource = 10
        
        var sessionManagerNew = Alamofire.SessionManager(configuration: configuration)
        
        //        var sessionManagerNew = Alamofire.SessionManager.default
        
        
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
        
        let getRequest = sessionManagerNew.request(url, method: .get, parameters: params, encoding: JSONEncoding.default, headers: headders)
        
        print(headders)
        print(url)
        print(params)
        
        getRequest.responseJSON { (responseObject) in
            
            print("####### API response 222222222:", responseObject,"\n")
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            switch  responseObject.result {
            case .success:
                let status = responseObject.response?.statusCode
                if status == 200{
                    let json = responseObject.result.value
                    sucess(json as! NSArray?)
                }
                
                sessionManagerNew.session.flush {
                    
                }
                
                return
            case .failure:
                let error = responseObject.result.error
                failure(error)
                sessionManagerNew.session.flush {
                    
                }
                
                return
            }
        }
        
    }
    
    
    public func inGetReqForArray(url:String,params:[String:String],sucess:@escaping sucessClosureOfArray,failure:@escaping failureClosure){
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        print("####### API Request ....url :", url, "\n #### parameters :", params)
        
        //        sessionManager.session.
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10 // seconds
        configuration.timeoutIntervalForResource = 10
        
        var sessionManagerNew = Alamofire.SessionManager(configuration: configuration)
        
        //        var sessionManagerNew = Alamofire.SessionManager.default
        
        
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
        
        let getRequest = sessionManagerNew.request(url, method: .get, parameters: params, encoding: JSONEncoding.default, headers: headders)
        
        
        getRequest.responseJSON { (responseObject) in
            
            print("####### API response :", responseObject,"\n")
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            switch  responseObject.result {
            case .success:
                
                let status = responseObject.response?.statusCode
                if status == 200 {
                    let json = responseObject.result.value
                    sucess(json as! NSArray?)
                }else{
                    ActivityIndicatorView.hiding()
                }
                sessionManagerNew.session.flush {
                    
                }
                
                return
            case .failure:
                let error = responseObject.result.error
                failure(error)
                sessionManagerNew.session.flush {
                    
                }
                
                return
            }
        }
        
    }
    
    public func inGetReq(url:String,params:[String:String],sucess:@escaping sucessClosure,failure:@escaping failureClosure){
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        print("####### API Request ....url :", url, "\n #### parameters :", params)
        
        //        sessionManager.session.
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10 // seconds
        configuration.timeoutIntervalForResource = 10
        
        let sessionManagerNew = Alamofire.SessionManager(configuration: configuration)
        
        //        var sessionManagerNew = Alamofire.SessionManager.default
        
        
        var token = UserDefaults.standard.string(forKey: "bP_token") ?? ""
        if url.contains("firebaseio.com"){
            token = ""
        }
        
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
        
        let getRequest = sessionManagerNew.request(url, method: .get, parameters: params, encoding: JSONEncoding.default, headers: headders)
        
        
        getRequest.responseJSON { (responseObject) in
            
            print("####### API response :", responseObject,"\n")
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            switch  responseObject.result {
            case .success:
                let json = responseObject.result.value

                sucess(json as! NSDictionary?)
                sessionManagerNew.session.flush {
                    
                }
                
                return
            case .failure:
                let error = responseObject.result.error
                failure(error)
                sessionManagerNew.session.flush {
                    
                }
                
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
    public func inPostRespArray(url:String,params:[String:Any],sucess:@escaping sucessClosure, failure:@escaping failureClosure){
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        print("####### API Request ....url :", url, "\n #### parameters :", params)
        let cookieJar = HTTPCookieStorage.shared
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
        
        let postRequest = self.sessionManager.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers:headders
        )
        print("####### API response String :", postRequest.responseString,"\n")
        postRequest.responseJSON { (responseObject) in
            print("####### API response :", responseObject,"\n")
            let cookieJar = HTTPCookieStorage.shared
            for cookie in cookieJar.cookies! {
                print(cookie.name+"="+cookie.value)
            }
            print("_________________________________________________\n\n\n")
            
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            switch  responseObject.result {
            case .success:
                let json = responseObject.result.value
                print("\n\n\n search response - >",json)
                sucess(json as! NSDictionary)
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
    
}

extension APIGetClient{
    
    // MARK: - POST Request
    
    /// Send a post request to server in which parameters will send in rquest boady
    ///
    /// Custamizes method more suitable for current API strecture
    /// - parameter parameters: The parameters. cannot be `nil`.
    /// - parameter sucess:     The sucessClosure whinch invoke in sucessfull request.
    /// - parameter failure:    The failureClosure which invoke in falure request.
    ///
    
//    public func inPostReq(method:String, params: [String:Any],sucess:@escaping sucessClosure,failure:@escaping failureClosure){
//
//        self.inPostReq(url: BaseUrl.makeUrl(forProduction: false)+method, params: params, sucess: { (response) in
//            sucess(response)
//        }) { (error) in
//            failure(error)
//        }
//    }
//
//    public func inPost(method:String, params:[String:String],sucess:@escaping sucessClosure,failure:@escaping failureClosure){
//
//        self.inPost(url: BaseUrl.makeUrl(forProduction: false)+method, params: params, sucess: { (response) in
//            sucess(response)
//        }) { (error) in
//            failure(error)
//        }
//    }
//
    public func inGet(method:String, params:[String:String],sucess:@escaping sucessClosure,failure:@escaping failureClosure){
        
        self.inGetReq(url: BaseUrl.makeUrl(forProduction: false)+method, params: params, sucess: { (response) in
            sucess(response)
        }) { (error) in
            failure(error)
        }
    }
    
    public func inGetReqForArray(method:String, params:[String:String],sucess:@escaping sucessClosureOfArray,failure:@escaping failureClosure){
        
        self.inGetReqForArray(url: BaseUrl.makeUrl(forProduction: false)+method, params: params, sucess: { (response) in
            sucess(response)
        }) { (error) in
            failure(error)
        }
    }
    public func inGetReqForArr(method:String, params:[String:String],sucess:@escaping sucessClosureOfArray,failure:@escaping failureClosure){
        
        self.inGetReqForArr(url: BaseUrl.makeUrl(forProduction: false)+method, params: params, sucess: { (response) in
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
    
//    func inPostForImageUpload(params:[String:String],image:UIImage,sucess:@escaping sucessClosure,failure:@escaping failureClosure){
//        inPostForImageUpload(url: BaseUrl.makeUrl(forProduction: false), params: params, image: image, sucess: { (response) in
//            sucess(response)
//        }) { (error) in
//            failure(error)
//        }
//    }
    
    public func inGetFcmMessages(method:String, params:[String:String],sucess:@escaping sucessClosure,failure:@escaping failureClosure){
        self.inGetReq(url: BaseUrl.fcmbaseUrl+method, params: params, sucess: { (response) in
            sucess(response)
        }) { (error) in
            failure(error)
        }
    }
    
    public func inPostRespArray(method:String, params: [String:Any],sucess:@escaping sucessClosure,failure:@escaping failureClosure){
        
        self.inPostRespArray(url: BaseUrl.makeUrl(forProduction: false)+method, params: params, sucess: { (response) in
            sucess(response)
        }) { (error) in
            failure(error)
        }
    }

}


