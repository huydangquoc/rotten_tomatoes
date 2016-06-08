//
//  DVDDetailsViewController.swift
//  Rotten Tomatoes
//
//  Created by Dang Quoc Huy on 6/8/16.
//  Copyright © 2016 Dang Quoc Huy. All rights reserved.
//

import UIKit

class DVDDetailsViewController: UIViewController {

    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var detailContentView: UIView!
    @IBOutlet weak var swipeButton: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(DVDDetailsViewController.onDetailViewSwipe))
        swipeUp.direction = .Up
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(DVDDetailsViewController.onDetailViewSwipe))
        swipeDown.direction = .Down
        swipeButton.addGestureRecognizer(swipeUp)
        swipeButton.addGestureRecognizer(swipeDown)
        swipeButton.userInteractionEnabled = true
        
        // UI setup
        self.view.backgroundColor = UIColor.blackColor()
        self.tabBarController?.tabBar.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func onDetailViewSwipe(sender: UIGestureRecognizer) {
        if let swipeGesture = sender as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.Up:
                let frame = self.posterImage.frame
                UIView.animateWithDuration(0.5, animations: {
                    self.detailContentView.frame = frame
                })
            case UISwipeGestureRecognizerDirection.Down:
                let frame = self.detailContentView.frame
                UIView.animateWithDuration(0.5, animations: {
                    self.detailContentView.frame = CGRect(  x: frame.origin.x,
                                                            y: (frame.height - 150 + frame.origin.y),
                                                            width: frame.width,
                                                            height: 150)
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
