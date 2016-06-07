//
//  DVDsViewController.swift
//  Rotten Tomatoes
//
//  Created by Dang Quoc Huy on 6/7/16.
//  Copyright © 2016 Dang Quoc Huy. All rights reserved.
//

import UIKit
import AFNetworking
import EZLoadingActivity
import TSMessages

private let reuseIdentifier = "DVDsCell"
private let sectionInsets = UIEdgeInsets(top: 10.0, left: 12.0, bottom: 10.0, right: 12.0)

class DVDsViewController: UICollectionViewController {

    // MARK: - Properties
    
    var DVDs: [NSDictionary]?
    var filteredDVDs: [NSDictionary] = []
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        TSMessage.setDefaultViewController(self.navigationController)
        
        // show loading notification
        // disable UI interaction
        EZLoadingActivity.show("Loading...", disableUI: true)
        
        loadDVDs(true)
        
        prepareRefreshControl()
        
        // UI Setup code goes here
    }
    
    override func viewWillAppear(animated: Bool) {
        
        self.tabBarController?.tabBar.hidden = false
    }
    
    func prepareRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(MoviesViewController.onRefresh), forControlEvents: .ValueChanged)
        self.collectionView!.insertSubview(refreshControl, atIndex: 0)
        // this help show refresh control in case empty collection view
        self.collectionView!.alwaysBounceVertical = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loadDVDs(firstTime: Bool) {
        let url = NSURL(string: "https://coderschool-movies.herokuapp.com/dvds?api_key=xja087zcvxljadsflh214")!
        let request = NSURLRequest(URL: url)
        let session = NSURLSession.sharedSession()
        let dataTask = session.dataTaskWithRequest(request) { (data: NSData?, response: NSURLResponse?, error: NSError?) in
            guard error == nil else  {
                // clear table content
                // show error
                if self.DVDs != nil { self.DVDs!.removeAll() }
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.collectionView?.reloadData()
                    
                    var title: String = "Error"
                    if error!.domain == NSURLErrorDomain { title = "Network Error" }
                    // nortify user about error
                    TSMessage.showNotificationWithTitle(title, subtitle: error!.localizedDescription, type: .Error)
                    
                    // hide loading
                    if firstTime { EZLoadingActivity.hide() }
                    self.refreshControl.endRefreshing()
                })
                
                return
            }
            
            do {
                // parse response data
                if let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as? NSDictionary {
                    self.DVDs = json["movies"] as? [NSDictionary]
                    // reload table from main thread
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.collectionView!.reloadData()
                        // hide loading
                        if firstTime { EZLoadingActivity.hide() }
                        self.refreshControl.endRefreshing()
                    })
                }
            } catch {
                // TODO: handle error
                
                // hide loading
                if firstTime { EZLoadingActivity.hide() }
                self.refreshControl.endRefreshing()
            }
        }
        dataTask.resume()
    }
    
    func onRefresh() {
        loadDVDs(false)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return DVDs?.count ?? 0
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! DVDCell
        
        let DVD: NSDictionary
        DVD = DVDs![indexPath.row]
        // set DVD infos
        cell.titleLabel.text = DVD["title"] as? String
        cell.runTimeLabel.text = "\(DVD["runtime"] as! Int) min"
        cell.scoreLabel.text = "\(DVD.valueForKeyPath("ratings.critics_score") as! Int)%"
        let rating = DVD.valueForKeyPath("ratings.critics_rating") as! String
        if rating == "Rotten" { cell.ratingImage.image = UIImage(named: "Rotten") }
        // set DVD thumbnail poster
        let url = NSURL(string: DVD.valueForKeyPath("posters.thumbnail") as! String)!
        let request = NSURLRequest(URL: url)
        cell.thumbnail.setImageWithURLRequest(request, placeholderImage: nil, success: { (request: NSURLRequest, response: NSHTTPURLResponse?, image: UIImage) in
            // image comes from network
            if (response != nil) {
                // set poster image with fade in animation
                cell.thumbnail.setImageWithFadeIn(image)
            }
                // image comes from cache
            else {
                cell.thumbnail.image = image
            }
        }) { (request: NSURLRequest, response: NSHTTPURLResponse?, error: NSError) in
            // process error here
            debugPrint("error code: \(error.code), description: \(error.localizedDescription)")
        }
        
        cell.backgroundColor = UIColor.clearColor()
        // config cell selected background
        let customSelectionView = UIView(frame: cell.frame)
        customSelectionView.backgroundColor = UIColor.colorWithRGBHex(0xFFCC00)
        cell.selectedBackgroundView = customSelectionView
        
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}

// config layout for collection cell
extension DVDsViewController : UICollectionViewDelegateFlowLayout {

    // Asks the delegate for the size of the specified item’s cell.
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSize(width: 140, height: 220)
    }
    
    //3
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
}

