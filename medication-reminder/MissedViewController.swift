//
//  MissedViewController.swift
//  medication-reminder
//
//  Created by Stanley Moon on 2017-04-16.
//  Copyright © 2017 Vikas Gandhi. All rights reserved.
//

import UIKit
import SwiftyJSON

class MissedController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var timer: Timer!
    var timer2: Timer!
    let cellId = "cellId"
    // var profiles = [Profile()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaultLabel.text = "There are no Missed Medication so far"
        self.view.addSubview(defaultLabel)
        view.addConstraintsWithFormat(format: "H:|-(<=20)-[v0]-|", views: defaultLabel )
        view.addConstraintsWithFormat(format: "V:|-(<=20)-[v0]-|", views: defaultLabel )
        
        navigationItem.title = "Missed medication"
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(MissedCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabbarCounter = 0
        tabBarController?.tabBar.items![3].badgeValue = nil
        //need to reloaddata if new medications were missed from ViewController
        if(missed.count == 0){
            defaultLabel.isHidden = false
        }else{
            defaultLabel.isHidden = true
        }
        collectionView?.reloadData()
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return missed.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let listCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MissedCell
        listCell.layer.shouldRasterize = true;
        listCell.layer.rasterizationScale = UIScreen.main.scale
        listCell.layer.cornerRadius = 5
        listCell.layer.borderWidth = 1
        listCell.layer.borderColor = UIColor.themeColor.withAlphaComponent(0.6).cgColor
        listCell.missed = missed[indexPath.row]
        listCell.backgroundColor = UIColor.white

        return listCell
    }
    //cell's size. fixed height
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        //top,left,bottom,right
        return UIEdgeInsetsMake(10, 0, 0, 0)
    }
    
}


class MissedCell: UICollectionViewCell {
    
    var missed = Med() {
        didSet {
            if let name = missed.name {
                let attributedText = NSMutableAttributedString(string: name, attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14), NSForegroundColorAttributeName: UIColor.themeColor])
                
                if let dosage = missed.dosage {
                    attributedText.append(NSAttributedString(string: "\n\(dosage)", attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 14), NSForegroundColorAttributeName: UIColor(red: 155/255, green: 161/255, blue: 171/255, alpha:1) ] ))
                    
                }
                nameLabel.attributedText = attributedText
            }
            if let timeParsed = missed.timeParsed{
                // print("set time")
                //print(timeParsed)
                let string = dateParseForLabel(forDate: timeParsed)
                dateLabel.text = string
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
    let nameLabel: UILabel = {
        var label = UILabel()
        label.numberOfLines = 2
        return label
    } ()
    
    let dateLabel: UILabel = {
        var label = UILabel()
        return label
    } ()
    
    let missedLabel: UILabel = {
        var label = UILabel()
        label.backgroundColor = UIColor.red
        label.textAlignment = .center
        
        let attributedText = NSMutableAttributedString(string: "MISSED", attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 20), NSForegroundColorAttributeName: UIColor.white])
        label.attributedText = attributedText
        return label
    } ()
    
    func setupView() {
        backgroundColor = UIColor.white
        addSubview(nameLabel)
        addSubview(dateLabel)
        addSubview(missedLabel)
        //constraints for label
        
        addConstraintsWithFormat(format: "H:|-8-[v0]-8-|", views: nameLabel)
        addConstraintsWithFormat(format: "H:|-8-[v0]-8-|", views: dateLabel)
        addConstraintsWithFormat(format: "H:[v0(100)]-10-|", views: missedLabel)
        
         addConstraintsWithFormat(format: "V:|-5-[v0]-5-[v1]", views: nameLabel, dateLabel)
         addConstraintsWithFormat(format: "V:|-(<=10)-[v0(40)]-|", views: missedLabel)

    }
}
