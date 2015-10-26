//
//  TextAnalyzer.swift
//  InstagramHashtag
//
//  Created by Kevin Kim on 10/23/15.
//  Copyright © 2015 Kevin Kim. All rights reserved.
//

import Foundation

class TextAnalyzer {
    
    let dict = Dictionary()
    
    func determineSentimentArray(sentences: [String]) -> Sentiment {
        var returnSentiment = Sentiment();
        
        for sentence in sentences {
            let sentiment: Int = determineSentiment(sentence)
            returnSentiment.updateSentiment(sentiment)
        }
        
        return returnSentiment
    }
    
    func determineSentiment(sentence: String) -> Int { // -1 for negative, 0 for neutral, 1 for positive
        var positive = 0
        var negative = 0
        var negate = 0
        
        let newSentence = sentence.stringByReplacingOccurrencesOfString("#", withString: "").lowercaseString
        let sentenceArr = newSentence.componentsSeparatedByString(" ")
        
        for word in sentenceArr {
            if dict.positive.contains(word) {
                print("positive word is \(word)")
                positive++
            } else if dict.negative.contains(word) {
                print("negative word is \(word)")
                negative++
            } else if dict.negation.contains(word) {
                print("negate word is \(word)")
                negate++
            }
        }
        
        if (negate % 2 != 0) { // sentence negated -- checking for double negatives
            let temp = positive
            positive = negative
            negative = temp
        }
        
        if (positive > negative) {
            return 1
        } else if (negative > positive) {
            return -1
        }
        
        return 0    // sentence neutral
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