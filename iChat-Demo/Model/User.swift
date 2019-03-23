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
}
