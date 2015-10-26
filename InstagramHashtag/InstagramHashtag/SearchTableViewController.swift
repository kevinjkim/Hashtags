//
//  SearchTableViewController.swift
//  InstagramHastag
//
//  Created by Kevin Kim on 10/18/15.
//  Copyright © 2015 Kevin Kim. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController, UISearchBarDelegate {
    
    var accessToken: String = ""
    
    var searchController = UISearchController()
    var numOfResults: Int = 20
    var numArray: [Int] = [10, 20, 30, 40]
    var searched: Bool = false
    
    var hashResults = HashResults()
    var userResults = UserResults()
    let textAnaylzer = TextAnalyzer()
    var sentimentCount = Sentiment()
    var titleString: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = UIRectEdge.None   // so that search bar doesn't overlap status bar
        
        tableView.rowHeight = UIScreen.mainScreen().bounds.width/2
        
        print(accessToken)
        
        setUpSearchBar()
        
        tableView.allowsSelection = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Search Functions
    
    func setUpSearchBar() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        searchController.searchBar.placeholder = "Enter Hashtag"
        searchController.searchBar.delegate = self
        searchController.searchBar.barTintColor = navigationController?.navigationBar.barTintColor
        
        let cancelButtonAttributes: [String: AnyObject] = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        UIBarButtonItem.appearance().setTitleTextAttributes(cancelButtonAttributes, forState: .Normal)
        
        tableView.tableHeaderView = searchController.searchBar
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        if let usrStr = searchBar.text {
            searchController.active = false
            print(usrStr)
            let instaService = InstagramService(accessToken: accessToken)
            instaService.getHashtagResults(usrStr, count: numOfResults, completion: { (let HashtagResults) -> Void in
                if let hashtagResults = HashtagResults {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.updateInfo(hashtagResults)
                        self.navigationItem.title = "#\(usrStr.uppercaseString)"
                        self.titleString = usrStr.uppercaseString
                    }
                }
            })
        } else {
            printAlert("Enter valid text")
        }
    }
    

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (!searched) {
            return 0
        } else if (numOfResults % 2 == 0) {
            return numOfResults/2
        }
        return (numOfResults/2) + 1
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("searchCell", forIndexPath: indexPath) as! searchTableViewCell
        
        let index1 = indexPath.row * 2
        let index2 = index1 + 1
        
        // Images
        if let url1 = NSURL(string: "\(hashResults.imageURLs[index1])") {
            if let data = NSData(contentsOfURL: url1){
                cell.image1.contentMode = UIViewContentMode.ScaleAspectFit
                cell.image1.image = UIImage(data: data)
            }
        }
        
        if let url2 = NSURL(string: "\(hashResults.imageURLs[index2])") {
            if let data = NSData(contentsOfURL: url2){
                cell.image2.contentMode = UIViewContentMode.ScaleAspectFit
                cell.image2.image = UIImage(data: data)
            }
        }
        
        // Tap Recognizer
        let tap1 = UITapGestureRecognizer(target: self, action: Selector("imageTapped:"))
        let tap2 = UITapGestureRecognizer(target: self, action: Selector("imageTapped:"))
        
        cell.image1.addGestureRecognizer(tap1)
        cell.image2.addGestureRecognizer(tap2)
        
        // Tags - to help differentiate later
        cell.image1.tag = index1
        cell.image2.tag = index2
        
        // Likes
        cell.numOfLikes1.text = "\(hashResults.numOfLikes[index1])♥︎"
        cell.numOfLikes2.text = "\(hashResults.numOfLikes[index2])♥︎"
        
        // Corners
        cell.numOfLikes1.layer.cornerRadius = 4
        cell.numOfLikes2.layer.cornerRadius = 4
        cell.numOfLikes1.layer.masksToBounds = true
        cell.numOfLikes2.layer.masksToBounds = true

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    
    // MARK: - UI Functions
    
    func updateInfo(results: HashResults) {
        self.hashResults = results
        self.searched = true
        sentimentCount = textAnaylzer.determineSentimentArray(hashResults.descriptionText)
        tableView.reloadData()
        
        print("positive = \(sentimentCount.positive)")
        print("negative = \(sentimentCount.negative)")
        print("neutral = \(sentimentCount.neutral)")
    }
    
    // MARK: - Alerts
    
    func printAlert(alertMessage: String) {
        let alertController = UIAlertController(title: "Error", message: alertMessage, preferredStyle: .Alert)
        let ok = UIAlertAction(title: "OK", style: .Default) { (_) -> Void in
        }
        alertController.addAction(ok)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func selectMoreOptions(sender: UIBarButtonItem) {
        let actionSheet = UIAlertController(title: "More Options", message: "What would you like to do?", preferredStyle: .ActionSheet)
        let changeNumOfResults =  UIAlertAction(title: "Change Number of Results", style: .Default) { (let action) -> Void in
            self.selectNumOfResults()
        }
        let viewStats = UIAlertAction(title: "View Stats", style: .Default) { (let action) -> Void in
            self.performSegueWithIdentifier("showStats", sender: sender)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel) { (let _) -> Void in
        }
        
        actionSheet.addAction(changeNumOfResults)
        actionSheet.addAction(viewStats)
        actionSheet.addAction(cancel)
        
        self.presentViewController(actionSheet, animated: true, completion: nil)
    }

    func selectNumOfResults() {
        let actionSheet = UIAlertController(title: "Number of Results", message: "How many results would you like to display?", preferredStyle: .ActionSheet)
        
        for number in numArray {
            let resultAction = UIAlertAction(title: "\(number)", style: .Default, handler: { (let action) -> Void in
                self.numOfResults = number
                print(self.numOfResults)
            })
            actionSheet.addAction(resultAction)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel) { (let action) -> Void in
        }
        actionSheet.addAction(cancel)
        
        self.presentViewController(actionSheet, animated: true, completion: nil)
        
    }
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            let vc = segue.destinationViewController as! DetailViewController
            vc.userInfo = self.userResults
        } else if segue.identifier == "showStats" {
            let vc = segue.destinationViewController as! StatsViewController
            vc.sentiment = sentimentCount
            vc.numLikes = hashResults.numOfLikes
            vc.timeStamps = hashResults.timeStamps
            vc.titleString = titleString
        }
    }
    
    func imageTapped(sender: AnyObject) {
        let imageView = sender.view as! UIImageView
        let index = imageView.tag
        
        let instaService = InstagramService(accessToken: accessToken)
        instaService.getUserInfo(hashResults.userIDs[index], completion: { (let userResults) -> Void in
            if let validUserResults = userResults {
                dispatch_async(dispatch_get_main_queue()) {
                    self.userResults = validUserResults
                    self.userResults.captionText = self.hashResults.descriptionText[index]
                    self.performSegueWithIdentifier("showDetail", sender: sender)
                }
            }
        })
    }
    

}
