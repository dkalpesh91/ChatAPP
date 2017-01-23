//
//  ChatDetailsModel.swift
//  ChatAppForHaptik
//
//  Created by kalpesh dhumal on 1/20/17.
//  Copyright © 2017 kalpesh dhumal. All rights reserved.
//

import Foundation

class ChatDetailsModel: NSObject {
    var body : String?
    var userName : String?
    var name : String?
    var imageURL : String?
    var messageTime : String?
    var fav : Int?
    
    
    init(data:Dictionary<String, Any>?) {
        body = data?["body"] as? String
        userName = data?["username"] as? String
        name = data?["Name"] as? String
        imageURL = data?["image-url"] as? String
        messageTime = data?["message-time"] as? String
        fav = data?["fav"] as? Int
    }
    
}
