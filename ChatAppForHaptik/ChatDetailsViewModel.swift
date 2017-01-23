//
//  ChatDetailsViewModel.swift
//  ChatAppForHaptik
//
//  Created by kalpesh dhumal on 1/20/17.
//  Copyright © 2017 kalpesh dhumal. All rights reserved.
//

import UIKit

@objc protocol ChatDetailsViewModelDelegate {
    //GET Call
    @objc optional func fetchChatDetailsSuccessCallBack(data : [ChatDetailsModel])
    @objc optional func fetchChatDetailsErrorCallBack(error : Error)
    
}



class ChatDetailsViewModel: NSObject {
    static let APPOINTMENT_STATUS_MODEL_TAG = "ChatDetailsModel"
    var chatDetailsViewModelDelegate : ChatDetailsViewModelDelegate? = nil
    
    var httpMethod = ""
    
    func fetchChatDetailsApiCall() {
        let networkCallHeler = NetworkCallHelper()
        networkCallHeler.getChatDetails(){
            (data, error) -> Void in
            if let unWrappedError = error {
                DispatchQueue.main.async(execute: {
                    print("\(unWrappedError)")
                    self.chatDetailsViewModelDelegate?.fetchChatDetailsErrorCallBack!(error: unWrappedError)
                })
            } else {
                if let unwrappedResult = data {
                    DispatchQueue.main.async(execute: {
                        print("\(unwrappedResult)")
                        let response = self.processJSONResponse(data: unwrappedResult)
                        self.chatDetailsViewModelDelegate?.fetchChatDetailsSuccessCallBack!(data: response)
                    })
                }
            }
        }
    }
    
    
    func processJSONResponse(data : Data) -> ([ChatDetailsModel]){
        var chatDetails: [ChatDetailsModel] = []
        var dictionary = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
        
        if (dictionary["count"] != nil) {
            let chatDetailsTemp = dictionary["messages"] as! Array<AnyObject>
            for chatDetailstempObj in chatDetailsTemp {
                let chatDetailsObj = ChatDetailsModel.init(data: chatDetailstempObj as? Dictionary<String, Any>)
                chatDetailsObj.fav = 0
                chatDetails.append(chatDetailsObj)
            }
        }
    
        chatDetails.sort(by: { $0.messageTime?.compare($1.messageTime!) == .orderedDescending})
        
        return (chatDetails)
    }

    
}
