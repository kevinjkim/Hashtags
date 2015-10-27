//
//  InstagramService.swift
//  InstagramHastag
//
//  Created by Kevin Kim on 10/19/15.
//  Copyright © 2015 Kevin Kim. All rights reserved.
//

import Foundation

class InstagramService {

    var hashResults = HashResults()
    var userResults = UserResults()
    
    var baseURL: NSURL
    var accessToken: String
    
    init(accessToken: String) {
        self.baseURL = NSURL(string: "https://api.instagram.com/v1/")!
        self.accessToken = accessToken
    }
    
    typealias HashtagResults = (HashResults)? -> Void
    typealias UserInfoResults = (UserResults)? -> Void
    
    func getHashtagResults(hashtag: String, count: Int, completion: HashtagResults) {
        self.hashResults = HashResults()
        let url = NSURL(string: "tags/\(hashtag)/media/recent?access_token=\(accessToken)&count=\(count)", relativeToURL: baseURL)
        
        let networkOperation = NetworkOperation(url: url!)
        networkOperation.downloadJSONFromURL { (let jsonDictionary) -> Void in
            if jsonDictionary != nil {
                let data = jsonDictionary!["data"] as! [[String: AnyObject]]
                for post: [String: AnyObject] in data {
                    let imageData = post["images"]!["low_resolution"] as! [String: AnyObject]
                    let captionData = post["caption"]!["text"] as! String
                    let userID = Int(post["user"]!["id"] as! String)!
                    let likes = post["likes"]!["count"] as! Int
                    let time = post["created_time"] as! String
                    
                    self.hashResults.imageURLs.append(imageData["url"] as! String)
                    self.hashResults.descriptionText.append(captionData)
                    self.hashResults.userIDs.append(userID)
                    self.hashResults.numOfLikes.append(likes)
                    self.hashResults.timeStamps.append(time)
                }
                completion((self.hashResults))
                
            } else {
                completion(nil)
            }
        }
    }
    
    func getUserInfo(userID: Int, completion: UserInfoResults) {
        self.userResults = UserResults()
        let url = NSURL(string: "users/\(userID)/?access_token=\(accessToken)", relativeToURL: baseURL)
        
        let networkOperation = NetworkOperation(url: url!)
        networkOperation.downloadJSONFromURL { (let jsonDictionary) -> Void in
            if jsonDictionary != nil {
                let data = jsonDictionary!["data"] as! [String: AnyObject]
                
                self.userResults.username = data["username"] as! String
                self.userResults.profilePicURL = data["profile_picture"] as! String
                self.userResults.bio = data["bio"] as! String
                self.userResults.posts = data["counts"]!["media"] as! Int
                self.userResults.followers = data["counts"]!["followed_by"] as! Int
                self.userResults.following = data["counts"]!["follows"] as! Int
                
                completion(self.userResults)
            } else {
                completion(nil)
            }
        
        }
    }
}

struct HashResults {
    var numOfLikes: [Int] = []
    var descriptionText: [String] = []
    var imageURLs: [String] = []
    var userIDs: [Int] = []
    var timeStamps: [String] = []
}

struct UserResults {
    var username: String = ""
    var bio: String = ""
    var posts: Int = 0
    var following: Int = 0
    var followers: Int = 0
    var profilePicURL: String = ""
    var captionText: String = ""
}