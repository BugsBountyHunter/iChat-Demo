//
//  ProfileVC.swift
//  iChat-Demo
//
//  Created by AhMeD on 3/30/19.
//  Copyright © 2019 Genies. All rights reserved.
//

import UIKit

class ProfileVC: UITableViewController {
    //MARK:- outlets
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var fullNameTxtfield: UILabel!
    @IBOutlet weak var phoneNumberTxt: UILabel!
    @IBOutlet weak var callBtn: UIButton!
    @IBOutlet weak var messageBtn: UIButton!
    @IBOutlet weak var blockedBtn: UIButton!
    
    
    var user:User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUserView()
        tableView.tableFooterView = UIView()
    }
    
    //MARK:- Action
    @IBAction func callBtnWasPressed(_ sender: Any) {
    }
    @IBAction func messageBtnWasPressed(_ sender: Any) {
    }
    
    @IBAction func blockeduserBtnPressed(_ sender: Any) {
        var currentUserBlockedIDs = UserServices.currentUser()!.blockUsers
        if  currentUserBlockedIDs.contains(user.objectID){
            currentUserBlockedIDs.remove(at: currentUserBlockedIDs.index(of: user.objectID)!)
        }else{
            currentUserBlockedIDs.append(user.objectID)
        }
        updateCurrentUserInFirestore(withValue: [KBLOCKEDUSERID:currentUserBlockedIDs]) { (error) in
            if error != nil {
                print(String(describing: error?.localizedDescription))
                return
            }
            self.updateBlockStatus()
        }
    }
    //MARK:- Function
    func initData(_ user:User){
        self.user = user
    }
    func setupUserView(){
        self.fullNameTxtfield.text = user.fullName
        self.phoneNumberTxt.text = user.phoneNumber
        //avatar image
        dataImage(fromString: user.avatar) { (dataImage) in
            if dataImage != nil {
                self.profileImage.image = UIImage(data: dataImage!)?.circleMasked
            }
        }
        updateBlockStatus()
        setupNavigationController()
    }
    
    func setupNavigationController(){
        self.title = "Profile"
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .automatic
        } else {
            // Fallback on earlier versions
        }
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        return 30
    }

    func updateBlockStatus(){

        if user.objectID != UserServices.currentID(){
            self.callBtn.isHidden = false
            self.messageBtn.isHidden = false
            self.blockedBtn.isHidden = false
        }else{
            self.callBtn.isHidden = true
            self.messageBtn.isHidden = true
            self.blockedBtn.isHidden = true
        }
        if (UserServices.currentUser()?.blockUsers.contains(user.objectID))!{
            blockedBtn.setTitle("UnBlocked", for: .normal)
        }else{
            blockedBtn.setTitle("Block User", for: .normal)
        }
    }
    
   
}
