//
//  SubViewController.swift
//  MyDayliy
//
//  Created by yong on 15/5/23.
//  Copyright (c) 2015年 yong. All rights reserved.
//
import UIKit

class SubViewController: UIViewController {
    var work:String?
    
    @IBAction func click(sender: AnyObject) {
        let date = NSDate()
        let formatter = NSDateFormatter()
        formatter.timeStyle = .FullStyle
        formatter.stringFromDate(date)
        var dateString = formatter.stringFromDate(date)
        work = dateString+"点击了"
    }
    @IBOutlet weak var display: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if let now = work {
            display.text = now
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

