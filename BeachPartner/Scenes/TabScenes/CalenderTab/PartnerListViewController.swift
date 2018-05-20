//
//  PartnerListViewController.swift
//  BeachPartner
//
//  Created by seq-mary on 16/05/18.
//  Copyright © 2018 dev. All rights reserved.
//

import UIKit

class PartnerListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var loggedInUserId = 0
    var invitation: EventInvitation?
    
//    var partners: [EventPartner] = [EventPartner]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let id = UserDefaults.standard.string(forKey: "bP_userId") {
            self.loggedInUserId =  Int(id)!
        }

    }
    
    @IBAction func didTapDismissButton(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let count = invitation?.partners?.count {
            return count 
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PartnerListCell", for: indexPath) as? PartnerListCell
        cell?.selectionStyle = .none
        print("indexPath.row ->",indexPath.row,"\n\n")
        var index = indexPath.row
        if invitation?.invitorId != loggedInUserId {
            if indexPath.row == 0 {
                
                cell?.nameLabel.text = invitation?.invitorName
                cell?.statusLabel.text = "Organizer"
                
                if let imageUrl = URL(string: (invitation?.invitorimageURL)!) {
                    cell?.profileImageView.sd_setIndicatorStyle(.whiteLarge)
                    cell?.profileImageView.sd_setShowActivityIndicatorView(true)
                    cell?.profileImageView.sd_setImage(with: imageUrl, placeholderImage: #imageLiteral(resourceName: "user"))
                }
                cell?.profileImageView.layer.cornerRadius = (cell?.profileImageView?.frame.size.width)!/2
                cell?.profileImageView.clipsToBounds = true
                //            cell?.profileImage.layer.borderColor = UIColor.blue.cgColor
                cell?.profileImageView.layer.borderColor = UIColor(red: 41/255.0, green: 56/255.0, blue: 133/255.0, alpha:1.0).cgColor
                cell?.profileImageView.layer.borderWidth = 1.5
                
            }
            else {
                
                var partner = invitation?.partners![index - 1]
                if partner?.partnerId == loggedInUserId {
                    partner = invitation?.partners![index]
                    cell?.nameLabel.text = partner?.partnerName
                    cell?.statusLabel.text = partner?.invitationStatus
                    print("index->",indexPath.row,"  ",index,"\n\n")
                    if let imageUrl = URL(string: (partner?.partnerImageURL)!) {
                        cell?.profileImageView.sd_setIndicatorStyle(.whiteLarge)
                        cell?.profileImageView.sd_setShowActivityIndicatorView(true)
                        cell?.profileImageView.sd_setImage(with: imageUrl, placeholderImage: #imageLiteral(resourceName: "user"))
                    }
                    cell?.profileImageView.layer.cornerRadius = (cell?.profileImageView?.frame.size.width)!/2
                    cell?.profileImageView.clipsToBounds = true
                    //            cell?.profileImage.layer.borderColor = UIColor.blue.cgColor
                    cell?.profileImageView.layer.borderColor = UIColor(red: 41/255.0, green: 56/255.0, blue: 133/255.0, alpha:1.0).cgColor
                    cell?.profileImageView.layer.borderWidth = 1.5
                }
                else {
                    cell?.nameLabel.text = partner?.partnerName
                    cell?.statusLabel.text = partner?.invitationStatus
                    print("index->",indexPath.row,"  ",index,"\n\n")
                    if let imageUrl = URL(string: (partner?.partnerImageURL)!) {
                        cell?.profileImageView.sd_setIndicatorStyle(.whiteLarge)
                        cell?.profileImageView.sd_setShowActivityIndicatorView(true)
                        cell?.profileImageView.sd_setImage(with: imageUrl, placeholderImage: #imageLiteral(resourceName: "user"))
                    }
                    cell?.profileImageView.layer.cornerRadius = (cell?.profileImageView?.frame.size.width)!/2
                    cell?.profileImageView.clipsToBounds = true
                    //            cell?.profileImage.layer.borderColor = UIColor.blue.cgColor
                    cell?.profileImageView.layer.borderColor = UIColor(red: 41/255.0, green: 56/255.0, blue: 133/255.0, alpha:1.0).cgColor
                    cell?.profileImageView.layer.borderWidth = 1.5
                }
                
            }
        }
        else{
            print("index->",indexPath.row,"  ",index,"\n\n")
            if let partner = invitation?.partners![index]{
                cell?.nameLabel.text = partner.partnerName
                cell?.statusLabel.text = partner.invitationStatus
                
                if let imageUrl = URL(string: (partner.partnerImageURL)) {
                    cell?.profileImageView.sd_setIndicatorStyle(.whiteLarge)
                    cell?.profileImageView.sd_setShowActivityIndicatorView(true)
                    cell?.profileImageView.sd_setImage(with: imageUrl, placeholderImage: #imageLiteral(resourceName: "user"))
                }
                cell?.profileImageView.layer.cornerRadius = (cell?.profileImageView?.frame.size.width)!/2
                cell?.profileImageView.clipsToBounds = true
                //            cell?.profileImage.layer.borderColor = UIColor.blue.cgColor
                cell?.profileImageView.layer.borderColor = UIColor(red: 41/255.0, green: 56/255.0, blue: 133/255.0, alpha:1.0).cgColor
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
