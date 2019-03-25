//
//  RegisterVC.swift
//  iChat-Demo
//
//  Created by Genies on 3/23/19.
//  Copyright © 2019 Genies. All rights reserved.
//

import UIKit
import ProgressHUD
class RegisterVC: UIViewController {
    //MARK:-outlets
    
    @IBOutlet weak var firstNameTxtfield: UITextField!
    @IBOutlet weak var lastNameTxtField: UITextField!
    @IBOutlet weak var countryTxtField: UITextField!
    @IBOutlet weak var cityTxtField: UITextField!
    @IBOutlet weak var phoneTxtField: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    
    //MARK:- Properties
    var email:String!
    var password:String!
    var profileIMG:UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let keyboardDismissTap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(keyboardDismissTap)
        print(String(describing:"\(email , password)"))
    }
    
    
    //MARK:Action
    @IBAction func backButtonWasPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func doneButtonWasPressed(_ sender: UIBarButtonItem) {
        dismissKeyboard()
        guard let firstName = firstNameTxtfield.text else{return}
        guard let lastName = lastNameTxtField.text else{return}
        guard let country = countryTxtField.text else{return}
        guard let city = cityTxtField.text else{return}
        guard let phoneNumber = phoneTxtField.text else{return}
        
        let fullName = firstName+" "+lastName
//        var tempDict:Dictionary = [KFIRSTNAME:firstName,KLASTNAME:lastName,KCOUNTRY:country,KCITY:city,KPHONE:phoneNumber] as [String:Any]
        var tempDict:[String:Any] = [KFIRSTNAME:firstName,KLASTNAME:lastName,KFULLNAME:fullName,KCOUNTRY:country,KCITY:city,KPHONE:phoneNumber]
        if profileIMG == nil {
            //create custom image
            createImageFromInitials(firstName, lastName: lastName) { (avatarImage) in
                //convert image to data
                let avatarData = avatarImage.jpegData(compressionQuality: 0.7)
                //convert it to string URl
                let avatarString = avatarData?.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
                tempDict[KAVATAR] = avatarString
                self.completeRegister(tempDict)
            }
        }else{
            //covert it to data
            let profileData = profileIMG?.jpegData(compressionQuality: 0.7)
            //and convert data to string as ImageURL
            let profileImageStringURL = profileData?.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
            tempDict[KAVATAR] = profileImageStringURL
            //finishRegistrion(withValue:Dict)
            self.completeRegister(tempDict)
            
        }

    }
    //MARK:- Function
    func completeRegister(_ withDictValue:[String:Any]){
        guard let firstName = firstNameTxtfield.text else{return}
        guard let lastName = lastNameTxtField.text else{return}
        guard let country = countryTxtField.text else{return}
        guard let city = cityTxtField.text else{return}
        guard let phoneNumber = phoneTxtField.text else{return}
        ProgressHUD.show()
        if !firstName.isEmpty && !lastName.isEmpty && !country.isEmpty && !city.isEmpty && !phoneNumber.isEmpty {
            UserServices.registerUser(email, password, firstName, lastName) { (error) in
                if error != nil{
                    print(String(describing: error?.localizedDescription))
                    ProgressHUD.showError(error?.localizedDescription)
                    return
                }
                updateCurrentUserInFirestore(withValue: withDictValue, completion: { (error) in
                    if error != nil{
                        DispatchQueue.main.async {
                            ProgressHUD.showError("\(error!.localizedDescription)")
                            print(String(describing: "\(error!.localizedDescription)"))
                        }
                        return
                    }
                    self.goToMainApplication()
                    ProgressHUD.dismiss()
                })

            }
        
        }else{
            ProgressHUD.showError("Please Complete all information to Register ")
        }
    }
    func goToMainApplication(){
        let mainStroyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let mainChatVC = mainStroyboard.instantiateViewController(withIdentifier: MAIN_CHAT_VC_TAB)
        present(mainChatVC, animated: true, completion: nil)
    }
    @objc func dismissKeyboard(){
        self.view.endEditing(false)
    }
    func clearAllTextfiled(){
        firstNameTxtfield.text = ""
        lastNameTxtField.text = ""
        countryTxtField.text = ""
        cityTxtField.text = ""
        phoneTxtField.text = ""
    }

}
