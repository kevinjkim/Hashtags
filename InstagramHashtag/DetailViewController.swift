//
//  DetailViewController.swift
//  InstagramHashtag
//
//  Created by Kevin Kim on 10/21/15.
//  Copyright © 2015 Kevin Kim. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var followerLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var postsLabel: UILabel!
    
    @IBOutlet weak var postsText: UILabel!
    @IBOutlet weak var followersText: UILabel!
    @IBOutlet weak var followingText: UILabel!
    
    
    var userInfo = UserResults()
    let gradientLayer = CAGradientLayer()
    


    override func viewDidLoad() {
        super.viewDidLoad()
        
        bioLabel.adjustsFontSizeToFitWidth = true
        usernameLabel.adjustsFontSizeToFitWidth = true
        //postsText.adjustsFontSizeToFitWidth = true
        //followersText.adjustsFontSizeToFitWidth = true
        //followingText.adjustsFontSizeToFitWidth = true
        
        updateUI()
        getProfilePic(userInfo.profilePicURL)
        
        setUpGradientLayer()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateUI() {
        captionLabel.text = userInfo.captionText
        followerLabel.text = "\(userInfo.followers)"
        followingLabel.text = "\(userInfo.following)"
        bioLabel.text = userInfo.bio
        postsLabel.text = "\(userInfo.posts)"
        usernameLabel.text = userInfo.username
    }
    
    func getProfilePic(url: String) {
        if let profileURL = NSURL(string: url) {
            if let data = NSData(contentsOfURL: profileURL){
                profileImageView.contentMode = UIViewContentMode.ScaleAspectFit
                profileImageView.image = UIImage(data: data)
            }
        }
    }
    
    func setUpGradientLayer() {
        self.view.backgroundColor = UIColor(netHex: 0x4880a7)
        gradientLayer.frame = self.view.bounds
        
        let color1 = UIColor(netHex: 0x2b6b99)
        let color2 = UIColor(netHex: 0x4880a7)
        
        gradientLayer.colors = [color1, color2]
        gradientLayer.locations = [0.0, 1.0]
        
        self.view.layer.addSublayer(gradientLayer)
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

// MARK: - UIColor Extensions

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        self.init(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: 1.0)
    }
    
    convenience init(netHex: Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}
