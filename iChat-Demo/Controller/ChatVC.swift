//
//  ChatVC.swift
//  iChat-Demo
//
//  Created by Genies on 3/23/19.
//  Copyright © 2019 Genies. All rights reserved.
//

import UIKit
import FirebaseFirestore
class ChatVC: UIViewController {
    //MARK:- outlets
    @IBOutlet weak var tableView: UITableView!
    //MARK:- Properties
    var recentChats = [NSDictionary]()
    var filterChats = [NSDictionary]()
    
    var recentListener:ListenerRegistration!
    var searchController = UISearchController(searchResultsController: nil)
    override func viewWillAppear(_ animated: Bool) {
        loadRecentChats()
        tableView.tableFooterView = UIView()
    }
    override func viewWillDisappear(_ animated: Bool) {
        recentListener.remove()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationController()
        setTableViewHeader()
    }
    //MARK:- Action
    @objc func groupButtonPressed(){
        //selectedUserForChat(isGroup:True)
    }
    //MARK:- function
    func setupNavigationController(){
        self.title = "Recent"
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationItem.largeTitleDisplayMode = .automatic
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
    //Load RecentChat
    func loadRecentChats(){
        recentListener = reference(.Recent).whereField(KUSERID, isEqualTo: UserServices.currentID()).addSnapshotListener({ (snapshot, error) in
            guard let snapshot = snapshot else{return}
            self.recentChats = []
            if !snapshot.isEmpty {
                let sorted = ((createDictionary(fromSnapshot: snapshot.documents)) as NSArray).sortedArray(using: [NSSortDescriptor(key: KDATE, ascending: false)]) as! [NSDictionary]
                for recent in sorted {
                    if recent[KLASTMESSAGE] as! String != "" && recent[KCHATROOMID] as? String != nil && recent[KRECENTID] != nil {
                        self.recentChats.append(recent)
                    }
                    reference(.Recent).whereField(KCHATROOMID, isEqualTo: recent[KCHATROOMID] as! String ).getDocuments(completion: { (snapshot, error) in
                        
                    })
                }
                self.tableView.reloadData()
            }
        })
    }
    
    //Custome header view
    func setTableViewHeader(){
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 45))
        
        let buttonView = UIView(frame: CGRect(x: 0, y: 5, width: tableView.frame.width, height: 35))
        let groupButton = UIButton(frame: CGRect(x: tableView.frame.width - 110, y: 10 , width: 100, height: 20))
        groupButton.addTarget(self, action: #selector(self.groupButtonPressed), for: .touchUpInside)
        groupButton.setTitle("New Group", for: .normal)
        groupButton.setTitleColor(#colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1), for: .normal)
        
        let lineView = UIView(frame: CGRect(x: 0, y: headerView.frame.height - 1 , width: tableView.frame.width, height: 1))
        lineView.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        
        buttonView.addSubview(groupButton)
        headerView.addSubview(buttonView)
        headerView.addSubview(lineView)
        tableView.tableHeaderView = headerView
    }

}
//Search Extension
extension ChatVC:UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}

//tableview extension
extension  ChatVC:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive  && searchController.searchBar.text != ""{
            return filterChats.count
        }else{
            return recentChats.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RECENT_CHAT_CELL, for: indexPath) as! RecentChatCell
        var recent:NSDictionary!
        if searchController.isActive && searchController.searchBar.text != "" {
            recent = filterChats[indexPath.row]
        }else{
            recent = recentChats[indexPath.row]
        }
        cell.setupCell(withRecentChat: recent, andIndexPath: indexPath)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return  true
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        var tempRecent:NSDictionary!
        if searchController.isActive && searchController.searchBar.text != ""{
            tempRecent = filterChats[indexPath.row]
        }else{
            tempRecent = recentChats[indexPath.row]
        }
        
        //mute
        var muteTitle = "Unmute"
        var mute = false
        
        if (tempRecent[KMEMBERSTOPUSH] as! [String]).contains(UserServices.currentID()){
            muteTitle = "Mute"
            mute = true
        }
        let deleteAction = UITableViewRowAction(style: .destructive, title: "DELETE") { (action, index) in
            //how to delete element
            self.recentChats.remove(at: indexPath.row)
            deleteRecentChat(tempRecent)
            tableView.reloadData()
        }
        let muteAction = UITableViewRowAction(style:.default, title: muteTitle) { (action, index) in
            //UPDATE MUTE STATUS
            print(indexPath.row)
        }
        muteAction.backgroundColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
        //delete
        return [deleteAction,muteAction]
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        var tempRecent:NSDictionary!
        if searchController.isActive && searchController.searchBar.text != "" {
            tempRecent = filterChats[indexPath.row]
        }else{
            tempRecent = recentChats[indexPath.row]
        }
        restartResentChat(tempRecent)
        
    }
}
//Recent cell Delegate
extension ChatVC:RecentChatCellDelegate{
    func didTapAvatarImage(indexPath: IndexPath) {
        var tempRecent:NSDictionary!
        if searchController.isActive && searchController.searchBar.text != "" {
            tempRecent = filterChats[indexPath.row]
        }else{
            tempRecent = recentChats[indexPath.row]
        }
        if tempRecent[KTYPE] as! String == KPRIVATE {
            reference(.User).document(tempRecent[KWITHUSERUSERID] as! String).getDocument { (snapshot, error) in
                guard let snapshot = snapshot else{return}
                if snapshot.exists {
                    let userDict = snapshot.data()
                    let tempUser = User(userDict!)
                    self.showUserProfile(user: tempUser)
                }
            }
        }
    }
}
extension UIViewController{
    func showUserProfile(user:User){
        let sb = UIStoryboard(name: "Main", bundle: Bundle.main)
        let profileVC = sb.instantiateViewController(withIdentifier: PROFILE_VC) as! ProfileVC
        profileVC.user = user
        self.navigationController?.pushViewController(profileVC, animated: true)
    }
}
