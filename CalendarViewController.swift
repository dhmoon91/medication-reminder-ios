//
//  CalendarViewController.swift
//  medication-reminder
//
//  Created by Stanley Moon on 2017-04-14.
//  Copyright © 2017 Vikas Gandhi. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CalendarViewController: UIViewController {
    
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var month: UILabel!
    let formatter = DateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
         navigationItem.title = "Calendar"
        setupCalendarView()
        // Do any additional setup after loading the view.
    }

    func setupCalendarView() {
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
        calendarView.visibleDates { (visibleDates) in
            self.setupViewsOfCalendar(from: visibleDates)
        }
    }
    func handleCelltextColor(view: JTAppleCell?, cellState: CellState){
        guard let validCell = view as? calCell else {return}
        
       
            if cellState.dateBelongsTo == .thisMonth{
                validCell.dateLabel.textColor = UIColor.black
            }else{
                validCell.dateLabel.textColor = UIColor.lightGray
            }
    }
    
    func setupViewsOfCalendar(from visibleDates: DateSegmentInfo){
        let date = visibleDates.monthDates.first!.date
        
        formatter.dateFormat = "yyyy"
        year.text = formatter.string(from: date)
        formatter.dateFormat = "MMMM"
        month.text = formatter.string(from: date)
        
    }
}

extension CalendarViewController: JTAppleCalendarViewDataSource {
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        let startDate = formatter.date(from: "2017 04 01")!
        let endDate = formatter.date(from: "2017 12 31")!
        let param = ConfigurationParameters(startDate: startDate, endDate: endDate)
        return param
    }
}

extension CalendarViewController: JTAppleCalendarViewDelegate {
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CalCell", for: indexPath) as! calCell
        cell.dateLabel.text = cellState.text
        cell.selectedView.isHidden = true
        let todaySimple = convertDateToSimple(date: Date())
        let dateString = convertDateToSimple(date:date)

        //Highlight today
        if (todaySimple == dateString){
            cell.selectedView.isHidden = false
        }
        
        //handleCellSelected(view: cell, cellState: cellState)
        handleCelltextColor(view: cell, cellState: cellState)
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        //guard let validCell = cell as? calCell else {return}
        let dateMeds = getMedList(date: date)
        
        let dateMedController = DateMedController(collectionViewLayout: UICollectionViewFlowLayout())
        dateMedController.dateMeds = dateMeds
        self.navigationController?.pushViewController(dateMedController, animated: true)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
       setupViewsOfCalendar(from: visibleDates)
    }

}
