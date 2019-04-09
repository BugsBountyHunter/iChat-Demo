//
//  Recent.swift
//  iChat-Demo
//
//  Created by AhMeD on 3/31/19.
//  Copyright © 2019 Genies. All rights reserved.
//

import Foundation

//string return that's chatRoomId
func startPrivateChat(user1:User,withUser user2:User)->String{
    
    let userId1 = user1.objectID // uid user1
    let userId2 = user2.objectID // uid user2
    
    var chatRoomId = ""
    
    let value = userId1.compare(userId2).rawValue
    /*
     value left = userId1  ||  right = userId2
     case orderedAscending = -1
     The left operand is smaller than the right operand.
     case orderedSame  = 0
     The two operands are equal.
     case orderedDescending  = 1
     The left operand is greater than the right operand.
     */
    if value < 0 {
        chatRoomId = userId1 + userId2
    }else{
        chatRoomId = userId2 + userId1
    }
    
    let users = [user1,user2]
    let members = [userId1,userId2]
    
    createRecent(member: members, chatRoomId: chatRoomId, withUser: "", type: KPRIVATE, users:users, avatarGroup: nil)
    
    return chatRoomId
}

func createRecent(member:[String],chatRoomId:String,withUser:String , type:String,users:[User]?,avatarGroup:String?){
    var tempMembers = member // contain uids fro private chat user
    
    reference(.Recent).whereField(KCHATROOMID, isEqualTo: chatRoomId).getDocuments { (snapshot, error) in
        guard let snapshot = snapshot else{return}
        
        if !snapshot.isEmpty{
            for recent in snapshot.documents{
                let currentRecent = recent.data() as Dictionary
                if let currentUserId = currentRecent[KUSERID]{
                    if tempMembers.contains(currentUserId as! String) {
                        tempMembers.remove(at: tempMembers.index(of: currentUserId as! String)!)
                    }
                }
            }
        }
    }
    
    //create new item
    for userId in tempMembers{
     createRecentItem(userId: userId, chatRoomId: chatRoomId, members: member, withUser: withUser, type: type, users: users, avatarOfGroup: avatarGroup)
    }
    
}
func createRecentItem(userId:String,chatRoomId:String , members:[String] , withUser withUserName:String , type:String , users:[User]?,avatarOfGroup:String?){
    
    let localReference = reference(.Recent).document()
    let recentId = localReference.documentID
    
    let date = dateFormatter().string(from: Date())
    
    var recent = [String:Any]()
    
    if type == KPRIVATE {
        //Private
        var withUser:User?
        if users != nil && users!.count>0{
            if userId == UserServices.currentID(){
                //current user is first
                withUser = users?.last
            }else{
                withUser = users?.first
            }
        }
        
        recent = [KRECENTID:recentId,
                  KUSERID:userId,
                  KCHATROOMID:chatRoomId,
                  KMEMBERS:members,
                  KMEMBERSTOPUSH:members,
                  KWITHUSERFULLNAME:withUser!.fullName,
                  KWITHUSERUSERID:withUser!.objectID,
                  KLASTMESSAGE:"",
                  KCOUNTER:0,
                  KDATE:date,
                  KTYPE:type,
                  KAVATAR:withUser!.avatar]
    }else{
        //Group
        if avatarOfGroup != nil{
            recent = [KRECENTID:recentId,
                      KUSERID:userId,
                      KCHATROOMID:chatRoomId,
                      KMEMBERS:members,
                      KMEMBERSTOPUSH:members,
                      KWITHUSERFULLNAME:withUserName,
                      KLASTMESSAGE:"",
                      KCOUNTER:0,
                      KDATE:date,
                      KTYPE:type,
                      KAVATAR:avatarOfGroup!]
        }
    }
    localReference.setData(recent)
}
//Delete Recent
func deleteRecentChat(_ recentChat:NSDictionary){
    if let recentId = recentChat[KRECENTID]{
        reference(.Recent).document(recentId as! String).delete()
    }
}
//Restart chat
func restartResentChat(_ recentChat:NSDictionary){
    if recentChat[KTYPE] as! String == KPRIVATE {
     createRecent(member: recentChat[KMEMBERSTOPUSH] as! [String], chatRoomId: recentChat[KCHATROOMID] as! String, withUser: recentChat[KWITHUSERFULLNAME] as! String, type: KPRIVATE, users: [UserServices.currentUser()!], avatarGroup: nil)
    }
    if recentChat[KTYPE] as! String == KGROUP {
        createRecent(member: recentChat[KMEMBERSTOPUSH] as! [String], chatRoomId: recentChat[KCHATROOMID] as! String, withUser: recentChat[KWITHUSERFULLNAME] as! String, type: KGROUP, users: nil, avatarGroup: recentChat[KAVATAR] as? String)
    }
}
