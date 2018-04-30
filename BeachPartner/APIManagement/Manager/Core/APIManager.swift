//
//  APIManager.swift
//  BeachPartner
//
//  Created by Jerry K Mathew on 26/03/18.
//  Copyright © 2018 dev. All rights reserved.
//

import Foundation
import UIKit
import Tailor
struct BusyScreen {
    let isShow:Bool
    let text:String
}
typealias resultClosure  = (_ result: SafeMappable?) -> Void
//typealias resultArray[Any] = []
typealias sucessClosureOfArray = (_ result: NSArray?) -> Void
typealias errorClosure   = (_ error: String?) -> Void
typealias JSONDictionary =   [String : Any]
class APIManager {
    
    static let callServer = APIManager()
    
    var busy:BusyScreen?
    private init() {
        
    }
    public class func callServer(withBusy busy:BusyScreen) -> APIManager {
        APIManager.callServer.busy = busy
        return APIManager.callServer
    }
    
    func busyOn(){
        guard let busy = self.busy else {
            return
        }
        if busy.isShow {
            ActivityIndicatorView.show(busy.text)
        }
        
    }
    
    func busyOff(){
        
        if ActivityIndicatorView.isOnScreen() {
            ActivityIndicatorView.hiding()
        }
    }
    
    class func printOnDebug(function: String = #function,response:Any)  {
        #if DEBUG
            //            print("function:\(function) \n response:\(response)")
        #endif
    }
    
    
}
protocol WebServiceManagement {
    
}

