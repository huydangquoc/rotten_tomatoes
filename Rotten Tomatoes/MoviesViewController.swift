//
//  MoviesViewController.swift
//  Rotten Tomatoes
//
//  Created by Dang Quoc Huy on 6/1/16.
//  Copyright © 2016 Dang Quoc Huy. All rights reserved.
//

import UIKit
import AFNetworking
import EZLoadingActivity

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
    var movies: [NSDictionary]?
    
    // MARKs: - Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // show loading notification
        // disable UI interaction
        EZLoadingActivity.show("Loading...", disableUI: true)
        
        let url = NSURL(string: "https://coderschool-movies.herokuapp.com/movies?api_key=xja087zcvxljadsflh214")!
        let request = NSURLRequest(URL: url)
        let session = NSURLSession.sharedSession()
        let dataTask = session.dataTaskWithRequest(request) { (data: NSData?, response: NSURLResponse?, error: NSError?) in
            guard error == nil else  {
                print("error loading from URL", error!)
                
                // disable loading notification
                EZLoadingActivity.hide(success: false, animated: true)
                
                return
            }
            
            do {
                // parse response data
                if let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as? NSDictionary {
                    self.movies = json["movies"] as? [NSDictionary]
                    // reload table from main thread
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.tableView.reloadData()
                        // hide loading notification
                        EZLoadingActivity.hide()
                    })
                }
            } catch {
                // TODO: handle error
                
                // hide loading notification
                EZLoadingActivity.hide()
            }
        }
        dataTask.resume()
        
        tableView.dataSource = self
        tableView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
        
        let movie = movies![indexPath.row]
        cell.titleLabel.text = movie["title"] as? String
        cell.synopsisLabel.text = movie["synopsis"] as? String
        
        let url = NSURL(string: movie.valueForKeyPath("posters.thumbnail") as! String)!
        cell.posterView.setImageWithURL(url)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPathForCell(cell)!
        
        let movie = movies![indexPath.row]
        
        let movieDetailsViewController = segue.destinationViewController as! MovieDetailsViewController
        movieDetailsViewController.movie = movie
    }
}
