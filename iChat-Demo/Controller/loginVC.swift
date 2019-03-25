//
//  LoginVC.swift
//  iChat-Demo
//
//  Created by Genies on 3/23/19.
//  Copyright © 2019 Genies. All rights reserved.
//

import UIKit
import ProgressHUD
class LoginVC: UIViewController {
    //MARK:- Outlets
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var passwordTxtField: UITextField!
    @IBOutlet weak var rePasswordTxtField: UITextField!
    
    //MARK:- Properties
  
    override func viewDidLoad() {
        super.viewDidLoad()
        let keyboardTap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(keyboardTap)
    }
    //MARK:- Action
    @IBAction func loginBtnWasPressed(_ sender: Any) {
        //login method
        loginUser()
    }
    @IBAction func registerBtnWasPressed(_ sender: Any) {
        ProgressHUD.show()
        dismissKeyboard()
        goToCompleteRegister()
    }
    //MARK:- Function
    func loginUser(){
        dismissKeyboard()
        ProgressHUD.show("Login..")
        guard let email = emailTxtField.text else{return}
        guard let password = passwordTxtField.text else{return}
        print(String(describing: "\(email,password)"))
        if !email.isEmpty && !password.isEmpty{
            UserServices.loginUserWith(email, password) { (error) in
                if error != nil{
                    ProgressHUD.showError(String(describing: error!.localizedDescription))
                    return
                }
                ProgressHUD.dismiss()
                
                self.goToMainApplication()
                self.clearTextField()
            }
        }else{
            ProgressHUD.showError("Please Fill All Data")
        }
    }
    func goToCompleteRegister(){
        guard let email = emailTxtField.text else{return}
        guard let password = passwordTxtField.text else{return}
        guard let rePassword = rePasswordTxtField.text else{return}
        if !email.isEmpty && !password.isEmpty && !rePassword.isEmpty{
            if password == rePassword {
                ProgressHUD.dismiss()
                let  mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                let registerVC = mainStoryboard.instantiateViewController(withIdentifier: REGISTER_VC) as! RegisterVC
                registerVC.email = email
                registerVC.password = password
                present(UINavigationController(rootViewController: registerVC), animated: true, completion: nil)
            }else{
                ProgressHUD.showError("Password not Matched.!!")
            }
            
        }else{
            ProgressHUD.showError("Please fill All fields to complete Registration!!!")
        }
    }
    func goToMainApplication(){
        let  mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let mainChatVC = mainStoryboard.instantiateViewController(withIdentifier:MAIN_CHAT_VC_TAB)
        present(mainChatVC, animated: true, completion: nil)
    }
    
    func clearTextField(){
        self.emailTxtField.text = ""
        self.passwordTxtField.text = ""
        self.rePasswordTxtField.text = ""
    }
    @objc func dismissKeyboard(){
        self.view.endEditing(false)
    }
    
}
