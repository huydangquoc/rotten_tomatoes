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
    @IBOutlet weak var detailScrollView: UIScrollView!
    @IBOutlet weak var detailContentView: UIView!
    
    var movie: NSDictionary!
    
    // MARK: - Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = movie["title"] as? String
        titleLabel.text = movie["title"] as? String
        synopsisLabel.text = movie["synopsis"] as? String
        
        let thumbnailLink = movie.valueForKeyPath("posters.thumbnail") as! String
        let imageLink = self.movie.valueForKeyPath("posters.detailed") as! String
        self.imageView.setImageWithThumbnail(thumbnailLink, imageLink: imageLink)
        
        // UI setup
        self.view.backgroundColor = UIColor.blackColor()
        self.tabBarController?.tabBar.hidden = true
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
