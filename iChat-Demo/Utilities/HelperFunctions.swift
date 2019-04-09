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


//create avatar Image from imageURL
func dataImage(fromString imgString:String,withBlock:imageDataCallback){
    let dataImage = Data(base64Encoded: imgString, options: Data.Base64DecodingOptions(rawValue: 0))
    withBlock(dataImage as Data?)
    
}
//create dictinary from calls and chats
func createDictionary(fromSnapshot snapshot:[DocumentSnapshot])->[NSDictionary]{
    var allMessage:[NSDictionary] = []
    for snap in snapshot {
        allMessage.append(snap.data()! as NSDictionary)
    }
    return allMessage
}
func timeElapsed(date:Date)->String {
    let sec = date.timeIntervalSince(date)
    var elapsed:String?
    if sec < 60 {
        elapsed = "Just now"
    }else if sec < 60*60 { // from minutes
        let minutes = Int(sec/60)
        var minTxt = "min"
        if minutes > 1 {
            minTxt = "mins"
        }
        
         elapsed = "\(minutes) \(minTxt)"
    }else if sec < 24 * 60 * 60 {
        let hours = Int(sec/(60*60))
        var hourTxt = "hour"
        if hours > 1 {
            hourTxt = "hours"
        }
         elapsed = "\(hours) \(hourTxt)"
    }else{
        let currentDateFormatter = dateFormatter()
        currentDateFormatter.dateFormat = "dd/MM/YYYY"
        elapsed = "\(currentDateFormatter.string(from: date))"
    }
    return elapsed!
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
//MARK:- Extension

extension UIImage{
    
    //Properties
    var isPortrait:Bool { return size.height > size.width}
    var isLandscape:Bool {return size.width > size .height}
    //get mim width or height
    var breadth:CGFloat {return min(size.width, size.height)}
    //create a new width and height based on ==== ( min )
    var breadthSize:CGSize{return CGSize(width: breadth, height: breadth)}
    var breadthRect:CGRect{return CGRect(origin: .zero, size: breadthSize)}
    
    var circleMasked:UIImage?{
        UIGraphicsBeginImageContextWithOptions(breadthSize, false, scale)
        // all code in defer do after all function end
        defer{UIGraphicsEndImageContext()}
        guard let cgImage = cgImage?.cropping(to: CGRect(origin: CGPoint(x: isLandscape ? floor((size.width - size.height)/2):0, y: isPortrait ? floor((size.height -  size.width)/2): 0), size: breadthSize)) else{return nil}
        UIBezierPath(ovalIn: breadthRect).addClip()
        UIImage(cgImage: cgImage).draw(in: breadthRect)
        return UIGraphicsGetImageFromCurrentImageContext()
        //origin: isLandscape ? floor((size.width - size.height)/2):0 ,y: isPortrait ? floor((size.height -  size.width)/2): 0, size: breadthSize)
    }
    
    
    
    
    
    
    
}
