//
//  LoginViewController.swift
//  MachineTest
//
//  Created by Akanksha pakhale on 09/10/21.
//

import UIKit
//Login page
class LoginViewController: UIViewController, UITextFieldDelegate {
    //All the outlets for login Screen
    @IBOutlet weak var EmailTxtField: UITextField!
    @IBOutlet weak var passwordTxtField: UITextField!
    @IBOutlet weak var emailAlertLbl: UILabel!
    
    @IBOutlet weak var passwordAlertLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        //Login title
        self.title = "Log In"
        //hiding keyboard function call
        hideKeyboardWhenTappedAround()
        //Confirming Textfield Delegates
        EmailTxtField.delegate = self
        passwordTxtField.delegate = self
        
        // Customize TextField
        EmailTxtField.layer.borderWidth = 1
        EmailTxtField.layer.borderColor = UIColor.red.cgColor
        passwordTxtField.layer.borderWidth = 1
        passwordTxtField.layer.borderColor = UIColor.red.cgColor
        
    }
    // Login function verifing id password and move to dashoard
    @IBAction func LoginAction(_ sender: Any) {
      

        let params = ["username":EmailTxtField.text, "password":passwordTxtField.text
        ] as! Dictionary<String, String>
        //Api call
        var request = URLRequest(url: URL(string: "https://reqres.in/api/login")!)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
          
            if error == nil{
               
                            do {
                                let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                                //checking json
                                if  ((json["token"] as? String) != nil){
                                    //Setting value for user login
                                    UserDefaults.standard.setLoggedIn(value: true)
                                    DispatchQueue.main.async {
                                        let tabVCiuewcontroller = VisitTabViewController()
                                        self.navigationController?.pushViewController(tabVCiuewcontroller, animated: true)
                                    }
                                   
                                }else{
                                    
                                    
                            let msg = json["error"] as! String
                           //Alert Pop up for failed verification
                            let alert = UIAlertController(title: "Authentication Failed", message: msg, preferredStyle: UIAlertController.Style.alert)

                            // add an action (button)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

                            // show the alert
                            DispatchQueue.main.async {
                                        self.present(alert, animated: true, completion: nil)
                                    }
                                }
                            } catch {
                                print("Something went Wrong")// this is serilization error
                            }
            }else{
                // error while conection failed
                print("Something went Wrong\(String(describing: error))")
            }

        })

        task.resume()
        
    }
    // Checking text field validation
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
            case EmailTxtField:
            checkTextField(textField: EmailTxtField, alrtLbl: emailAlertLbl, incorrectMsg: "Enter Correct Email", EmptyMsg: "Email field should not be Empty", selector: isValidEmail(_:))
            
            case passwordTxtField:
            checkTextField(textField: passwordTxtField, alrtLbl: passwordAlertLbl, incorrectMsg: "Enter password with minimum lenght of 8 Character", EmptyMsg: "phone number should not be Empty", selector: isValidpassword(_:))
        default:
            ()
         }
        
    }
    //generic function for validation
    typealias MethodsHandler = (String) -> Bool
    func checkTextField(textField: UITextField, alrtLbl: UILabel, incorrectMsg: String, EmptyMsg: String , selector: (String) -> Bool){
        if textField.text != nil && !textField.text!.isEmpty {
            if selector(textField.text!) {
                alrtLbl.isHidden = true
            }
            else {
                alrtLbl.text = incorrectMsg
                alrtLbl.isHidden = false
            }
          }
        else{
            alrtLbl.text = EmptyMsg
            alrtLbl.isHidden = false
        }
}
//Function for hide Keyboard
}
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self,
                         action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}
