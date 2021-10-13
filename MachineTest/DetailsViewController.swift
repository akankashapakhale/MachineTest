//
//  DetailsViewController.swift
//  MachineTest
//
//  Created by Akanksha pakhale on 09/10/21.
//

import UIKit


class DetailsViewController: UIViewController {
    var data:[String:Any]?
    
    //All the outlets required by screen
    @IBOutlet weak var imgV: UIImageView!
    
    @IBOutlet weak var dobLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var registartionDater: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var phoneNumberLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var addressDesLbl: UILabel!
    @IBOutlet weak var idLbl: UILabel!
    
    @IBOutlet weak var favBTN: UIButton!
    
   //calling favourite data
    var favDATA = [String]()
    //for id to be favourite or not
    var isChecked = true
    override func viewDidLoad() {
        super.viewDidLoad()
        getDetail()
        
        if let favdata = UserDefaults.standard.value(forKey: "favIds") as? [String]{
            self.favDATA = favdata
            if favdata.contains(data!["id"] as! String){
            isChecked = true
                //set favourite icon
                favBTN.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            }else{
            isChecked = false
                //set non favourite icon
                favBTN.setImage(UIImage(systemName: "heart"), for: .normal)
            }
        }else{
            isChecked = false
            favBTN.setImage(UIImage(systemName: "heart"), for: .normal)
        }
       
    }
 func getDetail(){
        let id = data!["id"] as! String
        var request = URLRequest(url: URL(string: "https://dummyapi.io/data/v1/user/\(id)")!)
        request.httpMethod = "GET"
     
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.allHTTPHeaderFields = ["app-id":"616047bcd4549c7b249994b7"]
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
          
            if error == nil{
               
                            do {
                                let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                                
                                print(json)
                                self.setupdata(data: json)
                                
                                
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
    //Setting data in IBoutlets
    
    func setupdata(data:[String:Any]){
        DispatchQueue.main.async { [self] in
            let url = URL(string: data["picture"] as! String)!
            
            
            if let data = try? Data(contentsOf: url) {
                
                self.imgV.image = UIImage(data: data)
            }
            
            dobLabel.text = ("Date of Birth: \(data["dateOfBirth"] as! String)")
            nameLabel.text = ("Name: \(data["title"] as! String) \(data["firstName"] as! String) \(data["lastName"] as! String)")
            genderLabel.text = ("Gender: \(data["gender"] as! String)")
            registartionDater.text = ("RegistrationDate: \(data["registerDate"] as! String)")
            emailLbl.text = ("Email: \(data["email"] as! String)")
            phoneNumberLbl.text = ("Phone Number: \(data["phone"] as! String)")
           let addd = data["location"] as? [String:Any]
            addressDesLbl.text = "\(addd!["street"] as! String) \(addd!["state"] as! String) \(addd!["country"] as! String)"
            idLbl.text = ("ID: \(data["id"] as! String)")
            
            
        }
    }
    //Action favourite Icon
    @IBAction func Favourite(_ sender: Any) {
        let id = data!["id"] as! String
        isChecked = !isChecked
                   if isChecked {
                    (sender as AnyObject).setImage(UIImage(systemName: "heart.fill"), for: .normal)
                    self.favDATA.append(id)
                   
                   } else {
                    (sender as AnyObject).setImage(UIImage(systemName: "heart"), for: .normal)
                    for c in self.favDATA.enumerated() where c.element == id{
                        self.favDATA.remove(at: c.offset)
                    }
                   }
       
    }
    weak var delegate: PresentedDelegate?
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UserDefaults.standard.removeObject(forKey: "favIds")
        UserDefaults.standard.set(self.favDATA, forKey: "favIds")
        
        delegate?.presentedDidDismiss()
    }

}
