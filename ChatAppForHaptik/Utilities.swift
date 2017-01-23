//
//  Utilities.swift
//  ChatAppForHaptik
//
//  Created by kalpesh dhumal on 1/21/17.
//  Copyright © 2017 kalpesh dhumal. All rights reserved.
//

import UIKit

class Utilities: NSObject {

//    class func showLoding(withMessage message: String, withView viewController: UIViewController) -> MBProgressHUD {
//        let mbHUD = MBProgressHUD.showAdded(to: viewController.view, animated: true)
//        viewController.view.isUserInteractionEnabled = false
//        mbHUD?.mode = MBProgressHUDModeIndeterminate
//        mbHUD?.detailsLabelText = message
//        return mbHUD!
//    }
//    
//    class func showErrorMessage(_ message: String, withView viewController: UIViewController) -> MBProgressHUD {
//        let hud = MBProgressHUD.showAdded(to: viewController.view, animated: true)
//        hud?.isUserInteractionEnabled = false
//        //    self.view.userInteractionEnabled = NO;
//        hud?.mode = MBProgressHUDModeText
//        hud?.detailsLabelText = message
//        //    [hud hide:YES afterDelay:period];
//        return hud!
//    }
//    
//    class func hideLoadingView(_ viewController: UIViewController) {
//        viewController.view.isUserInteractionEnabled = true
//        MBProgressHUD.hideAllHUDs(for: viewController.view, animated: true)
//    }
//
//    class func showAlertView(title: String, message: String) {
//        UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: "Ok", otherButtonTitles: "").show()
//    }
//
//    class func isInternetAvailable() -> Bool
//    {
//        var zeroAddress = sockaddr_in()
//        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
//        zeroAddress.sin_family = sa_family_t(AF_INET)
//        
//        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
//            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
//                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
//            }
//        }
//        
//        var flags = SCNetworkReachabilityFlags()
//        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
//            return false
//        }
//        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
//        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
//        return (isReachable && !needsConnection)
//    }
    
    class func setInitialImage(initialName: String, fontSize: CGFloat, backgroundColor: UIColor, imageSize : CGSize) -> UIImage {
        var image = UIImage.imageWithColor(color: backgroundColor)
        image = image.imageResize(sizeChange: imageSize)
        let textFont = UIFont(name: "OpenSans-Semibold", size: fontSize)
        let fontHeight = textFont?.lineHeight
        let initialPlace = CGPoint(x: 0, y: (imageSize.height - fontHeight!) / 2)
        //        initialName.characters.count == 2 ? (initialPlace = CGPoint(x: 0, y: 0)) : (initialPlace = CGPoint(x: 0, y: 0))
        image = self.textToImage(text: initialName.uppercased(), fontSize: fontSize, image: image, point: initialPlace)
        //        (UtilitiesSwift.textToImage(drawText: initialName.uppercased(), image: image, point: initialPlace))
        //                image = image.addText(drawText: "M", atPoint: CGPoint(x: 10, y: 10), textColor: nil, textFont: nil)
        //        staffImageImageView.image = image
        //        staffImageImageView.contentMode = .scaleAspectFill
        //        staffImageImageView.clipsToBounds = true
        //        staffImageImageView.layer.cornerRadius = (staffImageImageView.frame.size.width) / 2
        return image
    }
    
    class func textToImage(text: String, fontSize: CGFloat, image: UIImage, point: CGPoint) -> UIImage
    {
        let textColor = UIColor.white
        let textFont = UIFont(name: "OpenSans-Semibold", size: fontSize)!
        
        let textStyle = NSMutableParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        textStyle.alignment = .center
        
        
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(image.size, false, scale)
        
        let textFontAttributes = [
            NSFontAttributeName: textFont,
            NSForegroundColorAttributeName: textColor,
            NSParagraphStyleAttributeName: textStyle
            ] as [String : Any]
        image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))
        print("Image size is \(image.size)")
        
        let rect = CGRect(origin: point, size: image.size)
        text.draw(in: rect, withAttributes: textFontAttributes)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }

    class func HexToColor(hexString: String, alpha:CGFloat? = 1.0) -> UIColor {
        // Convert hex string to an integer
        let hexint = Int(self.intFromHexString(hexStr: hexString))
        let red = CGFloat((hexint & 0xff0000) >> 16) / 255.0
        let green = CGFloat((hexint & 0xff00) >> 8) / 255.0
        let blue = CGFloat((hexint & 0xff) >> 0) / 255.0
        let alpha = alpha!
        // Create color object, specifying alpha as well
        let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        return color
    }
    
    class func intFromHexString(hexStr: String) -> UInt32 {
        var hexInt: UInt32 = 0
        // Create scanner
        let scanner: Scanner = Scanner(string: hexStr)
        // Tell scanner to skip the # character
        scanner.charactersToBeSkipped = NSCharacterSet(charactersIn: "#") as CharacterSet
        // Scan hex value
        scanner.scanHexInt32(&hexInt)
        return hexInt
    }

    
}

extension UIImage {
    class func imageWithColor(color: UIColor) -> UIImage {
        let rect: CGRect = CGRect(x:0, y:0, width:1, height:1)
        UIGraphicsBeginImageContextWithOptions(CGSize(width:1, height:1), false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
}
    
    func addText(drawText: NSString, atPoint: CGPoint, textColor: UIColor?, textFont: UIFont?) -> UIImage{
        
        // Setup the font specific variables
        var _textColor: UIColor
        if textColor == nil {
            _textColor = UIColor.white
        } else {
            _textColor = textColor!
        }
        
        var _textFont: UIFont
        if textFont == nil {
            _textFont = UIFont.systemFont(ofSize: 30)
        } else {
            _textFont = textFont!
        }
        
        // Setup the image context using the passed image
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        
        // Setup the font attributes that will be later used to dictate how the text should be drawn
        let textFontAttributes = [
            NSFontAttributeName: _textFont,
            NSBackgroundColorAttributeName: _textColor,
            ] as [String : Any]
        
        // Put the image into a rectangle as large as the original image
        draw(in: CGRect(x:0, y:0, width:size.width, height:size.height))
        
        // Create a point within the space that is as bit as the image
        let rect = CGRect(x:atPoint.x, y:atPoint.y, width:size.width, height:size.height)
        
        // Draw the text into an image
        drawText.draw(in: rect, withAttributes: textFontAttributes)
        
        // Create a new image out of the images we have created
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // End the context now that we have the image we need
        UIGraphicsEndImageContext()
        
        //Pass the image back up to the caller
        return newImage!
        
    }
    
    
    func imageResize (sizeChange:CGSize)-> UIImage{
        
        let hasAlpha = true
        let scale: CGFloat = 0.0 // Use scale factor of main screen
        
        UIGraphicsBeginImageContextWithOptions(sizeChange, !hasAlpha, scale)
        self.draw(in: CGRect(origin: CGPoint.zero, size: sizeChange))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        return scaledImage!
    }

    
    
}

extension Array where Element: Equatable {
    
    public func uniq() -> [Element] {
        var arrayCopy = self
        arrayCopy.uniqInPlace()
        return arrayCopy
    }
    
    mutating public func uniqInPlace() {
        var seen = [Element]()
        var index = 0
        for element in self {
            if seen.contains(element) {
                remove(at: index)
            } else {
                seen.append(element)
                index += 1
            }
        }
    }
}

extension Array where Element: Hashable {
    
    func mergeDuplicates() -> [Element: Int] {
        var result = [Element: Int]()
        
        self.forEach({ result[$0] = result[$0] ?? 0 + 1 })
        
        return result
    }
    
}
