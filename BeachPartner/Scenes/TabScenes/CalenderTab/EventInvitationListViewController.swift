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
    
    var event: GetEventRespModel?
    var eventInvitation: GetEventInvitationRespModel?
    
    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"//Feb 10 2018
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupDate()
        getAllInvitations()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.title = "Invitations"
    }
    
    private func setupDate() {
        guard let event = event else { return }
        
        eventNameLabel.text = event.eventName
        eventStartDateLabel.text = dateStringFromTimeInterval(interval: event.eventStartDate)
        eventEndDateLabel.text = dateStringFromTimeInterval(interval: event.eventEndDate)
    }
    
    private func getAllInvitations() {
        guard let eventId = event?.masterEventId else { return }
        
        ActivityIndicatorView.show("Loading")
        
        APIManager.callServer.getAllEventInvitations(eventId: eventId, calendarType: "mastercalendar", sucessResult: { (responseModel) in
            ActivityIndicatorView.hiding()
            
            guard let eventInvitationModel = responseModel as? GetEventInvitationRespModel else {
                print("Rep model does not match")
                return
            }
            self.eventInvitation = eventInvitationModel
            
            self.tableView.reloadData()
            
        }) { (error) in
            ActivityIndicatorView.hiding()
            guard let errorString  = error else {
                return
            }
            self.alert(message: errorString)
        }
    }
    
    private func responsdToInvitation(action: String, index: Int) {
        
        guard let eventId = eventInvitation?.eventId else { return }
        guard let organiserId = eventInvitation?.invitations?[index].invitorId else { return }
        
        ActivityIndicatorView.show("Loading")
        
        
        APIManager.callServer.respondToInvitation(eventId: eventId, organiserId: organiserId, action: action, sucessResult: { (responseModel) in
            
            ActivityIndicatorView.hiding()
            
            self.navigationController?.popViewController(animated: true)
        }) { (error) in
            
            ActivityIndicatorView.hiding()
            guard let errorString  = error else {
                return
            }
            self.alert(message: errorString)
        }
    }
    
    private func confirmAction(action: String, index: Int) {
        
        let alert = UIAlertController(title: "", message: "Do you really want to \(action) this invitation?", preferredStyle: .alert)
        let action = UIAlertAction(title: "Yes", style: .default, handler: { (handlr) in
            self.responsdToInvitation(action: action, index: index)
        })
        let cancel =  UIAlertAction(title: "No", style: .cancel, handler: nil)
        alert.addAction(action)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let count = eventInvitation?.invitations?.count {
            return count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventInvitationCell", for: indexPath) as? EventInvitationCell
        cell?.selectionStyle = .none
        
        let invitation = eventInvitation?.invitations![indexPath.row]
        
        
        cell?.nameLabel.text = invitation?.invitorName

        if let image = invitation?.invitorimageURL, let imageUrl = URL(string: image) {
            cell?.profileImage.sd_setIndicatorStyle(.whiteLarge)
            cell?.profileImage.sd_setShowActivityIndicatorView(true)
            cell?.profileImage.sd_setImage(with: imageUrl, placeholderImage: #imageLiteral(resourceName: "img_placeHolder"))
        }
        
        cell?.profileImage.layer.cornerRadius = (cell?.profileImage?.frame.size.width)!/2
        cell?.profileImage.clipsToBounds = true
        //            cell?.profileImage.layer.borderColor = UIColor.blue.cgColor
        cell?.profileImage.layer.borderColor = UIColor(red: 41/255.0, green: 56/255.0, blue: 133/255.0, alpha:1.0).cgColor
        cell?.profileImage.layer.borderWidth = 1.5
        
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let acceptAction = UITableViewRowAction(style: .normal, title: "Accept") { (rowAction, indexPath) in
            self.confirmAction(action: "Accept", index: indexPath.row)
        }
        acceptAction.backgroundColor = .blue
        
        let rejectAction = UITableViewRowAction(style: .destructive, title: "Reject") { (rowAction, indexPath) in
           self.confirmAction(action: "Reject", index: indexPath.row)
        }
//        rejectAction.backgroundColor = .red
        return [acceptAction,rejectAction]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    private func dateStringFromTimeInterval(interval: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(interval/1000))
        return formatter.string(from: date)
    }

}
