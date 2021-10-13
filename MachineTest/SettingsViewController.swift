//
//  SettingsViewController.swift
//  MachineTest
//
//  Created by Akanksha pakhale on 09/10/21.
//

import UIKit

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
 }
   //Action on logOut
    @IBAction func LogoutAction(_ sender: Any) {
        //login status of user
        UserDefaults.standard.setLoggedIn(value: false)
        //Removing favourite ids
        UserDefaults.standard.removeObject(forKey: "favIds")
        //calling login screen to relogin
        let appDel =  UIApplication.shared.delegate as? AppDelegate
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let LoginViewController = mainStoryboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        let nav = UINavigationController(rootViewController: LoginViewController)
        appDel?.window?.rootViewController = nav
        
    }
}
