//
//  AppDelegate.swift
//  medication-reminder
//
//  Created by Vikas Gandhi on 2017-03-17.
//  Copyright © 2017 Vikas Gandhi. All rights reserved.
//

import UIKit
import UserNotifications
import SwiftyJSON

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    static let shared = { return UIApplication.shared.delegate as! AppDelegate }
 
   
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (accepted, error) in
            if !accepted{
                print("NOTIFICATION ACCESS DENIED")
            }
        }
        //let locale = TimeZone.init(abbreviation: "GMT")
       // TimeZone.default = locale as! TimeZone
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController =  TabBarController()
        
        UINavigationBar.appearance().barTintColor = UIColor.themeColor
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        UITabBar.appearance().tintColor = UIColor.themeColor
        
        application.statusBarStyle = .lightContent
        //copyFileToDirectory(fromPath: "/Sounds", fileName: "alarmStan.caf")
        //GETTING DATA
       
        let urlString = "http://\(localIp):9000/api/medications"
       
        var tempMed = Med()
       
        if let url = URL(string: urlString)
       // if let path = Bundle.main.path(forResource: "test", ofType:"json")
        {
            do{
                //let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                let data = try Data(contentsOf: url)
                let jsonObj = JSON(data:data)
                if jsonObj != JSON.null{
                    //print("Jsondata: \(jsonObj)")
                   
                    for result in jsonObj.arrayValue {
                        let id = result["_id"].stringValue
                        let name = result["name"].stringValue
                        let dosage = result["dosage"].stringValue
                       
                        let tempTime = result["time"].stringValue
                        let deFormatter = DateFormatter()
                        deFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                        let time = deFormatter.date(from: tempTime)
                        
                        //timeParsed will be used to set notification and ui
                        let timeParsed = dateParse(forDate: tempTime)
                        //timeSimpleFormat will be used for Calendar to load proper data on specific day
                        
                        //print(timeParsed)
                        let timeSimple = convertDateToSimple(date: timeParsed)
                
                        
                        let completed = result["completed"].boolValue
                        tempMed.id = id
                        tempMed.dosage = dosage
                        tempMed.name = name
                        
                        //YYYY-MM-dd'T'HH:mm:ss.SSSZ as Date
                        tempMed.time = time
                        
                        //YYYY-MM-DD HH:MM:SS as Date
                        tempMed.timeParsed = timeParsed
                        
                        //YYYY-MM-DD as String
                        tempMed.timeSimple = timeSimple
                        tempMed.completed = completed
                        meds.append(tempMed)
                    }
                }
            } catch let error{
                print(error.localizedDescription)
            }
        }
        
        //Sorting!
        meds.sort{
         $0.time < $1.time
        }
        return true

    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
   
   

}

