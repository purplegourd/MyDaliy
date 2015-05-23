//
//  ViewController.swift
//  MyDayliy
//
//  Created by yong on 15/5/23.
//  Copyright (c) 2015年 yong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var s:String?

    @IBOutlet weak var textDo: UITextField!
    @IBAction func toGo(sender: AnyObject) {
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "goToSub"{
            var st = segue.destinationViewController as! SubViewController
            st.work = textDo.text
        }
    }
    
    @IBAction func back(segue:UIStoryboardSegue){
        var vc = segue.sourceViewController as! SubViewController
        println(vc.work!)
        println("回来了")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

