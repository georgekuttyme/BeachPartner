//
//  PartnerListViewController.swift
//  BeachPartner
//
//  Created by Beach Partner LLC on 16/05/18.
//  Copyright © 2018 Beach Partner LLC. All rights reserved.
//

import UIKit
import InitialsImageView
class PartnerListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noPartnersLbl: UILabel!
    
    var loggedInUserId = 0
    var invitation: EventInvitation?
    
//    var partners: [EventPartner] = [EventPartner]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorColor = UIColor.clear
        if let id = UserDefaults.standard.string(forKey: "bP_userId") {
            self.loggedInUserId =  Int(id)!
        }

    }
    
    @IBAction func didTapDismissButton(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let count = invitation?.partners?.count, count != 0 {
            noPartnersLbl.isHidden = true
            return count
        }
        else {
            noPartnersLbl.isHidden = false
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PartnerListCell", for: indexPath) as? PartnerListCell
        
        if (indexPath.row == (self.invitation?.partners?.count)!-1) {
            cell?.separatorInset = UIEdgeInsetsMake(0.0, (cell?.bounds.size.width)!, 0.0, 0.0);
        }
        cell?.selectionStyle = .none
        print("indexPath.row ->",indexPath.row,"\n\n")
        var index = indexPath.row
        if invitation?.invitorId != loggedInUserId {
            if indexPath.row == 0 {
                
                cell?.nameLabel.text = invitation?.invitorName
                cell?.statusLabel.text = "Organizer"
                let username = invitation?.invitorName
                let image = invitation?.invitorimageURL
                let status = invitation?.inviterStatus
                if status == "Flagged"{
                    cell?.profileImageView.image = UIImage(named:"user")
                }else{
                    if image == "" || image == "null"{
                        cell?.profileImageView.setImageForName(string: username!, circular: true, textAttributes: nil)
                    }
                    else{
                        if let imageUrl = URL(string: (invitation?.invitorimageURL)!) {
                            cell?.profileImageView.sd_setIndicatorStyle(.whiteLarge)
                            cell?.profileImageView.sd_setShowActivityIndicatorView(true)
                            cell?.profileImageView.sd_setImage(with: imageUrl, placeholderImage: #imageLiteral(resourceName: "user"))
                        }
                    }
                }
                cell?.profileImageView.layer.cornerRadius = (cell?.profileImageView?.frame.size.width)!/2
                cell?.profileImageView.clipsToBounds = true
                cell?.profileImageView.layer.borderColor = UIColor.navigationBarTintColor.cgColor
                cell?.profileImageView.layer.borderWidth = 1.5
                
            }
            else {
                
                var partner = invitation?.partners![index - 1]
                if partner?.partnerId == loggedInUserId {
                    partner = invitation?.partners![(invitation?.partners?.count)!-1]
                    cell?.nameLabel.text = partner?.partnerName
                    cell?.statusLabel.text = partner?.invitationStatus
                    print("index->",indexPath.row,"  ",index,"\n\n")
                    let username = partner?.partnerName
                    let image = partner?.partnerImageURL
                    let status = partner?.partnerStatus
                    if status == "Flagged"{
                        cell?.profileImageView.image = UIImage(named:"user")
                    }else{
                        if image == "" || image == "null"{
                            cell?.profileImageView.setImageForName(string: username!, circular: true, textAttributes: nil)
                        }else{
                            if let imageUrl = URL(string: (partner?.partnerImageURL)!) {
                                cell?.profileImageView.sd_setIndicatorStyle(.whiteLarge)
                                cell?.profileImageView.sd_setShowActivityIndicatorView(true)
                                cell?.profileImageView.sd_setImage(with: imageUrl, placeholderImage: #imageLiteral(resourceName: "user"))
                            }
                        }
                    }
                    cell?.profileImageView.layer.cornerRadius = (cell?.profileImageView?.frame.size.width)!/2
                    cell?.profileImageView.clipsToBounds = true
                    cell?.profileImageView.layer.borderColor = UIColor.navigationBarTintColor.cgColor
                    cell?.profileImageView.layer.borderWidth = 1.5
                }
                else {
                    cell?.nameLabel.text = partner?.partnerName
                    cell?.statusLabel.text = partner?.invitationStatus
                    print("index->",indexPath.row,"  ",index,"\n\n")
                    let username = partner?.partnerName
                    let image = partner?.partnerImageURL
                    let status = partner?.partnerStatus
                    if status == "Flagged"{
                        cell?.profileImageView.image = UIImage(named:"user")
                    }else{
                        if image == "" || image == "null"{
                            cell?.profileImageView.setImageForName(string: username!, circular: true, textAttributes: nil)
                        }else{
                            if let imageUrl = URL(string: (partner?.partnerImageURL)!) {
                                cell?.profileImageView.sd_setIndicatorStyle(.whiteLarge)
                                cell?.profileImageView.sd_setShowActivityIndicatorView(true)
                                cell?.profileImageView.sd_setImage(with: imageUrl, placeholderImage: #imageLiteral(resourceName: "user"))
                            }
                        }
                    }
                    cell?.profileImageView.layer.cornerRadius = (cell?.profileImageView?.frame.size.width)!/2
                    cell?.profileImageView.clipsToBounds = true
                    cell?.profileImageView.layer.borderColor = UIColor.navigationBarTintColor.cgColor
                    cell?.profileImageView.layer.borderWidth = 1.5
                }
                
            }
        }
        else{
            print("index->",indexPath.row,"  ",index,"\n\n")
            if let partner = invitation?.partners![index]{
                cell?.nameLabel.text = partner.partnerName
                cell?.statusLabel.text = partner.invitationStatus
                let username = partner.partnerName
                let image = partner.partnerImageURL
                let status = partner.partnerStatus
                if status == "Flagged"{
                    cell?.profileImageView.image = UIImage(named:"user")
                }else{
                    if image == "" || image == "null"{
                        cell?.profileImageView.setImageForName(string: username, circular: true, textAttributes: nil)
                    }else{
                        if let imageUrl = URL(string: (partner.partnerImageURL)) {
                            cell?.profileImageView.sd_setIndicatorStyle(.whiteLarge)
                            cell?.profileImageView.sd_setShowActivityIndicatorView(true)
                            cell?.profileImageView.sd_setImage(with: imageUrl, placeholderImage: #imageLiteral(resourceName: "user"))
                        }
                    }
                }
                cell?.profileImageView.layer.cornerRadius = (cell?.profileImageView?.frame.size.width)!/2
                cell?.profileImageView.clipsToBounds = true
                cell?.profileImageView.layer.borderColor = UIColor.navigationBarTintColor.cgColor
                cell?.profileImageView.layer.borderWidth = 1.5
            }
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    
}
