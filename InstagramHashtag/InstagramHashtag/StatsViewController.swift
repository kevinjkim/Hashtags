//
//  StatsViewController.swift
//  InstagramHashtag
//
//  Created by Kevin Kim on 10/25/15.
//  Copyright © 2015 Kevin Kim. All rights reserved.
//

import UIKit
import JBChart

class StatsViewController: UIViewController, JBLineChartViewDelegate, JBLineChartViewDataSource {
    
    @IBOutlet weak var positiveLabel: UILabel!
    @IBOutlet weak var neutralLabel: UILabel!
    @IBOutlet weak var negativeLabel: UILabel!
    @IBOutlet weak var lineChartView: JBLineChartView!
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var footerView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var likeLabel: UILabel!
    
    var sentiment = Sentiment()
    
    var numLikes: [Int] = []
    var timeStamps: [String] = []
    var times: [String] = []
    var titleString: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpLabels()
        setUpLineChart()
        getDates()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpLabels() {
        positiveLabel.adjustsFontSizeToFitWidth = true
        neutralLabel.adjustsFontSizeToFitWidth = true
        negativeLabel.adjustsFontSizeToFitWidth = true
        titleLabel.adjustsFontSizeToFitWidth = true
        
        positiveLabel.text = "\(sentiment.positive)"
        neutralLabel.text = "\(sentiment.neutral)"
        negativeLabel.text = "\(sentiment.negative)"
        
        titleLabel.text = "How #\(titleString) Is Trending"
    }
    
    // MARK: - Time Functions
    
    func getDates() {
        for time in timeStamps {
            if let validTime = Double(time) {
                let createdDate = NSDate(timeIntervalSince1970: validTime)
                let today = NSDate(timeIntervalSinceNow: 0)
                let timeOffset = today.offsetFrom(createdDate)
                times.append(timeOffset)
            }
        }
        print(times)
        
    }
    
    // MARK: - Line Chart Functions
    
    func setUpLineChart() {
        lineChartView.backgroundColor = UIColor(netHex: 0x125688)
        lineChartView.dataSource = self
        lineChartView.delegate = self
        
        lineChartView.headerView = headerView
        
        lineChartView.reloadData()
    }
    
    func numberOfLinesInLineChartView(lineChartView: JBLineChartView!) -> UInt {
        return 1
    }
    
    func lineChartView(lineChartView: JBLineChartView!, numberOfVerticalValuesAtLineIndex lineIndex: UInt) -> UInt {
        return UInt(numLikes.count)
    }
    
    func lineChartView(lineChartView: JBLineChartView!, verticalValueForHorizontalIndex horizontalIndex: UInt, atLineIndex lineIndex: UInt) -> CGFloat {
        return CGFloat(numLikes[Int(horizontalIndex)])
    }
    
    func lineChartView(lineChartView: JBLineChartView!, colorForLineAtLineIndex lineIndex: UInt) -> UIColor! {
        return UIColor.whiteColor()
    }
    
    func lineChartView(lineChartView: JBLineChartView!, showsDotsForLineAtLineIndex lineIndex: UInt) -> Bool {
        return false
    }
    
    
    func lineChartView(lineChartView: JBLineChartView!, didSelectLineAtIndex lineIndex: UInt, horizontalIndex: UInt) {
        let likes = numLikes[Int(horizontalIndex)]
        let time = times[Int(horizontalIndex)]
        timeLabel.text = time
        likeLabel.text = "Likes: \(likes)"
    }
    
    func didDeselectLineInLineChartView(lineChartView: JBLineChartView!) {
        timeLabel.text = ""
        likeLabel.text = ""
    }
    
    // MARK: - Navigation Buttons

    @IBAction func doneButtonPushed(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
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


extension NSDate {
    func yearsFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Year, fromDate: date, toDate: self, options: []).year
    }
    func monthsFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Month, fromDate: date, toDate: self, options: []).month
    }
    func weeksFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.WeekOfYear, fromDate: date, toDate: self, options: []).weekOfYear
    }
    func daysFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Day, fromDate: date, toDate: self, options: []).day
    }
    func hoursFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Hour, fromDate: date, toDate: self, options: []).hour
    }
    func minutesFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Minute, fromDate: date, toDate: self, options: []).minute
    }
    func secondsFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Second, fromDate: date, toDate: self, options: []).second
    }
    
    func offsetFrom(date:NSDate) -> String {
        if yearsFrom(date)   > 0 { return "\(yearsFrom(date)) years ago"   }
        if monthsFrom(date)  > 0 { return "\(monthsFrom(date)) months ago"  }
        if weeksFrom(date)   > 0 { return "\(weeksFrom(date)) weeks ago"   }
        if daysFrom(date)    > 0 { return "\(daysFrom(date)) days ago"    }
        if hoursFrom(date)   > 0 { return "\(hoursFrom(date)) hours ago"   }
        if minutesFrom(date) > 0 { return "\(minutesFrom(date)) mintues ago" }
        if secondsFrom(date) > 0 { return "\(secondsFrom(date)) seconds ago" }
        return ""
    }
}
