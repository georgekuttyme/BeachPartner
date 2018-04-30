//
//  APIConstants.swift
//  BeachPartner
//
//  Created by Jerry K Mathew on 26/03/18.
//  Copyright © 2018 dev. All rights reserved.
//

import Foundation


class BaseUrl {
    //    dev1.singx.co:8444
    //    http://34.215.18.181:8080/swagger/index.html#/
    static let developmentUrl =  "http://beachpartner.com:8080/api"
    static let productionUrl  = "http://beachpartner.com:8080/api"
    static let fcmbaseUrl = "https://beachpartner-6cd7a.firebaseio.com"
    //http://34.215.18.181:8080/api
    class func makeUrl(forProduction:Bool) -> String {
        if forProduction {
            return developmentUrl
        }else{
            return developmentUrl
        }
    }

    class func makeFcmUrl() -> String
    {
        return fcmbaseUrl
    }
}
struct ApiMethods {
    static let CREATE_NOTE   =   "notes/"
    static let GETALL_NOTE_FROM   =  "notes/from/"
    static let DELETE_NOTE     =   "notes/"
    static let UPDATE_NOTE     =   "notes/"
    static let device_UUID = UIDevice.current.identifierForVendor!.uuidString
    static let LoginFb = "/authenticate-with-token"
    static let Registation    = "/register"
    static let Login    = "/authenticate"
    static let ReqPasswrodReset = "/account/reset-password/init"
    static let ResetPasswordFinish = "/account/reset-password/finish"
    static let ChangePassword = "/account/change-password"
    static let GetAccountDetails    = "/account"
    static let SaveAccountDetails    = "/account"
    static let GetAllEvents    = "/events/all"
    static let ResetNewPassword = "/account/reset-password/finish"
    static let GetUserEvents    = "/events/user"
    static let GetAllUserEventsBetween = "/events/user/between"
    static let GetBlockedUser = "/users/block-user"
    static let UnBlockUser = "/users/unblock-user"
    static let AddProfileVideoImage = "/storage/uploadProfileData"
    static let updateUserDetails = "/users"
    static let getSubscription  = "/users/subscriptions"
    static let getSearch  = "/users/search"
    static let GetAllConnections = "/users/connected"
    static let GetConnectedusersCount = "/users/connected-count"
    static let fcmMessages  = "/messages"
    static let sendFriendRequest  = "/users/request-friendship/"
    static let rejectFriendRequest  = "/users/reject-friendship/"
    static let sendHiFiRequest  = "/users/hifi/"
    static let updateAllUserDetails = "/users/update-all"
    
    //    static let Login   = "/secure/Authentication/authenticate"
    static let findById   = "/secure/CustomerType/findById"
    static let contactsFindById   = "/secure/SingxContacts/findById"
    static let indivProfStatus   = "/secure/IndividualProfileStatusServiceWS/individualProfileStatus"
    static let getExchangeRatePostLogin   = "/secure/ExchangeRateWS/getExchangeRates"
    static let getExchangeRate   = "/secure/CommonRestServiceImpl/getExchangeRates?"
    
    
    static let getReceiverAccList   = "/secure/ReceiverAccountDetailServiceWS/getReceiverAccList"
    
    static let getSenderList   = "/secure/CustomerBankAccount/getCustomerAccDetails"
    
    static let getCustomerbankaccounts   = "/secure/Bank/findByCountryIdWiredTransferId"
    
    static let addNewSender   = "/secure/CustomerBankAccount/save"
    
    static let updateSender   = "/secure/CustomerBankAccount"
    
    static let findAllCountries   = "/secure/Country/findAll"
    
    static let transferPurpose   = "/secure/TransferPurpose/findAll"
    
    static let getotp   = "/secure/TransactionInfo/getOtp"
    
    static let resendotp   = "/secure/TransactionInfo/getOtpReceiver"
    
    
    
    static let findByFromToCountryId   = "/secure/Corridor/FindByFromToCountryId/"
    
    static let transferEnquirySaveVal   = "/secure/TransferEnquiry/save"
    
    static let fundRecvSave   = "/secure/FundReceiver/save"
    
    static let recvAccFindById   = "/secure/RecceiverAccount/findById"
    
    static let transactionInfoSave   = "/secure/TransactionInfo/save"
    
    
    static let bankByCountryid   = "/secure/Bank/findByCountryId"
    
    static let branchbyIFSC   = "/secure/BankBranch/findByIFSCCode"
    
    static let recvAccSave   = "/secure/RecceiverAccount/save"
    
    static let branchByBankId   = "/secure/BankBranch/findByBankId"
    
    static let findAllNationality   = "/secure/CommonRestServiceImpl/findAllNationality"
    
    static let transHistory   = "/secure/queryExecutor/getData"
    
    static let cancelTransaction   = "/secure/TransferEnquiry/cancel"
    
    
}
struct ApiResponseStatus {
    
    static let sucess   =  1
    static let failed   =  0
}

