//
//  WebViewController.swift
//  InstagramHastag
//
//  Created by Kevin Kim on 10/18/15.
//  Copyright © 2015 Kevin Kim. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, UIWebViewDelegate {
    @IBOutlet weak var webView: UIWebView!
    
    var client_id = ""      // ENTER INSTAGRAM CLIENT_ID HERE
    var client_secret = ""  // ENTER INSTAGRAM CLIENT_SECRET HERE
    var redirect_uri = ""   // ENTER INSTAGRAM REDIRECT_URI HERE
    var code = ""
    var access_token = ""
    
    var authenticated: Bool = false {
        didSet {
            self.navigationItem.rightBarButtonItem?.enabled = true
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.delegate = self

        self.navigationItem.rightBarButtonItem?.enabled = false
        
        let url = NSURL(string: "https://api.instagram.com/oauth/authorize/?client_id=\(client_id)&redirect_uri=\(redirect_uri)&response_type=code")
        
        webView.loadRequest(NSURLRequest(URL: url!))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: - Web View Functions
    
    
    func webViewDidFinishLoad(webView: UIWebView) {
        let currentURL : String = (webView.request?.URL!.absoluteString)!
        if currentURL.rangeOfString("\(redirect_uri)?code=") != nil {   // get code for access token
            let index = currentURL.characters.indexOf("=")!
            code = currentURL.substringFromIndex(index)
            code.removeAtIndex(code.startIndex)     // remove '=' from code
            getAccessToken()
            printOkAlert("Use the search icon in the top right to search for hashtags!")
        }
        
    }
    
    // MARK: - Network
    
    func getAccessToken(){
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.instagram.com/oauth/access_token")!)
        request.HTTPMethod = "POST"
        
        let postString:NSString = "client_id=\(client_id)&client_secret=\(client_secret)&grant_type=authorization_code&redirect_uri=\(redirect_uri)&code=\(code)"
        
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil {
                print("error=\(error)")
                return
            }
            
            let responseDict: NSDictionary = try!NSJSONSerialization.JSONObjectWithData(data!, options: []) as! NSDictionary
            self.access_token = responseDict["access_token"] as! String
            self.authenticated = true    // let user search for hashtags
        }
        task.resume()
    }
    
    // MARK: - Alerts
    
    func printOkAlert(alertMessage: String) {
        let alertController = UIAlertController(title: "OK", message: alertMessage, preferredStyle: .Alert)
        let ok = UIAlertAction(title: "OK", style: .Default) { (_) -> Void in
        }
        alertController.addAction(ok)
        presentViewController(alertController, animated: true, completion: nil)
    }

    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "search") {
            let destVC = segue.destinationViewController as! SearchTableViewController
            destVC.accessToken = access_token
        }
    }


}
