//
//  UserServices.swift
//  iChat-Demo
//
//  Created by Genies on 3/22/19.
//  Copyright © 2019 Genies. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth

class UserServices{
    //MARK:- User login and register function
    //MARK: Register
    class func registerUser(_ email:String,_ password:String ,_ firstName:String ,_ lastName:String ,_ avatar:String = "" ,completion:@escaping errorCompletion){
        //register
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if error != nil {
                completion(error)
                print(error?.localizedDescription as Any)
                return
            }else{
                guard let fireUser = user?.user else {return}
                let newUser = User(fireUser.uid, "", Date(), Date(), fireUser.email!, firstName, lastName, avatar, KEMAIL, "", "", "")
                saveUserLocally(withUser:newUser)
                saveUserToFirestore(withUser: newUser)
                completion(nil)
            }
        }
    }
    //MARK: login
    class func loginUserWith(_ email:String ,_ password:String ,completion:@escaping errorCompletion){
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil {
                completion(error)
                return
            }else{
                //get user from firebase and save locally
                guard let user = user?.user  else {return}
                fetchCurrentUserFromFirestore(WithUserId: user.uid)
                completion(error)
            }
        }
    }
    //MARK: logout
    class func logoutCurrentUser(completion:@escaping successCompletion){
       // UserDefaults.removeObject()
        //removeOneSingnalId()
        UserDefaults.standard.removeObject(forKey: KCURRENTUSER)
        UserDefaults.standard.synchronize()
        do{
            try Auth.auth().signOut()
            completion(true)
        }catch let error as NSError{
            print(String(describing: error.localizedDescription))
            completion(false)
        }
    }
    //MARK:- getCurrentId
   class func currentID()->String{
        return Auth.auth().currentUser!.uid
    }
    class func currentUser()->User?{
        if Auth.auth().currentUser != nil {
            if let dictionary = UserDefaults.standard.object(forKey: KCURRENTUSER){
                return User.init(dictionary as! Dictionary)
            }
        }
        return nil
    }
}//end class
//MARK:- save data locally
func saveUserLocally(withUser user:User){
    UserDefaults.standard.set(convertUserToDictinary(fromUser: user), forKey: KCURRENTUSER)
    UserDefaults.standard.synchronize()
}
func convertUserToDictinary(fromUser user:User)->NSDictionary {
    //convert from date to string
    let createAtString = dateFormatter().string(from: user.createAt)
    let updateAtString = dateFormatter().string(from: user.updateAt)
    
    let userDict = NSDictionary(objects: [user.objectID,createAtString,updateAtString,user.email,user.loginMethod,user.pushID!,user.firstName,user.lastName,user.fullName,user.avatar,user.contacts,user.blockUsers,user.isOnline,user.phoneNumber,user.countryCode,user.city,user.country], forKeys: [KOBJECTID as NSCopying , KCREATEAT as NSCopying , KUPDATEAT as NSCopying , KEMAIL as NSCopying , KLOGINMETHOD as NSCopying , KPUSHID as NSCopying , KFIRSTNAME as NSCopying , KLASTNAME as NSCopying , KFULLNAME  as NSCopying , KAVATAR as NSCopying , KCONTACT as NSCopying , KBLOCKEDUSERID as NSCopying , KISONLINE as NSCopying , KPHONE as NSCopying , KCOUNTRYCODE as NSCopying , KCITY as NSCopying , KCOUNTRY as NSCopying])
    return userDict
}

//MARK:Save user to fireStorage
func saveUserToFirestore(withUser user:User){
    reference(.User).document(user.objectID).setData(convertUserToDictinary(fromUser: user) as! [String:Any]) { (error) in
        print(String(describing: error?.localizedDescription))
    }
}
//MARK: update Current user in firestore
func updateCurrentUserInFirestore(withValue value:[String:Any] , completion:@escaping errorCompletion){
    if let dict = UserDefaults.standard.object(forKey: KCURRENTUSER){
        var tempDictValue = value
        let currentId = UserServices.currentID()
        let updateAt = dateFormatter().string(from: Date())
        
        tempDictValue[KUPDATEAT] = updateAt
        let userObject = (dict as! NSDictionary).mutableCopy() as! NSMutableDictionary
        userObject.setValuesForKeys(tempDictValue)
        
        reference(.User).document(currentId).updateData(tempDictValue) { (error) in
            if error != nil {
                completion(error)
                return
            }
            UserDefaults.standard.setValue(userObject, forKey: KCURRENTUSER)
            UserDefaults.standard.synchronize()
            completion(error)
        }
        
    }
}

//MARK: fetch user from firestore and save it locally
func fetchCurrentUserFromFirestore(WithUserId id:String){
    reference(.User).document(id).getDocument { (snapshot, error) in
        guard let snapshot = snapshot else{return}
        if snapshot.exists{
//            saveUserLocally(withUser: (snapshot.data()! as? User)!)
         print(snapshot.data()  as Any)
            //save data in local
            UserDefaults.standard.setValue(snapshot.data()! as NSDictionary, forKey: KCURRENTUSER)
            UserDefaults.standard.synchronize()
        }
        
    }
    //MARK:- 
}
