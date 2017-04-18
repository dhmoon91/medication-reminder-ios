//
//  TabBarController.swift
//  
//
//  Created by Stanley Moon on 2017-03-29.
//  Copyright © 2017 stanley. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Making tabs//
        
        //main page- list of today's med
        let mainController = MainController(collectionViewLayout: UICollectionViewFlowLayout())
        let navigationController = UINavigationController(rootViewController: mainController)
        navigationController.title = "Today"
        navigationController.tabBarItem.image = UIImage(named: "Today")
       
        //Calendar page
        let calPage = UIStoryboard(name: "Calendar", bundle: nil).instantiateViewController(withIdentifier: "CalendarViewController") as! CalendarViewController
        let secondNavigationController = UINavigationController(rootViewController: calPage)
        secondNavigationController.title = "Calendar"
        secondNavigationController.tabBarItem.image = UIImage(named: "Calendar")

        
        let completedController = CompletedController(collectionViewLayout: UICollectionViewFlowLayout())
        let thirdNavigationController = UINavigationController(rootViewController: completedController)
        thirdNavigationController.title = "Completed"
        thirdNavigationController.tabBarItem.image = UIImage(named: "Completed")

        let missedController = MissedController(collectionViewLayout: UICollectionViewFlowLayout())
        let fourthNavigationController = UINavigationController(rootViewController: missedController)
        fourthNavigationController.title = "Missed"
        fourthNavigationController.tabBarItem.image = UIImage(named: "Missed")
       
        
        viewControllers = [navigationController, secondNavigationController, thirdNavigationController, fourthNavigationController]
        tabBar.isTranslucent = false
        //tabBar.clipsToBounds = true
    }
}
