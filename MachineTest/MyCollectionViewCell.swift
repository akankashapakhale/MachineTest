//
//  MyCollectionViewCell.swift
//  MachineTest
//
//  Created by Akanksha pakhale on 11/10/21.
//

import UIKit
//person cell
class MyCollectionViewCell: UICollectionViewCell {
static let identifier = "CustomCollectionViewCell"
    //Setup image view
    private let myImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    //Setup email view
    private var emailLabel: UILabel = {
        let label = UILabel()
       
        return label
    }()
    //Setup name view
    private let nameLbl: UILabel = {
        let label = UILabel()
      
        return label
    }()
    //Setting up data to be displayed in field
    var data:[String:Any]?{
        didSet{
            nameLbl.text = "\(data!["title"] as? String ?? "") \(data!["firstName"] as? String ?? "") \(data!["lastName"] as? String ?? "")"
            emailLabel.text = "\(data!["id"] as? String ?? "")"
            // Create URL
               let url = URL(string: data!["picture"] as! String)!

               // Fetch Image Data
               if let data = try? Data(contentsOf: url) {
                   // Create Image and Update Image View
                   myImageView.image = UIImage(data: data)
               }       
        }
    }
    override init(frame: CGRect){
        super.init(frame: frame)
        contentView.backgroundColor = .systemGray
        contentView.addSubview(nameLbl)
        contentView.addSubview(myImageView)
        contentView.addSubview(emailLabel)
        contentView.clipsToBounds = true
    }
    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        //Setting up frame of component
        
        emailLabel.frame = CGRect(x: 5, y: contentView.frame.size.height - 50, width: contentView.frame.size.width - 10, height: 50)
        nameLbl.frame = CGRect(x: 5, y: contentView.frame.size.height - 70, width: contentView.frame.size.width - 10, height: 50)
        myImageView.frame = CGRect(x: 5, y:0, width: contentView.frame.size.width - 10, height: contentView.frame.size.height - 50)
    }
  
}
