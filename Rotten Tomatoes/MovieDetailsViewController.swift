//
//  MovieDetailsViewController.swift
//  Rotten Tomatoes
//
//  Created by Dang Quoc Huy on 6/1/16.
//  Copyright © 2016 Dang Quoc Huy. All rights reserved.
//

import UIKit
//import EZLoadingActivity

class MovieDetailsViewController: UIViewController {

    // MARK: - Properties
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!
    
    var movie: NSDictionary!
    
    // MARK: - Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = movie["title"] as? String
        synopsisLabel.text = movie["synopsis"] as? String
        
        let thumbnailLink = movie.valueForKeyPath("posters.thumbnail") as! String
        let imageLink = self.movie.valueForKeyPath("posters.detailed") as! String
        self.imageView.setImageWithThumbnail(thumbnailLink, imageLink: imageLink)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}

//
// support load image with thumbnail
//
extension UIImageView {
    
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
