//
//  PeopleViewController.swift
//  MachineTest
//
//  Created by Akanksha pakhale on 09/10/21.
//

import UIKit

class PeopleViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    //collection view to show listing
    private var collectionView: UICollectionView?
    //variable for collecting list data
    var peoplesData:[[String:Any]]?
        override func viewDidLoad() {
        self.navigationController?.isNavigationBarHidden = true
        super.viewDidLoad()
        //setting layout for collection view
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: (view.frame.size.width/2) - 4, height: (view.frame.size.width/2) - 4)
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        guard let collectionView = collectionView else{
            return
        }
        collectionView.backgroundColor = .secondarySystemBackground
        //REgister cell for collection view
        collectionView.register(MyCollectionViewCell.self, forCellWithReuseIdentifier: "CustomCollectionViewCell")
        view.addSubview(collectionView)
        collectionView.frame = view.bounds
        //Confirming Delegates
        self.collectionView?.dataSource = self
        self.collectionView?.delegate = self
        }
    //Creating fav data
    var favDATA = [String]()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       // calling getdata function
        getdata()
    
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    func getdata(){
        var request = URLRequest(url: URL(string: "https://dummyapi.io/data/v1/user?limit=100")!)
        request.httpMethod = "GET"
        //request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.allHTTPHeaderFields = ["app-id":"616047bcd4549c7b249994b7"]
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
          
            if error == nil{
               
                            do {
                                let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                                
                                print(json)
                                if let data = json["data"] as? [[String:Any]]{
                                    DispatchQueue.main.async {
                                        print(data.count)
                                    if self.tabBarController?.selectedIndex == 1{
                                       //feting favourite data from all list data
                                        self.favDATA = UserDefaults.standard.value(forKey: "favIds") as? [String] ?? [String]()
                                        self.peoplesData = data.filter{ self.favDATA.contains($0["id"] as! String) }
                                    } else{
                                        self.peoplesData = data
                                    }
                                        self.collectionView?.reloadData()
                                    }
                            
                                }else{
                                    // data not found
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
    
//function for setting up collection view
func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if peoplesData?.count != 0{
            self.collectionView?.backgroundView = nil
            
        }else{
            //setting Image to show no data when favourite is empty
            let iv = UIImageView(image: UIImage(named: "noData"))
            iv.contentMode = .scaleAspectFit
            iv.frame = collectionView.bounds
            collectionView.backgroundView = iv
        }
        
        return peoplesData?.count ?? 0
        }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyCollectionViewCell.identifier, for: indexPath) as! MyCollectionViewCell
        cell.contentView.backgroundColor = .systemGray2
        cell.data = peoplesData![indexPath.row]
        return cell
       }
    //Opening detail View for selected cell info
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
   let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
              let detailvc = mainStoryboard.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
                   detailvc.data = peoplesData![indexPath.row]
        detailvc.delegate = self

              self.present(detailvc, animated: true, completion: nil)
      }
}
extension PeopleViewController:PresentedDelegate{
    func presentedDidDismiss() {
        if self.tabBarController?.selectedIndex == 1{
        //refreshing data in favourite tab when detail view dismiss
        self.favDATA = UserDefaults.standard.value(forKey: "favIds") as? [String] ?? [String]()
        self.peoplesData = self.peoplesData!.filter{ self.favDATA.contains($0["id"] as! String) }
            self.collectionView?.reloadData() }
    }
   
}
//protocol for dismiss view
protocol PresentedDelegate: AnyObject {
    func presentedDidDismiss()
}

