//
//  Subscription.swift
//  BeachPartner
//
//  Created by Beach Partner LLC on 06/06/18.
//  Copyright © 2018 Beach Partner LLC. All rights reserved.
//

import Foundation

class Subscription {
    
    static let current = Subscription()
    var subscriptionPlans: [SubscriptionPlanModel]?
    var addonPlans: [SubscriptionPlanModel]?
    var activeSubscriptionPlan: ActiveSubscription?
    var activeAddonPlans: [ActiveSubscription]?
    
    
    func getAllSubscriptionPlans() {
        
        ActivityIndicatorView.show("Loading...")
        APIManager.callServer.getAllSubscriptionPlans(sucessResult: { (responseModel) in
            ActivityIndicatorView.hiding()
            guard let subscriptionPlansModel = responseModel as? GetSubscriptionPlansRespModelArray else {
                print("Rep model does not match")
                return
            }
            self.subscriptionPlans = subscriptionPlansModel.subscriptionPlans
        }) { (errorMessage) in
            
        }
    }
    
    func getUsersActivePlans() {
        
        ActivityIndicatorView.show("Loading...")
        APIManager.callServer.getUsersActivePlans(sucessResult: { (responseModel) in
            guard let activeSubscriptionPlansModel = responseModel as? GetUserSubscriptionModel else {
                print("Rep model does not match")
                return
            }
            self.activeSubscriptionPlan = activeSubscriptionPlansModel.subscriptions.first
            self.activeAddonPlans = activeSubscriptionPlansModel.addons
            
        }) { (errorMessage) in
            
        }
    }
    
    func statusOfAddOn(addOnId: String) -> Bool {
        let status = activeAddonPlans?.contains(where: { $0.planName == addOnId })
        return status ?? false
    }
    
    func supportForFunctionality(featureId: String) -> Bool {
        guard let currentPlan = getCurrentPlan() else { return false }
        
        return currentPlan.benefits.contains { (benefit) -> Bool in
            
            if benefit.code == featureId {
                if benefit.status == "Limited" || benefit.status == "Available" {
                    return true
                }
            }
            return false
        }
    }
    
    private func getCurrentPlan() -> SubscriptionPlanModel? {
        guard let planId = activeSubscriptionPlan?.planName else { return nil }
        
        let plans = self.subscriptionPlans?.filter({ (plan) -> Bool in
            return Bool(plan.code == planId)
        })
        
        if let plans = plans, plans.count > 0 {
            return plans.first
        }
        return nil
    }
}

struct BenefitType {
    static let SwipeAction = "B1"
    static let SwipeVisibility = "B2"
    static let HighFives = "B3"
    static let Connections = "B4"
    static let Chat = "B5"
    static let MasterCalendar = "B6"
    static let MyCalendar = "B7"
    static let UpcomingTournaments = "B8"
    static let EventInvitation = "B9"
    static let EventSearch = "B10"
    static let CourtNotification = "B11"
    static let PartnerRequest = "B12"
    static let ProfileBoost = "B13"
    static let PlayerLikeVisibility = "B14"
    static let CoachLikeVisibility = "B15"
    static let PassportSearch = "B16"
    static let UndoSwipe = "B17"
}

struct AddOnType {
    static let ProfileBoost = "BOOST_BLUE_BP"
    static let TempPassport = "TEMP_PASSPORT"
}
