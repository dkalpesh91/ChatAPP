//
//  ErrorCode.swift
//  ChatAppForHaptik
//
//  Created by kalpesh dhumal on 1/20/17.
//  Copyright © 2017 kalpesh dhumal. All rights reserved.
//

import UIKit

class ErrorCode: NSObject {
        var errorCode : String?
        var message : String?
        var messageDetails : String?
        var code : Int?
        var name : String?
        var status : Int?
        
        init(data:Dictionary<String, Any>?) {
            errorCode = data?["errorCode"] as? String
            message = data?["message"] as? String
            messageDetails = data?["messageDetails"] as? String
            code = data?["code"] as? Int
            name = data?["name"] as? String
            status = data?["status"] as? Int
        }
}
