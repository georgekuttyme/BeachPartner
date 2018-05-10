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
    
    @IBOutlet weak var MasterCalTableVIew: UITableView!
    @IBOutlet weak var calendar: FSCalendar!
    
//    var subeventsArray = [Int]()
    
    var eventDateArray = [Date]()
    
    var subeventsArray = [String: Int]()
    
//    [(date: String, noOfEvents: Int)]()
    
    var noOfEvents = 0
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noOfEvents
    }
    
        fileprivate let gregorian: NSCalendar! = NSCalendar(calendarIdentifier:NSCalendar.Identifier.gregorian)
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "caltablecell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CalanderTableViewCell  else {
            fatalError("The dequeued cell is not an instance of ManagSenderTableViewCell.")
        }
         let n = Int(arc4random_uniform(5))
        
        if(n == 2){
        cell.colorView.backgroundColor = .red
        }
        else if(n == 4){
            cell.colorView.backgroundColor = .gray
        }
        if(n == 5){
            cell.colorView.backgroundColor = .green
        }
        if(n == 1){
            cell.colorView.backgroundColor = UIColor(red: 41/255.0, green: 56/255.0, blue: 133/255.0, alpha:1.0)
//            cell.colorView.backgroundColor = .blue
        }
//        if(n == 3){
//            cell.colorView.backgroundColor = UIColor.cyan
//        }
        
        return cell
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("Count :: ",self.subeventsArray.count)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.subeventsArray.removeAll()
        // Do any additional setup after loading the view.
        
        
        getAllEvents()
    }
    
    private func getAllEvents() {
        
        ActivityIndicatorView.show("Loading")
        APIManager.callServer.getAllEvents(sucessResult: { (responseModel) in
            
            ActivityIndicatorView.hiding()
            guard let eventsArrayModel = responseModel as? GetEventsRespModelArray else {
                print("Rep model does not match")
                return
            }
            
            for event in eventsArrayModel.getEventsRespModel {
                
                let startDate = Date(timeIntervalSince1970: TimeInterval(event.eventStartDate/1000))
                let endDate = Date(timeIntervalSince1970: TimeInterval(event.eventEndDate/1000))
                print(startDate)
                print(endDate)
                
                
                let dates = self.generateDatesArrayBetweenTwoDates(startDate: startDate, endDate: endDate)
                self.eventDateArray.append(contentsOf: dates)
                
                print("---------------------------------------------------")
            }

            self.calendar.reloadData()
            
        }) { (error) in
            
            ActivityIndicatorView.hiding()
            guard let errorString  = error else {
                return
            }
            self.alert(message: errorString)
        }
    }
    
    

    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        print("change page to \(self.formatter.string(from: calendar.currentPage))")
       
    }
    
    
    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {

        let filterResult = eventDateArray.filter { (eventDate) -> Bool in
            let order = Calendar.current.compare(eventDate, to: date, toGranularity: .day)
            if order == .orderedSame {
                return true
            }
            return false
        }
        
        let count = filterResult.count
        if count > 0 { return "\(count)" }
        return nil
        
        
        
        
//        if filterResult.count > 0 {
//            return "\(filterResult.count)"
//        }
        
        
        
//        let count = eventDateArray.filter{$0 == date}.count
//
//        print(count)
        
        
        
        
//        let order = Calendar.current.compare(date, to: date, toGranularity: .day)
//        return order == .orderedSame
//
//        if count > 0 { return "\(count)" }
//        return nil
        
        
//        if date


        //        guard self.lunar else {
//            return nil
//        }
//        let date = Date()
//        let formatterDte = DateFormatter()
//        formatterDte.dateFormat = "dd.MM.yyyy"
//        let dateVal = formatterDte.string(from: date)
//
//        let formatter = DateFormatter()
//        formatter.dateFormat = "dd"
//
//        let dayval = formatter.string(from: date)
//        let subtitleVal = Int(dayval)! % 5
//
////         print ("dayval", dayval)
////         print ("subtitleVal", subtitleVal )
//
//
//        if(subtitleVal == 0 || subtitleVal == 1){
//            print("Day : ", dayval, " events:", 0)
//            self.subeventsArray[dateVal] = 0
//            return ""
//        }else{
//            print("Day : ", dayval, " events:", subtitleVal)
//            self.subeventsArray[dateVal] = subtitleVal
//        return String(subtitleVal)
//        }
        
    }
    
    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
//        for element in self.subeventsArray {
//            print(element, "\n")
//        }
//
//        print("calendar did select date \(self.formatter.string(from: date))")
//        if monthPosition == .previous || monthPosition == .next {
//            calendar.setCurrentPage(date, animated: true)
//        }
////        let formatter = DateFormatter()
////        formatter.dateFormat = "dd"
////
////        let dayval = formatter.string(from: date)
//
//        let formatterDte = DateFormatter()
//        formatterDte.dateFormat = "dd.MM.yyyy"
//        let dateVal = formatterDte.string(from: date)
//
//        self.noOfEvents = self.subeventsArray[dateVal]!
//
//        self.MasterCalTableVIew.reloadData()
////        print("selected date :")
    }
    
    
    //MARK:- Helper Methods
    func generateDatesArrayBetweenTwoDates(startDate: Date , endDate:Date) ->[Date]
    {
        var datesArray: [Date] =  [Date]()
        var startDate = startDate
        let calendar = Calendar.current
        
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyy-MM-dd"
        
        while startDate <= endDate {
            datesArray.append(startDate)
            startDate = calendar.date(byAdding: .day, value: 1, to: startDate)!
        }
        return datesArray
    }
    
    
    
}
