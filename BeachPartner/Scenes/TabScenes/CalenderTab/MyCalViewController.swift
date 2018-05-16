//
//  MyCalViewController.swift
//  BeachPartner
//
//  Created by Jerry K Mathew on 23/03/18.
//  Copyright © 2018 dev. All rights reserved.
//

import UIKit
import FSCalendar

class MyCalViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FSCalendarDataSource, FSCalendarDelegate   {
    
    @IBOutlet weak var MyCalTableVIew: UITableView!
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var tableHeaderLabel: UILabel!
    
    var eventListArray = [GetAllUserEventsRespModel.Event?]()
    var eventListToShow = [GetAllUserEventsRespModel.Event?]()
    var eventDateArray = [String]()
    
    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    fileprivate let gregorian: NSCalendar! = NSCalendar(calendarIdentifier:NSCalendar.Identifier.gregorian)
    
    // MARK:- Tableview data source & Delegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventListToShow.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "caltablecell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CalanderTableViewCell  else {
            fatalError("The dequeued cell is not an instance of ManagSenderTableViewCell.")
        }
        cell.selectionStyle = .none
        print(eventListToShow)
        let event = eventListToShow[indexPath.row]
        cell.eventNameLbl.text = event?.eventName
        
        cell.colorView.backgroundColor = .clear
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyBoard = UIStoryboard(name: "CalenderTab", bundle: nil)
        let eventDetailsVC = storyBoard.instantiateViewController(withIdentifier: "EventDetailsView") as! EventDetailsViewController
        //        eventDetailsVC.event = eventListToShow[indexPath.row]
        self.navigationController?.pushViewController(eventDetailsVC, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getAllUserEvents()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableHeaderLabel.text = titleForEventTable(date: Date())
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    private func getAllUserEvents() {
        
        ActivityIndicatorView.show("Loading")
        APIManager.callServer.getAllUserEvents(sucessResult: { (responseModel) in
            
            ActivityIndicatorView.hiding()
            guard let eventsArrayModel = responseModel as? GetAllUserEventsRespModelArray else {
                print("Rep model does not match")
                return
            }
            print("",eventsArrayModel,"*......*********")
            self.eventListArray.removeAll()
            self.eventDateArray.removeAll()
            for event in eventsArrayModel.getAllUserEventsRespModel{
                
                let startDate = Date(timeIntervalSince1970: TimeInterval((event.event?.eventStartDate)!/1000))
                let endDate = Date(timeIntervalSince1970: TimeInterval((event.event?.eventEndDate)!/1000))
                print(startDate)
                print(endDate)
                print("---------------------------------------------------")
                
                let dates = self.generateDateArrayBetweenTwoDates(startDate: startDate, endDate: endDate)
                self.eventDateArray.append(contentsOf: dates)
                
                var eventObject = event
                eventObject.event?.activeDates = dates
                self.eventListArray.append(eventObject.event)
            }
            print(self.eventDateArray,"fff",self.eventListArray)
            self.calendar.reloadData()
            
            
            if let date = self.calendar.selectedDate {
                self.calendar(self.calendar, didSelect: date, at: .current)
            }
            else {
                self.calendar(self.calendar, didSelect: Date(), at: .current)
            }
            
        }) { (error) in
            
            ActivityIndicatorView.hiding()
            guard let errorString  = error else {
                return
            }
            self.alert(message: errorString)
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
            return Bool(event!.activeDates.contains(selectedDate))
        }
        
        self.MyCalTableVIew.reloadData()
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

