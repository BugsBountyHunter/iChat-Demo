//
//  UserServices.swift
//  iChat-Demo
//
//  Created by Genies on 3/22/19.
//  Copyright © 2019 Genies. All rights reserved.
//

import Foundation
import Firebase

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
            guard let user = user?.user  else {return}
            if error != nil {
                completion(error)
                return
            }else{
                //get user from firebase and save locally
                fetchCurrentUserFromFirestore(WithUserId: user.uid)
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
}//end class
//MARK:- save data locally
func saveUserLocally(withUser user:User){
    UserDefaults.standard.set(convertUserToDictinary(fromUser: user), forKey: KCURRENTUSER)
    UserDefaults.standard.synchronize()
}
func convertUserToDictinary(fromUser user:User)->NSDictionary {
    let dateFormatter = DateFormatter()
    //convert from date to string
    let createAtString = dateFormatter.string(from: user.createAt)
    let updateAtString = dateFormatter.string(from: user.updateAt)
    
    let userDict = NSDictionary(objects: [user.objectID,createAtString,updateAtString,user.email,user.loginMethod,user.pushID!,user.firstName,user.lastName,user.fullName,user.avatar,user.contacts,user.blockUsers,user.isOnline,user.phoneNumber,user.countryCode,user.city,user.country], forKeys: [KOBJECTID as NSCopying , KCREATEAT as NSCopying , KUPDATEAT as NSCopying , KEMAIL as NSCopying , KLOGINMETHOD as NSCopying , KPUSHID as NSCopying , KFIRSTNAME as NSCopying , KLASTNAME as NSCopying , KFULLNAME  as NSCopying , KAVATAR as NSCopying , KCONTACT as NSCopying , KBLOCKEDUSERID as NSCopying , KISONLINE as NSCopying , KPHONE as NSCopying , KCOUNTRYCODE as NSCopying , KCITY as NSCopying , KCOUNTRY as NSCopying])
    return userDict
}

//MARK:Save data to fireStorage
func saveUserToFirestore(withUser user:User){
    reference(.User).document(user.objectID).setData(convertUserToDictinary(fromUser: user) as! [String:Any]) { (error) in
        print(String(describing: error?.localizedDescription))
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
}
