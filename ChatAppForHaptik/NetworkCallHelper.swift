//
//  NetworkCallHelper.swift
//  ChatAppForHaptik
//
//  Created by kalpesh dhumal on 1/20/17.
//  Copyright © 2017 kalpesh dhumal. All rights reserved.
//

import UIKit

@objc class NetworkCallHelper: NSObject {
    
let API_URL = "http://haptik.mobi/android/test_data/"


func requestfromURLString(url: String) -> URLRequest {
    // Create the request.
    var request = URLRequest(url: URL(string: url)!)
    // Specify that it will be a GET request
    request.httpMethod = "GET"
    request.timeoutInterval = 60.0
//    // This is how we set header fields
//    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    return request
}




//Mark: This method will accept parameter dictonary value and HTTP Method
func getChatDetails(completionHandler: @escaping (Data?, Error?) -> Void) {
    
    let myUrl = NSURL(string: API_URL);
    
    // Creaste URL Request
    let request = NSMutableURLRequest(url:myUrl! as URL);
    
    // Set request HTTP method to GET. It could be POST as well
    request.httpMethod = "GET"
    
    let session = URLSession.shared
    let task = session.dataTask(with: request as URLRequest) {
        (
        data, response, error) in
            if error != nil {
                NSLog("ERROR", "=\(error)");
                completionHandler(nil, error)
            } else {
                let dataString = String(data: data!, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
                print(dataString!)
                completionHandler(data, nil)
            }
        
    }
    
    task.resume()
}
    
    static func loadImageFromUrl(url: String, view: UIImageView){
        
        // Create Url from string
        let url = NSURL(string: url)!
        
        // Download task:
        // - sharedSession = global NSURLCache, NSHTTPCookieStorage and NSURLCredentialStorage objects.
        let task = URLSession.shared.dataTask(with: url as URL) { (responseData, responseUrl, error) -> Void in
            // if responseData is not null...
            if let data = responseData{
                
                // execute in UI thread
                DispatchQueue.main.async{
                    view.image = UIImage(data: data)
                }
            }
        }
        
        // Run task
        task.resume()
    }
    
}
