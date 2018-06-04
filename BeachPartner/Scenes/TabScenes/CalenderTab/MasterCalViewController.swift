//
//  MasterCalViewController.swift
//  BeachPartner
//
//  Created by Jerry K Mathew on 21/03/18.
//  Copyright © 2018 dev. All rights reserved.
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
                getAllEvents()
            }
            else {
                searchEvents()
            }
        }
    }

    
    // MARK:- Initialization

    override func viewDidLoad() {
        super.viewDidLoad()
//        getAllEvents()
        //Temp
        let token = UserDefaults.standard.string(forKey: "bP_token")
        print(token)
        
        tableHeaderLabel.text = titleForEventTable(date: Date())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController!.navigationBar.topItem!.title = "Master Calendar"
        
        getAllEvents()
    }
    
    
    // MARK:- Methods
    
    private func getAllEvents() {
        
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
    
    func searchEvents() {
        
        guard let params = filterParams else {
            return
        }
        
        ActivityIndicatorView.show("Loading")
        APIManager.callServer.getSearchEvents(filterParams: params, sucessResult: { (responseModel) in
            
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
    
    private func reloadUIWithDatamodel(model: GetEventsRespModelArray) {
        
        self.eventListArray.removeAll()
        self.eventDateArray.removeAll()
        for event in model.getEventsRespModel {
            
            let startDate = Date(timeIntervalSince1970: TimeInterval(event.eventStartDate/1000))
            let endDate = Date(timeIntervalSince1970: TimeInterval(event.eventEndDate/1000))
            print(startDate)
            print(endDate)
            print("---------------------------------------------------")
            
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
    
    
    
    private func titleForEventTable(date: Date) -> String {
        //Eg: Events for 16th November
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        let nameOfMonth = dateFormatter.string(from: date)
        let day = daySuffix(from: date)
        return "Events for " + day + " " + nameOfMonth
    }
    
    // MARK:- Tableview data source & Delegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventListToShow.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "caltablecell"
        
      guard let  cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CalanderTableViewCell
        else {
            fatalError("The dequeued cell is not an instance of ManagSenderTableViewCell.")
        }
      
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
        
//        cell.colorView.backgroundColor = .clear
        print(eventListToShow,"\n\n\n")
//        print("event.eventName    ",event.eventName,"   event.status ",event.eventStaus)
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
