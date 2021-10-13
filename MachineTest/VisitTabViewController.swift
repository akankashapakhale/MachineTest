//
//  VisitTabViewController.swift
//  MachineTest
//
//  Created by Akanksha pakhale on 09/10/21.
//

import UIKit
//Dashboard Tabbar
class VisitTabViewController: UITabBarController, UITabBarControllerDelegate {
    
       override func viewDidLoad() {
           super.viewDidLoad()
           self.delegate = self
   }
       
       override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
        //Creating Tabbar for listing People
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let tabPeople = mainStoryboard.instantiateViewController(withIdentifier: "PeopleViewController") as! PeopleViewController
        let tabOneBarItem = UITabBarItem(title: "People", image: UIImage(systemName: "square.grid.2x2"), selectedImage: UIImage(systemName: "square.grid.2x2.fill"))
        tabPeople.tabBarItem = tabOneBarItem
        // Create Tab for favourite
        let tabFav = mainStoryboard.instantiateViewController(withIdentifier: "PeopleViewController") as! PeopleViewController
        let tabTwoBarItem2 = UITabBarItem(title: "Favourite", image: UIImage(systemName: "heart"), selectedImage: UIImage(systemName: "heart.fill"))
        tabFav.tabBarItem = tabTwoBarItem2
        // Create Tab for Setting
        let tabSetting = mainStoryboard.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
        let tabTwoBarItem3 = UITabBarItem(title: "Settings", image: UIImage(systemName: "gear"), selectedImage: UIImage(systemName: "gear.fill"))
        tabSetting.tabBarItem = tabTwoBarItem3
        self.viewControllers = [tabPeople, tabFav, tabSetting]
       }
       
       // UITabBarControllerDelegate method
       func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
       }
}
