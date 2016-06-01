//
//  MoviesViewController.swift
//  Rotten Tomatoes
//
//  Created by Dang Quoc Huy on 6/1/16.
//  Copyright © 2016 Dang Quoc Huy. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
    var movies: [NSDictionary]?
    
    // MARKs: - Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = NSURL(string: "https://coderschool-movies.herokuapp.com/movies?api_key=xja087zcvxljadsflh214")!
        let request = NSURLRequest(URL: url)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response: NSURLResponse?, data: NSData?, error: NSError?) in
            do {
                if let json = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary {
                    self.movies = json["movies"] as? [NSDictionary]
                    self.tableView.reloadData()
                }
            } catch {
                // TODO: handle error
            }
        }
        
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
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath)
        
        let movie = movies![indexPath.row]
        cell.textLabel?.text = movie["title"] as? String
        
        
        return cell
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
