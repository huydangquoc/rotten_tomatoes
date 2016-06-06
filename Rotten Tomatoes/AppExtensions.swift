//
//  AppExtensions.swift
//  Rotten Tomatoes
//
//  Created by Dang Quoc Huy on 6/6/16.
//  Copyright © 2016 Dang Quoc Huy. All rights reserved.
//

import UIKit

//
// Extend UIColor
//
extension UIColor {
    
    class func colorWithRGBHex(hex: Int, alpha: Float = 1.0) -> UIColor {
        
        let r = Float((hex >> 16) & 0xFF)
        let g = Float((hex >> 8) & 0xFF)
        let b = Float((hex) & 0xFF)
        
        return UIColor(red: CGFloat(r / 255.0), green: CGFloat(g / 255.0), blue:CGFloat(b / 255.0), alpha: CGFloat(alpha))
    }
}

//
// Extend UIImageView
//
extension UIImageView {
    
    /**
     Set image with fade in animation
     */
    func setImageWithFadeIn(image: UIImage) {
        self.alpha = 0.0
        self.image = image
        UIView.animateWithDuration(1.5) {
            self.alpha = 1.0
        }
    }

    /**
     Load thumbnail, then load full size image
     */
    func setImageWithThumbnail(thumbnailLink: String, imageLink: String) {
        
        let thumbnailURL = NSURL(string: thumbnailLink)!
        // load thumbnail poster first
        
        let request = NSURLRequest(URL: thumbnailURL)
        self.setImageWithURLRequest(request, placeholderImage: nil, success: { (request: NSURLRequest, response: NSHTTPURLResponse?, image: UIImage) in
            // load thumbnail image
            self.image = image
            // then, load full size image
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                let url = NSURL(string: imageLink)!
                self.setImageWithURL(url)
            })
            
        }) { (request: NSURLRequest, response: NSHTTPURLResponse?, error: NSError) in
            // process error here
            debugPrint("error code: \(error.code), description: \(error.localizedDescription)")
        }
    }
}
