//
//  extension.swift
//  medication-reminder
//
//  Created by Stanley Moon on 2017-04-15.
//  Copyright © 2017 Vikas Gandhi. All rights reserved.
//

import Foundation
import UIKit

//setting theme color
extension UIColor {
    //mavencare's theme color
    static var themeColor : UIColor {
        return UIColor(red: 52/255.0, green: 170/255.0, blue: 216/255.0, alpha: 1.0)
    }
    
}

//extension for layouts.
extension UIView {
    func addConstraintsWithFormat (format: String, views: UIView...){
        var viewsDictionary = [String:UIView] ()
        for (index,view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
}
