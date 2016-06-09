//
//  DVDDetailsViewController.swift
//  Rotten Tomatoes
//
//  Created by Dang Quoc Huy on 6/8/16.
//  Copyright © 2016 Dang Quoc Huy. All rights reserved.
//

import UIKit

class DVDDetailsViewController: UIViewController {

    // MARK: - Properties
    
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var swipeView: UIView!
    @IBOutlet weak var swipeButton: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!
    @IBOutlet weak var swipeView_HeightConstrant: NSLayoutConstraint!
    
    var DVD: NSDictionary!
    
    // MARK: - Functions
    
    // Called after the controller's view is loaded into memory
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // config swipe up/down gesture for swipeView
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(DVDDetailsViewController.onDetailViewSwipe))
        swipeUp.direction = .Up
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(DVDDetailsViewController.onDetailViewSwipe))
        swipeDown.direction = .Down
        swipeButton.addGestureRecognizer(swipeUp)
        swipeButton.addGestureRecognizer(swipeDown)
        swipeButton.userInteractionEnabled = true
        
        // retreive DVD title and synopsis info
        titleLabel.text = DVD["title"] as? String
        synopsisLabel.text = DVD["synopsis"] as? String
        
        // retreive DVD poster (load low resolution first, full size later)
        let thumbnailLink = DVD.valueForKeyPath("posters.thumbnail") as! String
        let imageLink = self.DVD.valueForKeyPath("posters.detailed") as! String
        self.posterImage.setImageWithThumbnail(thumbnailLink, imageLink: imageLink)

        // UI setup
        self.view.backgroundColor = UIColor.blackColor()
        self.tabBarController?.tabBar.hidden = true
    }

    // Sent to the view controller when the app receives a memory warning.
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // triggered on event swipe up/down swipeView
    func onDetailViewSwipe(sender: UIGestureRecognizer) {
        if let swipeGesture = sender as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.Up:
                let height = self.posterImage.frame.height
                UIView.animateWithDuration(0.5, animations: {
                    self.swipeView_HeightConstrant.constant = height
                    self.view.layoutIfNeeded()
                })
            case UISwipeGestureRecognizerDirection.Down:
                UIView.animateWithDuration(0.5, animations: {
                    self.swipeView_HeightConstrant.constant = 150
                    self.view.layoutIfNeeded()
                })
            default:
                break
            }
        }
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
