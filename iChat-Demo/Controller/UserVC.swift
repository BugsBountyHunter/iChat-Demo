//
//  UserVC.swift
//  iChat-Demo
//
//  Created by Genies on 3/28/19.
//  Copyright © 2019 Genies. All rights reserved.
//

import UIKit
import Firebase
import ProgressHUD
class UserVC: UITableViewController {
    //MARK:- outlets
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var filterSegmentedController: UISegmentedControl!
    
    //MARK:- Variable
    var allUser = [User]()
    var filterUsers = [User]()
    
    var allUserGropped = [String:[User]]()
    var sectionTitleList = [String]()
    //searchController // navigation controller
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationController()
        tableView.tableFooterView = UIView()
        loadUsers(filter: KCITY)
        
    }
    //MARK:- Action
    
    @IBAction func filterSegmentPressed(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            loadUsers(filter: KCITY)
        case 1:
            loadUsers(filter: KCOUNTRY)
        case 2:
            loadUsers(filter: "")
        default:
            return
        }
    }
    //MARK:- Functions
    func setupNavigationController(){
        self.title = "User"
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
            navigationItem.searchController = searchController
            navigationItem.hidesSearchBarWhenScrolling = false
        } else {
            // Fallback on earlier versions
        }
        setupSearchController()
    }
    func setupSearchController(){
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
    }
    //LoadData
    func loadUsers(filter:String){
        ProgressHUD.show()
        
        var query:Query!
        
        switch filter{
        case KCITY:
            query = reference(.User).whereField(KCITY, isEqualTo: UserServices.currentUser()!.city).order(by: KFIRSTNAME, descending: false)
        case KCOUNTRY:
            query = reference(.User).whereField(KCOUNTRY, isEqualTo: UserServices.currentUser()!.country).order(by: KFIRSTNAME, descending: false)
            print("\(UserServices.currentUser()!.country)")
        default:
            query = reference(.User).order(by: KFIRSTNAME, descending: false)
        }
        query.getDocuments { (snapshot, error) in
            //clear all user from all array
            self.allUser = []
            self.sectionTitleList = []
            self.allUserGropped = [:]
            
            if error != nil {
                print(String(describing: error?.localizedDescription))
                ProgressHUD.showError("\(error!.localizedDescription)")
                self.tableView.reloadData()
                return
            }
            guard let snap = snapshot else{ ProgressHUD.dismiss() ;return }
            if !snap.isEmpty {
                for snapItem in snap.documents {
                   let snapUserData = snapItem.data()
                    let snapUser = User(snapUserData)
                    
                    if snapUser.objectID != UserServices.currentID(){
                        self.allUser.append(snapUser)
                    }
                }
                self.spliteDataIntoSection()
                self.tableView.reloadData()
            }
            // no found data in snap shot
            self.tableView.reloadData()
            ProgressHUD.dismiss()
        }
    }
    fileprivate func spliteDataIntoSection(){
        var sectionTitle:String = ""
        //update
        for user in 0..<self.allUser.count{
            let currentUser = self.allUser[user]
            let firstChar = currentUser.firstName.first!
            let firstCharString = "\(firstChar)"
            
            if firstCharString !=  sectionTitle{
                sectionTitle = firstCharString
                self.allUserGropped[sectionTitle] = []
                
                if !sectionTitleList.contains(sectionTitle){
                    self.sectionTitleList.append(sectionTitle)
                }
                
            }
            self.allUserGropped[firstCharString]?.append(currentUser)
        }
    }
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return 1
        }else{
            return allUserGropped.count
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != ""{
            return filterUsers.count
        }else{
         //find section Title
            let sectionTitle = self.sectionTitleList[section]
            //user for give title
            let users = self.allUserGropped[sectionTitle]
            return users!.count
            
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CHAT_CELL, for: indexPath)  as! ChatCell
        var user:User
        
        if searchController.isActive && searchController.searchBar.text != ""{
            user = filterUsers[indexPath.row]
        }else{
            let sectionTitle = self.sectionTitleList[indexPath.section]
            let users = self.allUserGropped[sectionTitle]
            
            user = users![indexPath.row]
        }
        cell.setupCell(withUser: user, andIndexPath: indexPath)
        cell.delegate = self
        return cell
    }
    // delegate
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if searchController.isActive && searchController.searchBar.text != ""{
            return nil
        }else{
            return self.sectionTitleList[section]
        }
    }

    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        if searchController.isActive && searchController.searchBar.text != "" {
            return nil
        }else{
            return self.sectionTitleList
        }
    }
    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return index
    }

}
//Search Extension
extension UserVC:UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        
        filterContentFor(searchText: searchController.searchBar.text!)
    }
    // 3 scope by default = All
    func filterContentFor(searchText text:String ,withScope scope:String = "All"){
        filterUsers = allUser.filter({ (user) -> Bool in
            //user == every user in array
            return user.firstName.lowercased().contains(text.lowercased())
        })
        tableView.reloadData()
    }
}
//chatCell delegate extension
extension UserVC:ChatCellDelagate{
    func didTapAvatarImage(indexPath: IndexPath) {
        print("u clicked on \(indexPath)")
        //go to Profile
        
        let sb = UIStoryboard(name: "Main", bundle: Bundle.main)
        let profileVC = sb.instantiateViewController(withIdentifier: PROFILE_VC) as! ProfileVC
        
        if searchController.isActive && searchController.searchBar.text != "" {
            profileVC.initData(filterUsers[indexPath.row])
        }else{
            let sectionTitle = self.sectionTitleList[indexPath.section]
            let users = self.allUserGropped[sectionTitle]
            profileVC.initData(users![indexPath.row])
        }
        navigationController?.pushViewController(profileVC, animated: true)
    }
    
    
}
