//
//  Constants.swift
//  iChat-Demo
//
//  Created by Genies on 3/22/19.
//  Copyright © 2019 Genies. All rights reserved.
//

import Foundation
import UIKit
//MARK:typealias
typealias errorCompletion = (_ error:Error?)->Void
typealias successCompletion = (_ success:Bool)->Void
typealias imageCallback = (_ image:UIImage)->Void
//MARK:- NOTIFICATION Name
//MARK:- CELL IDENTIFIRE
let SETTINGS_CELL = "settingsCell"
//MARK:- ViewController ID
let MAIN_CHAT_VC_TAB = "mainChatVC"
let REGISTER_VC = "registerVC"
let CHAT_VC = "chatVC"
//MARK: - segue identifer
let TO_COMPLETE_REGISTER = "toCompleteRegister"
//MARK:UserServices  K >> shortcut for key
public let KEMAIL = "email"
public let KPHONE = "phone"
public let KOBJECTID = "objectID"
public let KCREATEAT = "createAt"
public let KUPDATEAT = "updateAt"
public let KCOUNTRYCODE = "countryCode"
public let KFACEBOOK = "facebook"
public let KLOGINMETHOD = "loginMethod"
public let KPUSHID = "pushID"
public let KFIRSTNAME = "firstName"
public let KLASTNAME = "lastName"
public let KFULLNAME = "fullName"
public let KAVATAR = "avatar"
public let KCURRENTUSER = "currentUser"
public let KISONLINE = "isOnline"
public let KVERIFICATIONCODE = "firebase_verification"
public let KCITY = "city"
public let KCOUNTRY = "country"
public let KBLOCKEDUSERID = "blockedUserID"

//MARK:- contacts
public let KCONTACT = "contact"
public let KCONTACTID = "contactID"
