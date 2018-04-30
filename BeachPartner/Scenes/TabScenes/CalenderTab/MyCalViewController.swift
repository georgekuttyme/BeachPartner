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
    
    var dateEvents = ["4","4","4","4","4","4","4","4","4","4","4","4","4","4","4","4","4","4","4","4","4","4","4","4","4","4","4","4","4","4","4","4","4","4","4",]
    
    //    var subeventsArray = [Int]()
    
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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        print("change page to \(self.formatter.string(from: calendar.currentPage))")
        
    }
    
    
    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
        //        guard self.lunar else {
        //            return nil
        //        }
        //        let date = Date()
        let formatterDte = DateFormatter()
        formatterDte.dateFormat = "dd.MM.yyyy"
        let dateVal = formatterDte.string(from: date)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        
        let dayval = formatter.string(from: date)
        let subtitleVal = Int(dayval)! % 5
        
        //         print ("dayval", dayval)
        //         print ("subtitleVal", subtitleVal )
        
        
        if(subtitleVal == 0 || subtitleVal == 1){
            print("Day : ", dayval, " events:", 0)
            self.subeventsArray[dateVal] = 0
            return ""
        }else{
            print("Day : ", dayval, " events:", subtitleVal)
            self.subeventsArray[dateVal] = subtitleVal
            return String(subtitleVal)
        }
        
    }
    
    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        for element in self.subeventsArray {
            print(element, "\n")
        }
        
        print("calendar did select date \(self.formatter.string(from: date))")
        if monthPosition == .previous || monthPosition == .next {
            calendar.setCurrentPage(date, animated: true)
        }
        //        let formatter = DateFormatter()
        //        formatter.dateFormat = "dd"
        //
        //        let dayval = formatter.string(from: date)
        
        let formatterDte = DateFormatter()
        formatterDte.dateFormat = "dd.MM.yyyy"
        let dateVal = formatterDte.string(from: date)
        
        self.noOfEvents = self.subeventsArray[dateVal]!
        
        self.MyCalTableVIew.reloadData()
        //        print("selected date :")
    }
    
    
}
