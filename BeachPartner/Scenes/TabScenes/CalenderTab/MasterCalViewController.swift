//
//  MasterCalViewController.swift
//  BeachPartner
//
//  Created by Beach Partner LLC on 21/03/18.
//  Copyright © 2018 Beach Partner LLC. All rights reserved.
//

import UIKit
import FSCalendar

class MasterCalViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FSCalendarDataSource, FSCalendarDelegate   {
    
    enum EventStatus: String {
        case Active = "Active"
        case Deleted = "Deleted"
        case New = "New"
    }
    
    // MARK:-
    @IBOutlet weak var masterCalTableVIew: UITableView!
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var tableHeaderLabel: UILabel!
    @IBOutlet weak var calendarContainerView: UIView!
    @IBOutlet weak var filterLabel: UILabel!
    @IBOutlet weak var filterContainerView: UIView!
    @IBOutlet weak var noEventsFoundLabel: UILabel!
    // MARK:-
    var eventListArray = [GetEventRespModel]()
    var eventListToShow = [GetEventRespModel]()
    var eventDateArray = [String]()
    
    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    fileprivate let gregorian: NSCalendar! = NSCalendar(calendarIdentifier:NSCalendar.Identifier.gregorian)

    var filterParams: EventFilterParams? {
        didSet {
            if filterParams == nil {
                
                filterContainerView.isHidden = true
                getAllEvents()
            }
            else {
                filterContainerView.isHidden = false
                searchEvents()
            }
        }
    }

    
    // MARK:- Initialization

    override func viewDidLoad() {
        super.viewDidLoad()

        noEventsFoundLabel.isHidden = true
        noEventsFoundLabel.textColor = UIColor.white
        
        let token = UserDefaults.standard.string(forKey: "bP_token")
        print(token ?? "")
        
        tableHeaderLabel.text = titleForEventTable(date: Date())
        
        if Subscription.current.supportForFunctionality(featureId: BenefitType.MasterCalendar) == false {
            masterCalTableVIew.isHidden = true
            getAllEvents()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController!.navigationBar.topItem!.title = "Master Calendar"
        
        if Subscription.current.supportForFunctionality(featureId: BenefitType.MasterCalendar) == true {
            if filterParams == nil {
                getAllEvents()
            }
            else {
                searchEvents()
            }
        }
    }
    
    
    // MARK:- Methods
    
    private func getAllEvents() {
        
        calendarContainerView.isHidden = false
        
        ActivityIndicatorView.show("Loading")
        APIManager.callServer.getAllEvents(sucessResult: { (responseModel) in
            
            ActivityIndicatorView.hiding()
            guard let eventsArrayModel = responseModel as? GetEventsRespModelArray else {
                print("Rep model does not match")
                return
            }
            self.reloadUIWithDatamodel(model: eventsArrayModel)
            
        }) { (error) in
            
            ActivityIndicatorView.hiding()
            guard let errorString  = error else {
                return
            }
            self.alert(message: errorString)
        }
    }
    
    func setUpFilterDisplay() {
        
        guard let params = filterParams else {
            return
        }
        
        var filterString = ""
        if let param = params.eventType {
            filterString += "Event Type:\(param) > "
        }
        if let param = params.subEventType {
            filterString += "SubEvent:\(param) > "
        }
        if let param = params.year {
            filterString += "Year:\(param) > "
        }
        if let param = params.month {
            filterString += "Month:\(param) > "
        }
        if let param = params.region {
            filterString += "Region:\(param) > "
        }
        if let param = params.state {
            filterString += "State:\(param) > "
        }
        
        filterLabel.text = filterString
    }
    
    
    func searchEvents() {
        
        calendarContainerView.isHidden = true
        
        
        guard let params = filterParams else {
            return
        }
        
        setUpFilterDisplay()
        
        ActivityIndicatorView.show("Loading")
        APIManager.callServer.getSearchEvents(filterParams: params, sucessResult: { (responseModel) in
            
            ActivityIndicatorView.hiding()
            guard let eventsArrayModel = responseModel as? GetEventsRespModelArray else {
                print("Rep model does not match")
                return
            }
            self.reloadUIWithFilter(model: eventsArrayModel)
            
        }) { (error) in
            ActivityIndicatorView.hiding()
            guard let errorString  = error else {
                return
            }
            self.alert(message: errorString)
        }
    }
    
    private func reloadUIWithDatamodel(model: GetEventsRespModelArray) {
        
        self.eventListArray.removeAll()
        self.eventDateArray.removeAll()
        for event in model.getEventsRespModel {
            
            let startDate = Date(timeIntervalSince1970: TimeInterval(event.eventStartDate/1000))
            let endDate = Date(timeIntervalSince1970: TimeInterval(event.eventEndDate/1000))
            let dates = self.generateDateArrayBetweenTwoDates(startDate: startDate, endDate: endDate)
            self.eventDateArray.append(contentsOf: dates)
            var eventObject = event
            eventObject.activeDates = dates
            self.eventListArray.append(eventObject)
        }
        self.calendar.reloadData()
        if let date = self.calendar.selectedDate {
            self.calendar(self.calendar, didSelect: date, at: .current)
        }
        else {
            self.calendar(self.calendar, didSelect: Date(), at: .current)
        }
    }
    
    private func reloadUIWithFilter(model: GetEventsRespModelArray) {
        
        self.eventListArray.removeAll()
        self.eventDateArray.removeAll()
        for event in model.getEventsRespModel {
            
            let startDate = Date(timeIntervalSince1970: TimeInterval(event.eventStartDate/1000))
            let endDate = Date(timeIntervalSince1970: TimeInterval(event.eventEndDate/1000))
            let dates = self.generateDateArrayBetweenTwoDates(startDate: startDate, endDate: endDate)
            self.eventDateArray.append(contentsOf: dates)
            var eventObject = event
            eventObject.activeDates = dates
            self.eventListArray.append(eventObject)
        }
        self.eventListToShow = self.eventListArray
        print("\n\n\n\n\n\n ",self.eventListToShow,"\n\n",self.eventListToShow.count,"\n\n\n\n\n")
        masterCalTableVIew.reloadData()
    }
    
    
    private func titleForEventTable(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        let nameOfMonth = dateFormatter.string(from: date)
        let day = daySuffix(from: date)
        return "Events for " + day + " " + nameOfMonth
    }
    
    // MARK:- Tableview data source & Delegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if eventListToShow.count == 0 {
            noEventsFoundLabel.isHidden = false
            noEventsFoundLabel.textColor = UIColor.darkGray
            noEventsFoundLabel.text = "No Events Found"
        }
        else {
            noEventsFoundLabel.isHidden = true
            noEventsFoundLabel.textColor = UIColor.white
        }
        return eventListToShow.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "caltablecell"
        
      guard let  cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CalanderTableViewCell
        else {
            fatalError("The dequeued cell is not an instance of ManagSenderTableViewCell.")
        }
      
        cell.selectionStyle = .none
        cell.mainBackground.layer.cornerRadius = 8
        cell.mainBackground.layer.masksToBounds = true
        cell.shadowLayer.layer.masksToBounds = false
        cell.shadowLayer.layer.shadowOffset = CGSize(width: 0, height: 0)
        cell.shadowLayer.layer.shadowColor = UIColor.black.cgColor
        cell.shadowLayer.layer.shadowOpacity = 0.23
        cell.shadowLayer.layer.shadowRadius = 4
        cell.shadowLayer.layer.shadowPath = UIBezierPath(roundedRect: cell.shadowLayer.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 8, height: 8)).cgPath
        cell.shadowLayer.layer.shouldRasterize = true
        cell.shadowLayer.layer.rasterizationScale = UIScreen.main.scale
        let event = eventListToShow[indexPath.row]
        cell.eventNameLbl.text = event.eventName
        
        if event.registerType == "Organizer" {
            cell.invitationTypeImage.image = UIImage(named:"sent1")
            if event.eventStaus == "Registered"{
                cell.colorView.backgroundColor = .green
            }
            else if event.eventStaus == "Invited"{
                cell.colorView.backgroundColor = .orange
            }
            else if event.eventStaus == "Active"{
                cell.colorView.backgroundColor = .orange
            }
            else{
                cell.colorView.backgroundColor = .clear
            }
        }
        else if event.registerType == "Invitee" {
            cell.invitationTypeImage.image = UIImage(named:"received1")
            if event.eventStaus == "Registered"{
                cell.colorView.backgroundColor = .green
            }
            else if event.eventStaus == "Invited"{
                cell.colorView.backgroundColor = .orange
            }
            else if event.eventStaus == "Active"{
                cell.colorView.backgroundColor = .orange
            }
            else{
                cell.colorView.backgroundColor = .clear
            }
        }
        else {
            cell.invitationTypeImage.image = nil
            cell.colorView.backgroundColor = .clear
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyBoard = UIStoryboard(name: "CalenderTab", bundle: nil)
        
        if eventListToShow[indexPath.row].registerType == "Invitee" && eventListToShow[indexPath.row].invitationStatus != "Accepted" {
            let eventId = eventListToShow[indexPath.row].id
            
            let viewController = storyBoard.instantiateViewController(withIdentifier: "InvitationListView") as! EventInvitationListViewController
            viewController.eventId = eventId
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        else {
            let eventDetailsVC = storyBoard.instantiateViewController(withIdentifier: "EventDetailsView") as! EventDetailsViewController
            let event = eventListToShow[indexPath.row]
            print(event)
            eventDetailsVC.event = event
            self.navigationController?.pushViewController(eventDetailsVC, animated: true)
        }
    }
    

    // MARK:- FSCalendar Data source & Delegates
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        print("change page to \(self.formatter.string(from: calendar.currentPage))")
    }
    
    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {

        let selectedDate = formatter.string(from: date)
        let count = eventDateArray.filter { $0 == selectedDate}.count
        
        if count > 0 { return "\(count)" }
        return nil
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        tableHeaderLabel.text = titleForEventTable(date: date)
        
        if Subscription.current.supportForFunctionality(featureId: BenefitType.MasterCalendar) == false {
            
            masterCalTableVIew.isHidden = true
            
            let storyboard = UIStoryboard(name: "Subscription", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: SubscriptionTypeViewController.identifier) as! SubscriptionTypeViewController
            vc.benefitCode = BenefitType.MasterCalendar
            self.present(vc, animated: true, completion: nil)
            return
        }
        
        eventListToShow = eventListArray.filter { (event) -> Bool in
            let selectedDate = formatter.string(from: date)
            return Bool(event.activeDates.contains(selectedDate))
        }
        
        masterCalTableVIew.reloadData()
    }
    
    
    // MARK:- Helper Methods
    
    func generateDateArrayBetweenTwoDates(startDate: Date , endDate:Date) ->[String] {
        
        var datesArray: [String] =  [String]()
        var startDate = startDate
        let calendar = Calendar.current
        
        while startDate <= endDate {
            datesArray.append(formatter.string(from: startDate))
            startDate = calendar.date(byAdding: .day, value: 1, to: startDate)!
        }
        return datesArray
    }
    
    func daySuffix(from date: Date) -> String {
        let calendar = Calendar.current
        let dayOfMonth = calendar.component(.day, from: date)
        switch dayOfMonth {
        case 1, 21, 31: return "\(dayOfMonth)" + "st"
        case 2, 22: return "\(dayOfMonth)" + "nd"
        case 3, 23: return "\(dayOfMonth)" + "rd"
        default: return "\(dayOfMonth)" + "th"
        }
    }
}
