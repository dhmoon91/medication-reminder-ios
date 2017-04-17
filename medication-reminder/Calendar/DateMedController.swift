//
//  DateMedController.swift
//  medication-reminder
//
//  Created by Stanley Moon on 2017-04-16.
//  Copyright © 2017 Vikas Gandhi. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
//import UserNotifications


class DateMedController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var timer: Timer!
    var timer2: Timer!
    var date: Date!
    
    let cellDate = "cellDate"
    var dateMeds = [[String:Any]]()
    // var profiles = [Profile()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        navigationItem.title = " medication"
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(DateCell.self, forCellWithReuseIdentifier: cellDate)
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dateMeds.count
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let listCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellDate, for: indexPath) as! DateCell
        
        listCell.layer.shouldRasterize = true;
        listCell.layer.rasterizationScale = UIScreen.main.scale
        listCell.layer.cornerRadius = 5
        listCell.layer.borderWidth = 1
        //listCell.layer.borderColor = UIColor.themeColor.withAlphaComponent(0.6).cgColor
        listCell.dateMed = dateMeds[indexPath.row]
        listCell.backgroundColor = UIColor.white
        listCell.myButton.isHidden = true
        
        return listCell
    }
    
    //cell touched, highlight
    override func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let listCell = collectionView.cellForItem(at: indexPath)
        listCell?.contentView.backgroundColor = UIColor.lightGray
    }
    
    //cell released, un-highlight
    override func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        let listCell = collectionView.cellForItem(at: indexPath)
        listCell?.contentView.backgroundColor = UIColor.white
        
    }
    
    //cell's size. fixed height
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 130)
    }
    
}


class DateCell: UICollectionViewCell {
    
    var dateMed: [String:Any]? {
        didSet {
            if let name = dateMed?["name"] {
                //let fullName = name + " " + (profile?.lastName)!
                let attributedText = NSMutableAttributedString(string: name as! String, attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14)])
                
                //set attrb for job title
                if let dosage = dateMed?["dosage"] {
                    attributedText.append(NSAttributedString(string: "\n\(dosage)", attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 14), NSForegroundColorAttributeName: UIColor(red: 155/255, green: 161/255, blue: 171/255, alpha:1) ] ))
                    
                }
                nameLabel.attributedText = attributedText
                
            }
            
            //print(setNotif)
            /*if let profileImageUrl = profile?.avatar{
             // print(profileImageUrl)
             let data = NSData(contentsOf: NSURL(string: profileImageUrl) as! URL)
             profileImageView.image = UIImage(data: data as! Data)
             }
             
             if let bio = profile?.{
             let attributedText = NSMutableAttributedString(string: bio, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 13)])
             bioTextView.attributedText = attributedText
             }*/
            
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
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    } ()
    
    let nameLabel: UILabel = {
        var label = UILabel()
        label.numberOfLines = 2
        return label
    } ()
    
    let bioTextView: UILabel = {
        let textView = UILabel()
        textView.numberOfLines = 6
        return textView
    } ()
    
    lazy var myButton: UIButton = {
        //UIButton
        let button = UIButton(frame: CGRect(x: 40, y: 40, width: 100, height: 40))
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor.themeColor
        button.setTitle("FINISHED", for: .normal)
        return button
    }()
    
    func setupView() {
        backgroundColor = UIColor.white
        addSubview(nameLabel)
        addSubview(profileImageView)
        addSubview(bioTextView)
        // addSubview(completeBtn)
        addSubview(myButton)
        myButton.isHidden = false
        //constraints for label
        addConstraintsWithFormat(format: "H:|-8-[v0(44)]-100-[v1]", views: profileImageView, nameLabel)
        
        // addConstraintsWithFormat(format: "H:|-4-[v0]-4-|", views: bioTextView)
        
        //addConstraintsWithFormat(format: "H:|-4-[v0(100)]-4-|", views: completeBtn)
        
        // addConstraintsWithFormat(format: "H:", views: completeBtn)
        
        addConstraintsWithFormat(format: "V:|-12-[v0]", views: nameLabel)
        
        //addConstraintsWithFormat(format: "V:|-8-[v0(44)]-4-[v1(20)]", views: profileImageView, completeBtn)
        
        
    }
}
