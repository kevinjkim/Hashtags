//
//  TextAnalyzer.swift
//  InstagramHashtag
//
//  Created by Kevin Kim on 10/23/15.
//  Copyright © 2015 Kevin Kim. All rights reserved.
//

import Foundation

class TextAnalyzer {
    
    var baseURL: NSURL?
    var apiKey: String
    
    init(apiKey: String) {
        self.baseURL = NSURL(string: "https://api.havenondemand.com/1/api/sync/analyzesentiment/")
        self.apiKey = apiKey
    }
    
    func determineSentimentArray(sentences: [String]) -> Sentiment {
        var returnSentiment = Sentiment();
        
        for sentence in sentences {
            determineSentiment(sentence, completion: { (let sentimentValue: Int) -> Void in
                dispatch_async(dispatch_get_main_queue()) {
                    returnSentiment.updateSentiment(sentimentValue)
                }
            })
            
        }
        
        return returnSentiment
    }
    
    func determineSentiment(sentence: String, completion: Int -> Void) { // -1 for negative, 0 for neutral, 1 for positive
        let newSentence = sentence.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        let url = NSURL(string: "v1?text=\(newSentence)&language=eng&apikey=\(apiKey)", relativeToURL: baseURL)!

        let networkOperation = NetworkOperation(url: url)
        networkOperation.downloadJSONFromURL { (let jsonDictionary) -> Void in
            if jsonDictionary != nil {
                let sentiment = jsonDictionary!["aggregate"]!["sentiment"] as! String
                
                if sentiment == "positive" {
                    completion(1)
                }
                else if sentiment == "neutral" {
                    completion(0)
                }
                else {
                    completion(-1)
                }
            }
        }
    }
    
}

struct Sentiment {
    var positive: Int = 0
    var negative: Int = 0
    var neutral: Int = 0
    
    mutating func updateSentiment(sentiment: Int) {
        if sentiment == 0 {
            neutral++
        } else if sentiment < 0 {
            negative++
        } else {
            positive++
        }
    }
}