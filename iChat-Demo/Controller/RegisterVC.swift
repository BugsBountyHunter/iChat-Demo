//
//  RegisterVC.swift
//  iChat-Demo
//
//  Created by Genies on 3/23/19.
//  Copyright © 2019 Genies. All rights reserved.
//

import UIKit

class RegisterVC: UIViewController {
    //MARK:-outlets
    
    @IBOutlet weak var firstNameTxtfield: UITextField!
    @IBOutlet weak var lastNameTxtField: UITextField!
    @IBOutlet weak var countryTxtField: UITextField!
    @IBOutlet weak var cityTxtField: UITextField!
    @IBOutlet weak var phoneTxtField: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    
    //MARK:-Properties
    var email:String!
    var password:String!
    var profileIMG:UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK:Action
    
    @IBAction func backButtonWasPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButtonWasPressed(_ sender: UIBarButtonItem) {
        let mainStroyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let mainChatVC = mainStroyboard.instantiateViewController(withIdentifier: MAIN_CHAT_VC_TAB)
        present(mainChatVC, animated: true, completion: nil)
    }

}
