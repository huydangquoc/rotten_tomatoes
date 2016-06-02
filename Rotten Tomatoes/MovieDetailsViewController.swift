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
        
        let url = NSURL(string: movie.valueForKeyPath("posters.detailed") as! String)!
        imageView.setImageWithURL(url)
        
        // Process notification for Poster loading
        /*
        // show loading notification
         
        EZLoadingActivity.show("Loading Poster...", disableUI: false)
        let request = NSURLRequest(URL: url)
        imageView.setImageWithURLRequest(request, placeholderImage: nil, success: { (request: NSURLRequest, response: NSHTTPURLResponse?, image: UIImage) in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                // set poster image
                self.imageView.image = image
                // hide loading notification
                EZLoadingActivity.hide()
            })
        }) { (request: NSURLRequest, response: NSHTTPURLResponse?, error: NSError) in
                // process error here
            
                // hide loading notification
                EZLoadingActivity.hide()
        }
        */
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
