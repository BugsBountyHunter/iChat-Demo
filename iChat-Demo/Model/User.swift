//
//  User.swift
//  iChat-Demo
//
//  Created by Genies on 3/23/19.
//  Copyright © 2019 Genies. All rights reserved.
//

import Foundation
class User{
    //MARK: - perperties
    let objectID:String //uid
    var pushID:String?
    //MARK: date
    let createAt:Date
    var updateAt:Date
    //MARK: new user information
    var email:String
    var firstName:String
    var lastName:String
    var fullName:String
    var avatar:String
    var isOnline:Bool
    var phoneNumber:String
    var countryCode:String
    var country:String
    var city:String
    
    //MARK:  user Account
    var contacts:[String]
    var blockUsers:[String]
    var loginMethod:String
    
    //init
    init(_ objectID:String,_ pushID:String?,_ createAt:Date ,_ updateAt :Date ,_ email:String ,_ firstName:String ,_ lastName:String ,_ avatar:String = "" ,_ loginMethod:String ,_ phoneNumber:String ,_ city:String ,_ country:String ) {
        self.objectID = objectID
        self.pushID = pushID
        
        self.createAt = createAt
        self.updateAt = updateAt
        
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.fullName = firstName + " " + lastName
        self.avatar = avatar
        self.isOnline = true
        
        self.city = city
        self.country = country
        
        self.loginMethod = loginMethod
        self.phoneNumber = phoneNumber
        self.countryCode = ""
        self.blockUsers = []
        self.contacts = []
        
    }
    init(_ dict:[String:Any]) {
        self.objectID = dict[KOBJECTID] as! String
        self.pushID = dict[KPUSHID] as? String
        //date >> if the date which coming from database not in formal format replace it by current date else used date
        if let created = dict[KCREATEAT] {
            if (created as! String).count != 14 {
                createAt = Date()
            }else{
                createAt = dateFormatter().date(from: created  as! String)!
            }
        }else{
            self.createAt = Date()
        }
     
        //
        if let updated = dict[KUPDATEAT] {
            if (updated as! String).count != 14 {
               updateAt = Date()
            }else{
                updateAt = dateFormatter().date(from: updated as! String)!
            }
        }else{
            self.updateAt = Date()
        }
        //
        if let email = dict[KEMAIL]{
            self.email = email as! String
        }else{
            self.email = ""
        }
        if let fName = dict[KFIRSTNAME]{
            self.firstName = fName as! String
        }else{
            self.firstName = ""
        }
        if let lName = dict[KLASTNAME]{
            self.lastName = lName as! String
        }else{
            self.lastName = ""
        }
        self.fullName = firstName + "" + lastName
        if let avat = dict[KAVATAR]{
            self.avatar = avat as! String
        }else{
            //create image with
            avatar = ""
        }
        if let online = dict[KISONLINE]{
            self.isOnline = online as! Bool
        }else{
             self.isOnline = false
        }
        if let phone = dict[KPHONE]{
            self.phoneNumber = phone as! String
        }else{
            phoneNumber = ""
        }
        if let countryCode = dict[KCOUNTRYCODE]{
            self.countryCode = countryCode as! String
        }else{
            self.countryCode = ""
        }
        
        if let contact = dict[KCONTACT] {
            self.contacts = contact as! [String]
        }else{
            self.contacts = []
        }
        if let blockList = dict[KBLOCKEDUSERID]{
            self.blockUsers = blockList as! [String]
        }else{
            self.blockUsers = []
        }
        if let loginMethod = dict[KLOGINMETHOD]{
            self.loginMethod = loginMethod as! String
        }else{
            self.loginMethod = ""
        }
        if let city = dict[KCITY]{
            self.city = city as! String
        }else{
            self.city = ""
        }
        if let country = dict[KCOUNTRY]{
            self.country = country as! String
        }else{
            self.country = ""
        }
    }
}
