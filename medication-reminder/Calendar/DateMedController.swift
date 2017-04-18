//
//  DateMedController.swift
//  medication-reminder
//
//  Created by Stanley Moon on 2017-04-16.
//  Copyright © 2017 Vikas Gandhi. All rights reserved.
//

import UIKit
import SwiftyJSON

class DateMedController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var timer: Timer!
    var timer2: Timer!
    var date: Date!
    
    let cellId = "cellId"
    var dateMeds = [Med]()
    // var profiles = [Profile()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = " medication"
        self.navigationController?.navigationBar.tintColor = UIColor.white
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(DateCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (dateMeds.count == 0){
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 40))
            label.textColor = UIColor.themeColor
            label.center = self.view.center
            label.textAlignment = .center
            label.text = "There are no scheduled Medication"
            self.collectionView?.addSubview(label)
        }

        return dateMeds.count
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let listCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! DateCell
        
        
        listCell.layer.shouldRasterize = true;
        listCell.layer.rasterizationScale = UIScreen.main.scale
        listCell.layer.cornerRadius = 5
        listCell.layer.borderWidth = 1
        listCell.layer.borderColor = UIColor.themeColor.withAlphaComponent(0.6).cgColor
        listCell.dateMed = dateMeds[indexPath.row]
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


class DateCell: UICollectionViewCell {
    
    var dateMed = Med() {
        didSet {
            if let name = dateMed.name {
                let attributedText = NSMutableAttributedString(string: name, attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14),NSForegroundColorAttributeName: UIColor.themeColor])
                if let dosage = dateMed.dosage {
                    attributedText.append(NSAttributedString(string: "\n\(dosage)", attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 14), NSForegroundColorAttributeName: UIColor(red: 155/255, green: 161/255, blue: 171/255, alpha:1) ] ))
                }
                nameLabel.attributedText = attributedText
            }
            if let timeParsed = dateMed.timeParsed{
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
    
    
    func setupView() {
        backgroundColor = UIColor.white
        addSubview(nameLabel)
        addSubview(dateLabel)
        
        //constraints for label
        addConstraintsWithFormat(format: "H:|-8-[v0]-8-|", views: nameLabel)
        addConstraintsWithFormat(format: "H:|-8-[v0]-8-|", views: dateLabel)
     
        addConstraintsWithFormat(format: "V:|-5-[v0]-5-[v1]", views: nameLabel, dateLabel)
        
    }
}
