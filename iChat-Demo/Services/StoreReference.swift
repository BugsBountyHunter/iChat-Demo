//
//  StoreReference.swift
//  iChat-Demo
//
//  Created by Genies on 3/23/19.
//  Copyright © 2019 Genies. All rights reserved.
//

import Foundation
import FirebaseFirestore

enum FireCollectionReference:String {
    case User
    case Typing
    case Recent
    case Message
    case Group
    case Call
}
func reference(_ collectionReference:FireCollectionReference)->CollectionReference{
    return Firestore.firestore().collection(collectionReference.rawValue)
}
