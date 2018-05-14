//
//  EventInvitationListViewController.swift
//  BeachPartner
//
//  Created by seq-mary on 14/05/18.
//  Copyright © 2018 dev. All rights reserved.
//

import UIKit

class EventInvitationListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventStartDateLabel: UILabel!
    @IBOutlet weak var eventEndDateLabel: UILabel!
    
    
    let numberofCells = 10
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return numberofCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventInvitationCell", for: indexPath) as? EventInvitationCell
        cell?.selectionStyle = .none
        
        cell?.nameLabel.text = "XXXXXXXX"
//
//        if let image = connectedUser?.imageUrl, let imageUrl = URL(string: image) {
//            cell?.profileImage.sd_setIndicatorStyle(.whiteLarge)
//            cell?.profileImage.sd_setShowActivityIndicatorView(true)
//            cell?.profileImage.sd_setImage(with: imageUrl, placeholderImage: #imageLiteral(resourceName: "img_placeHolder"))
//        }
//        
//        cell?.profileImage.layer.cornerRadius = (cell?.profileImage?.frame.size.width)!/2
//        cell?.profileImage.clipsToBounds = true
//        //            cell?.profileImage.layer.borderColor = UIColor.blue.cgColor
//        cell?.profileImage.layer.borderColor = UIColor(red: 41/255.0, green: 56/255.0, blue: 133/255.0, alpha:1.0).cgColor
//        cell?.profileImage.layer.borderWidth = 1.5
        
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let acceptAction = UITableViewRowAction(style: .normal, title: "Accept") { (rowAction, indexPath) in
            //TODO:
        }
        acceptAction.backgroundColor = .blue
        
        let rejectAction = UITableViewRowAction(style: .normal, title: "Reject") { (rowAction, indexPath) in
            //TODO:
        }
        rejectAction.backgroundColor = .red
        
        return [acceptAction,rejectAction]
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
