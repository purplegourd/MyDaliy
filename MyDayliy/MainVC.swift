//
//  MainVC.swift
//  MyDayliy
//
//  Created by yong on 15/5/24.
//  Copyright (c) 2015年 yong. All rights reserved.
//


import UIKit

class MainVC: UIViewController {
    
    var list = Array<String>()
    

    @IBOutlet weak var todoList: UITableView!
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return list.count
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("todo_list_cell", forIndexPath: indexPath) as! UITableViewCell
        let ls = cell.viewWithTag(100) as! UILabel
        let dt = cell.viewWithTag(101) as! UILabel
        ls.text = list[indexPath.row]
        return cell
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        list = ["work","test","girl","boy","man","women"]
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}