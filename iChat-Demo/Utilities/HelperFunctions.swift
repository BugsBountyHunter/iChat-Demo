//
//  HelperFunctions.swift
//  iChat-Demo
//
//  Created by Genies on 3/25/19.
//  Copyright © 2019 Genies. All rights reserved.
//

import Foundation
import UIKit
import FirebaseFirestore

//MARK: Global Function
private let dateFormat = "yyyyMMddHHmmss"

func dateFormatter()->DateFormatter{
    let dateFormatter = DateFormatter()
    dateFormatter.timeZone = TimeZone(secondsFromGMT: TimeZone.current.secondsFromGMT())
    dateFormatter.dateFormat = dateFormat
    return dateFormatter
}

//create image from firstname and last name

func createImageFromInitials(_ firstName:String?,lastName:String?,completion:@escaping imageCallback){
    //New image Properties
    var string:String!
    var size = 36
    
    if firstName != nil && lastName != nil{
        guard let fName = firstName?.first else{return}
        guard let lName = lastName?.first else{return}
        string = String(fName).uppercased()+String(lName).uppercased()
    }else{
        guard let fName = firstName?.first else{return}
        string = String(fName).uppercased()
        size = 72
    }
    //create lable in image
    let lblName = UILabel()
    lblName.frame.size = (CGSize(width: 100, height: 100))
    lblName.textColor = .white
    lblName.font = UIFont(name: lblName.font.fontName, size: CGFloat(size))
    lblName.text = string
    lblName.textAlignment = NSTextAlignment.center
    lblName.backgroundColor = .lightGray
    lblName.layer.cornerRadius = 25
    
    UIGraphicsBeginImageContext(lblName.frame.size)
    lblName.layer.render(in: UIGraphicsGetCurrentContext()!)
    
    let img = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    completion(img!)
}
