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
    @IBOutlet weak var searchBar: UISearchBar!
    
    var movies: [NSDictionary]?
    var filteredMovies: [NSDictionary] = []
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
        searchBar.delegate = self
        
        // UI setup
        searchBar.barStyle = UIBarStyle.Black
        searchBar.tintColor = UIColor.colorWithRGBHex(0xFFCC00)
        let textFieldInsideSearchBar = searchBar.valueForKey("searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = UIColor.colorWithRGBHex(0xFFCC00)
        
        refreshControl.backgroundColor = UIColor.blackColor()
        refreshControl.tintColor = UIColor.colorWithRGBHex(0xFFCC00)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
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
        
        let movie: NSDictionary
        if !(searchBar.text?.isEmpty)! {
            movie = filteredMovies[indexPath.row]
        } else {
            movie = movies![indexPath.row]
        }
        
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
        
        if !(searchBar.text?.isEmpty)! {
            return filteredMovies.count
        }
        return movies?.count ?? 0
    }
    
    // Asks the data source for a cell to insert in a particular location of the table view.
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
        
        let movie: NSDictionary
        if !(searchBar.text?.isEmpty)! {
            movie = filteredMovies[indexPath.row]
        } else {
            movie = movies![indexPath.row]
        }
        cell.titleLabel.text = movie["title"] as? String
        cell.synopsisLabel.text = movie["synopsis"] as? String
        
        let url = NSURL(string: movie.valueForKeyPath("posters.thumbnail") as! String)!
        let request = NSURLRequest(URL: url)
        cell.posterView.setImageWithURLRequest(request, placeholderImage: nil, success: { (request: NSURLRequest, response: NSHTTPURLResponse?, image: UIImage) in
            // image comes from network
            if (response != nil) {
                // set poster image with fade in animation
                cell.posterView.setImageWithFadeIn(image)
            }
            // image comes from cache
            else {
                cell.posterView.image = image
            }
        }) { (request: NSURLRequest, response: NSHTTPURLResponse?, error: NSError) in
            // process error here
            debugPrint("error code: \(error.code), description: \(error.localizedDescription)")
        }

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

//
// implement UISearchBarDelegate protocol
//
extension MoviesViewController: UISearchBarDelegate {
    
    // Tells the delegate when the user begins editing the search text.
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        
        searchBar.showsCancelButton = true
    }
    
    // Tells the delegate that the user finished editing the search text.
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        
    }
    
    // Tells the delegate that the cancel button was tapped.
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        
        searchBar.text = ""
        searchBar.showsCancelButton = false
        searchBar.endEditing(true)
        self.tableView.reloadData()
    }
    
    // Tells the delegate that the search button was tapped.
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        searchBar.showsCancelButton = false
        searchBar.endEditing(true)
    }
    
    // Tells the delegate that the user changed the search text.
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        guard movies != nil else { return }
        filteredMovies = (movies!.filter({ (movie) -> Bool in
            let title = movie["title"] as! String
            return title.lowercaseString.containsString(searchText.lowercaseString)
        }))
        
        self.tableView.reloadData()
    }
}
