//
//  CompletedViewController.swift
//  medication-reminder
//
//  Created by Stanley Moon on 2017-04-17.
//  Copyright © 2017 Vikas Gandhi. All rights reserved.
//

import UIKit
import SwiftyJSON

class CompletedController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var timer: Timer!
    var timer2: Timer!
    let cellId = "cellId"
    // var profiles = [Profile()]
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        defaultLabel.text = "There are no Completed Medication so far"
        self.view.addSubview(defaultLabel)
            view.addConstraintsWithFormat(format: "H:|-20-[v0]-|", views: defaultLabel )
        view.addConstraintsWithFormat(format: "V:|-100-[v0]-|", views: defaultLabel )
        
        
        navigationItem.title = "Completed medication"
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(CompletedCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //need to reloaddata if new medications were missed from ViewController
        
        if (completed.count == 0){
            defaultLabel.isHidden = false
        } else {
            defaultLabel.isHidden = true
        }
       
        collectionView?.reloadData()
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return completed.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let listCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CompletedCell
        listCell.layer.shouldRasterize = true;
        listCell.layer.rasterizationScale = UIScreen.main.scale
        listCell.layer.cornerRadius = 5
        listCell.layer.borderWidth = 1
        listCell.layer.borderColor = UIColor.themeColor.withAlphaComponent(0.6).cgColor
        listCell.completed = completed[indexPath.row]
        listCell.backgroundColor = UIColor.white
        
        return listCell
    }
    //cell's size. fixed height
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 130)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        //top,left,bottom,right
        return UIEdgeInsetsMake(10, 0, 0, 0)
    }
}


class CompletedCell: UICollectionViewCell {
    
    var completed = CompletedMed() {
        didSet {
            if let name = completed.name {
                //let fullName = name + " " + (profile?.lastName)!
                let attributedText = NSMutableAttributedString(string: name, attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14)])
                
                //set attrb for job title
                if let dosage = completed.dosage {
                    attributedText.append(NSAttributedString(string: "\n\(dosage)", attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 14), NSForegroundColorAttributeName: UIColor(red: 155/255, green: 161/255, blue: 171/255, alpha:1) ] ))
                    
                }
                nameLabel.attributedText = attributedText
            }
            if let timeClicked = completed.timeClicked{
                dateLabel.text = "Completed On: \(timeClicked)"
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
    
    let dateLabel: UILabel = {
        var label = UILabel()
        //label.numberOfLines = 2
        return label
    } ()
    
    
    
    func setupView() {
        backgroundColor = UIColor.white
        addSubview(nameLabel)
        addSubview(dateLabel)
        //constraints for label
        addConstraintsWithFormat(format: "H:|-8-[v0]-8-|", views: nameLabel)
        addConstraintsWithFormat(format: "H:|-8-[v0]-8-|", views: dateLabel)
      //  addConstraintsWithFormat(format: "V:|-12-[v0]", views: nameLabel)
        
          addConstraintsWithFormat(format: "V:|-12-[v0]-10-[v1]-|", views: nameLabel, dateLabel)
        //addConstraintsWithFormat(format: "V:|-8-[v0(44)]-4-[v1(20)]", views: profileImageView, completeBtn)
        
        
    }
}