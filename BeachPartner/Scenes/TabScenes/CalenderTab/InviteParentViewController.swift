//
//  InviteParentViewController.swift
//  BeachPartner
//
//  Created by Jerry K Mathew on 30/03/18.
//  Copyright © 2018 dev. All rights reserved.
//

import UIKit
import XLPagerTabStrip

protocol InviteParentViewControllerDelegate {
    
    func successfullyInvitedPartners(sender: UIViewController)
}

class InviteParentViewController: ButtonBarPagerTabStripViewController {
    
    
    var event: GetEventRespModel?
    var eventInvitation: GetEventInvitationRespModel?

    var delegate1: InviteParentViewControllerDelegate?
    
    //    let purpleInspireColor = UIColor(red:0.13, green:0.03, blue:0.25, alpha:1.0)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*   settings.style.buttonBarBackgroundColor = UIColor(rgb: 0x20307F)
         settings.style.buttonBarItemBackgroundColor = UIColor(rgb: 0x20307F)
         settings.style.selectedBarBackgroundColor = UIColor(rgb: 0x20307F)
         
         settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 14)
         settings.style.selectedBarHeight = 2.0
         settings.style.buttonBarMinimumLineSpacing = 0
         
         settings.style.buttonBarItemTitleColor = .white
         settings.style.buttonBarItemsShouldFillAvailiableWidth = true
         
         settings.style.buttonBarLeftContentInset = 0
         settings.style.buttonBarRightContentInset = 0
         
         changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
         guard changeCurrentIndex == true else { return }
         oldCell?.label.textColor = .white
         newCell?.label.textColor = .white
         
         }
         */
        
        buttonBarView.selectedBar.backgroundColor = .white
        buttonBarView.backgroundColor = UIColor(rgb: 0x20307F)
        settings.style.buttonBarItemBackgroundColor = UIColor(rgb: 0x20307F)
        settings.style.buttonBarItemFont = .systemFont(ofSize: 14)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        if let name = event?.eventName ?? eventInvitation?.eventName {
            self.navigationItem.title = name
        }
    }

    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let child_1 = UIStoryboard(name: "CalenderTab", bundle: nil).instantiateViewController(withIdentifier: "invitePartner") as! InvitePartnerViewController
        child_1.event = self.event
        child_1.eventInvitation = self.eventInvitation
        child_1.delgate = self
        
        let child_2 = UIStoryboard(name: "TabBar", bundle: nil).instantiateViewController(withIdentifier: "partnerFinder") as! BPfinderViewController
        child_2.selectedCardType = "invitePartner"
        return [child_1, child_2]
    }
}

extension InviteParentViewController: InvitePartnerViewControllerDelegate {
    
    func successfullyInvitedPartners(sender: UIViewController) {
        self.navigationController?.popViewController(animated: false)
        delegate1?.successfullyInvitedPartners(sender: self)
    }
}

