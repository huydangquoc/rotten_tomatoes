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
import TSMessages

class MoviesViewController: UIViewController {

    // MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
    var movies: [NSDictionary]?
    var refreshControl: UIRefreshControl!
    
    // MARKs: - Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareRefreshControl()
        TSMessage.setDefaultViewController(self.navigationController)
        
        // show loading notification
        // disable UI interaction
        EZLoadingActivity.show("Loading...", disableUI: true)

        loadMovies(true)
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func prepareRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(MoviesViewController.onRefresh), forControlEvents: .ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadMovies(firstTime: Bool) {
        let url = NSURL(string: "https://coderschool-movies.herokuapp.com/movies?api_key=xja087zcvxljadsflh214")!
        let request = NSURLRequest(URL: url)
        let session = NSURLSession.sharedSession()
        let dataTask = session.dataTaskWithRequest(request) { (data: NSData?, response: NSURLResponse?, error: NSError?) in
            guard error == nil else  {
                // clear table content
                // show error
                if self.movies != nil { self.movies!.removeAll() }
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.tableView.reloadData()
                    
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
                    self.movies = json["movies"] as? [NSDictionary]
                    // reload table from main thread
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.tableView.reloadData()
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
        loadMovies(false)
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

//
// implement UITableViewDataSource protocol
//
extension MoviesViewController: UITableViewDataSource {
    
    // Tells the data source to return the number of rows in a given section of a table view.
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return movies?.count ?? 0
    }
    
    // Asks the data source for a cell to insert in a particular location of the table view.
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
        
        let movie = movies![indexPath.row]
        cell.titleLabel.text = movie["title"] as? String
        cell.synopsisLabel.text = movie["synopsis"] as? String
        
        let url = NSURL(string: movie.valueForKeyPath("posters.thumbnail") as! String)!
        cell.posterView.setImageWithURL(url)
        
        return cell
    }
}

//
// implement UITableViewDelegate protocol
//
extension MoviesViewController: UITableViewDelegate {
    
    // Tells the delegate that the specified row is now selected.
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
