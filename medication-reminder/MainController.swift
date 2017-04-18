//
//  ViewController.swift
//
//
//  Created by Stanley Moon on 2017-03-29.
//  Copyright © 2017 stanley. All rights reserved.
//

import UIKit
import SwiftyJSON
import UserNotifications

class MainController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var timerFiveBefore: Timer!
    var timerOnTime: Timer!
    var timerFiveAfter: Timer!
    
    var timerNewDay: Timer!
    
    let cellId = "cellId"
    var todayMeds = [Med]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        defaultLabel.text = "There are no Scheduled Medication Today"
        self.view.addSubview(defaultLabel)
        view.addConstraintsWithFormat(format: "H:|-(<=20)-[v0]-|", views: defaultLabel )
        view.addConstraintsWithFormat(format: "V:|-(<=20)-[v0]-|", views: defaultLabel )
        
        navigationItem.title = "Today's medication"
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(ListCell.self, forCellWithReuseIdentifier: cellId)
        UNUserNotificationCenter.current().delegate = self
        
        //Query Meds data to get today's data. 
        //if right now is 2017-04-16 10:00:00, get datas starting 10min diff
        
        let calendar = Calendar.current
        let now = Date()
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: now)
        /*components.day = components.day! + 1
         components.hour = -4
         components.minute = 0
         components.second = 0*/
        
        // components.day = components.day! + 1
        // components.hour = 4
        components.minute = 13
        components.second = 30
        
        let date = calendar.date(from:components)!
        
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let result = formatter.string(from: date)
        
        print("SHOULD GET 00;))")
        print(result)
        self.timerNewDay = Timer(fireAt: date, interval: 10, target: self, selector: #selector(getData), userInfo: nil, repeats: true)
        RunLoop.main.add(timerNewDay, forMode: RunLoopMode.commonModes)
    }
    
    func getData () {
       //Get new today's data
        let today = Date()
        todayMeds.append( contentsOf: getMedList(date: today) )
        //todayMeds = meds
       // todayMeds.append(contentsOf: meds)
        self.collectionView?.reloadData()
        /*for med in meds{
            todayMeds.append(med)
        }*/
       
       
    }
    func appendData () {
        getData()
        print("RAN TIMER")
        //timerNewDay.invalidate()
    }
    func triggerUI(at date: Date, for cell: ListCell){
       //** Playing around with Time zone **//
        //print(date)
        let dateformat = DateFormatter()
        dateformat.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateformat.timeZone = TimeZone(abbreviation:"GMT")!
        let temp = dateformat.string(from: date)
        
        let dateFormat2 = DateFormatter()
        dateFormat2.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormat2.timeZone = TimeZone(abbreviation: "EST")!
        let temp2 = dateFormat2.date(from: temp)
        
        var date2 = temp2!.addingTimeInterval(-5)
        
        //Showing 'FINISHED' Button 5min before med time, change cell's background color to orange
        self.timerFiveBefore = Timer(fireAt: date2, interval: 0, target: self, selector: #selector(fiveMinuteBefore), userInfo: ["theButton": cell.myButton], repeats: false)
        
        //Changing cell's background color to red at med time
        date2 = date2.addingTimeInterval(5)
        self.timerOnTime = Timer(fireAt: date2, interval: 0, target: self, selector: #selector(onTime), userInfo: nil, repeats: false)
        
        //Removing cell to Missed 5min after medication time.
        date2 = date2.addingTimeInterval(60)
        self.timerFiveAfter = Timer(fireAt: date2, interval: 0, target: self, selector: #selector(fiveMinuteAfter), userInfo: nil, repeats: false)
        
        //Add the timers
        RunLoop.main.add(timerFiveBefore, forMode: RunLoopMode.commonModes)
        RunLoop.main.add(timerOnTime, forMode: RunLoopMode.commonModes)
        RunLoop.main.add(timerFiveAfter, forMode: RunLoopMode.commonModes)
        
    }
    
    func fiveMinuteBefore (button: Bool) {
        //print("TIME RUN RAN")
        let userInfo = timerFiveBefore.userInfo as! Dictionary<String, AnyObject>
        let button:UIButton = (userInfo["theButton"] as! UIButton)
        button.isHidden = false
        
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = collectionView?.cellForItem(at: indexPath)
        cell?.backgroundColor = UIColor(red: 244/255.0, green: 182/255.0, blue: 66/255.0, alpha: 1.0)

        timerFiveBefore.invalidate()
    }
    func onTime (button: Bool) {
        //print("TIME run ran 2")
      /*  let userInfo = timerOnTime.userInfo as! Dictionary<String, AnyObject>
        let cell: ListCell = (userInfo["theCell"] as! ListCell )*/
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = collectionView?.cellForItem(at: indexPath)
        //cell.dateLabel.textColor = UIColor.white
        //cell.nameLabel.textColor = UIColor.white
        cell?.backgroundColor = UIColor(red: 209/255.0, green: 51/255.0, blue: 37/255.0, alpha: 1.0)
        timerOnTime.invalidate()
    }
    
    func fiveMinuteAfter () {
        missed.insert(todayMeds[0], at: 0)
        todayMeds.remove(at: 0)
        
        self.collectionView?.reloadData()
        tabbarCounter += 1
        tabBarController?.tabBar.items![3].badgeValue = String(tabbarCounter)
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        timerFiveAfter.invalidate()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (todayMeds.count == 0){
            defaultLabel.isHidden = false
        }else {
            defaultLabel.isHidden = true
        }
        return todayMeds.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let listCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ListCell
        //print(profiles[indexPath.row])
       
        listCell.layer.shouldRasterize = true;
        listCell.layer.rasterizationScale = UIScreen.main.scale
        listCell.layer.cornerRadius = 5
        listCell.layer.borderWidth = 1
        listCell.layer.borderColor = UIColor.themeColor.withAlphaComponent(0.6).cgColor
        listCell.todayMed = todayMeds[indexPath.row]
        listCell.backgroundColor = UIColor.white
        listCell.myButton.isHidden = true
        
        //Object Array is sorted. We only care about the closest medication
        if( indexPath.row == 0){
            listCell.myButton.tag = indexPath.row
            listCell.myButton.addTarget(self, action: #selector(deleteCellCompleted(_:)), for: .touchUpInside)
            //Scheduling notification
            scheduleNotification(at: todayMeds[indexPath.row].timeParsed, id: todayMeds[indexPath.row].id, name: todayMeds[indexPath.row].name, dosage: todayMeds[indexPath.row].dosage)
            //Setting timer to trigger UI changes depending on time
            triggerUI(at: todayMeds[indexPath.row].timeParsed, for: listCell)
        }
        return listCell
    }
    func deleteCellCompleted(_ sender: UIButton) {
        let alert = UIAlertController(title: NSLocalizedString("Have you treated patient with proper medication and dosage?", comment: "Alert View title on Settings page, when user wants to log out"), message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title:"Yes", style: UIAlertActionStyle.default, handler:{
            action in
            var temp = CompletedMed()
            var clickedTime = Date()
            clickedTime = clickedTime.addingTimeInterval(-14400)
            let clickedString = dateParseForLabel(forDate: clickedTime)
            temp.name = meds[0].name
            temp.dosage = meds[0].dosage
            temp.completed = meds[0].completed
            temp.time = meds[0].time
            temp.timeParsed = meds[0].timeParsed
            temp.timeClicked = clickedString
            
            completed.insert(temp, at: 0)
            self.todayMeds.remove(at: 0)
            
            //remove pending notification + timer for the current med
            self.timerOnTime.invalidate()
            self.timerFiveAfter.invalidate()
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            
            self.collectionView?.reloadData()
            
        }))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    //cell's size. fixed height
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 80)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        //top,left,bottom,right
        return UIEdgeInsetsMake(10, 0, 0, 0)
    }

}


class ListCell: UICollectionViewCell {
    
    var todayMed = Med() {
        didSet {
            if let name = todayMed.name {
                let attributedText = NSMutableAttributedString(string: name , attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14),NSForegroundColorAttributeName: UIColor.themeColor])
                if let dosage = todayMed.dosage {
                    attributedText.append(NSAttributedString(string: "\n\(dosage)", attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 14), NSForegroundColorAttributeName: UIColor(red: 155/255, green: 161/255, blue: 171/255, alpha:1) ] ))
                }
                nameLabel.attributedText = attributedText
            }
            if let timeParsed = todayMed.timeParsed{
                let string = dateParseForLabel(forDate: timeParsed)
                dateLabel.text = string
            }
        }
    }
    
    
    override init(frame:CGRect) {
        super.init(frame:frame)
        setupView()

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //init buttons, images, textview
    let nameLabel: UILabel = {
        var label = UILabel()
        label.numberOfLines = 2
        return label
    } ()
    
    let dateLabel: UILabel = {
        var label = UILabel()
        return label
    } ()
    
    lazy var myButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor.themeColor
        button.setTitle("Completed", for: .normal)
        return button
    }()
    
    func setupView() {
        backgroundColor = UIColor.white
        addSubview(nameLabel)
        addSubview(dateLabel)
        addSubview(myButton)
        
        //constraints for label
        addConstraintsWithFormat(format: "H:|-8-[v0]-8-|", views: nameLabel)
        addConstraintsWithFormat(format: "H:|-8-[v0]-8-|", views: dateLabel)
        addConstraintsWithFormat(format: "H:[v0(100)]-10-|", views: myButton)

        addConstraintsWithFormat(format: "V:|-5-[v0]-5-[v1]", views: nameLabel, dateLabel)
        addConstraintsWithFormat(format: "V:|-(<=20)-[v0(40)]-|", views: myButton)
    }
}


///*** Scheduling two notification  ***///
//First one runs on medication time, with small chime sound (default alarm sound on iOS)
//Second one runs at 5min past medication time, with LOUD BEEPING sound

func scheduleNotification(at date: Date, id: String!, name: String!, dosage:String!) {
    let calendar = Calendar(identifier: .gregorian)
    //no need to change timezone. it's already defined in data
    let components = calendar.dateComponents(in: TimeZone(abbreviation:"GMT")!, from: date)

    //Time at med time
    let medTime = DateComponents(calendar: calendar, month: components.month, day: components.day, hour: components.hour, minute: components.minute)
    //5min past med time
    let fiveMedTime = DateComponents(calendar: calendar, month: components.month, day: components.day, hour: components.hour, minute: components.minute! + 1)
    
    let trigger = UNCalendarNotificationTrigger(dateMatching: medTime, repeats: false)
    let trigger2 = UNCalendarNotificationTrigger(dateMatching: fiveMedTime, repeats: false)
    
    
    let content = UNMutableNotificationContent()
    content.title = "Medication Reminder"
    content.body = "Reminder; Now it's time for \(name!) with \(dosage!)"
    content.sound = UNNotificationSound.default()
    
    let content2 = UNMutableNotificationContent()
    content2.title = "Medication Reminder"
    content2.body = "You Missed \(name!) with \(dosage!)! Please check 'Missed'"
    content2.sound = UNNotificationSound(named: "alarm.caf")
    let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
    let request2 = UNNotificationRequest(identifier: "\(id)a", content: content2, trigger: trigger2)
    
    UNUserNotificationCenter.current().removeAllDeliveredNotifications()
   
    //First Alarm Running at medication time
    UNUserNotificationCenter.current().add(request) {(error) in
        if let error = error {
            print("Uh oh! We had an error: \(error)")
        }
    }
    
    //Second Alarm Running past 5minute of medication time
    UNUserNotificationCenter.current().add(request2) {(error) in
        if let error = error {
            print("Uh oh! We had an error: \(error)")
        }
    }
    
}

extension MainController: UNUserNotificationCenterDelegate{
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert,.sound])
    }
    
    
}


/*let formatter = DateComponentsFormatter()
 formatter.unitsStyle = .positional
 formatter.allowedUnits = [.second]
 
 formatter.zeroFormattingBehavior = .pad
 var string = formatter.string(from: date, to: Date())
 string = string?.replacingOccurrences(of: ",", with: "")
 
 var diff = Double(string!)
 //4hour diffrence.
 diff = 14395 - diff!*/


