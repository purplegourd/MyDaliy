//
//  MainVC.swift
//  MyDayliy
//
//  Created by yong on 15/5/24.
//  Copyright (c) 2015年 yong. All rights reserved.
//


import UIKit

class MainVC: UIViewController {
    
    var list = Dictionary<String,AnyObject>()
    

    @IBOutlet weak var todoList: UITableView!
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.list.count
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("todo_list_cell", forIndexPath: indexPath) as! UITableViewCell
        let ls = cell.viewWithTag(100) as! UILabel
        let dt = cell.viewWithTag(101) as! UILabel
        let ds = cell.viewWithTag(102) as! UILabel
        let da = cell.viewWithTag(103) as! UILabel
        let ddl = self.list["kind\(indexPath.row)"] as! Array<String>
        ls.text = ddl[0]
        dt.text = ddl[1]
        ds.text = ddl[2]
        da.text = ddl[3]
        //tableView.backgroundColor = UIColor.greenColor()
        return cell
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var args = Dictionary<String,String>()
        //args["data"] = "work"
        Requests.callSyn("/api/t.php", args: args) { (isok, data) -> () in
            if(isok){
                self.list = data["data"] as! Dictionary<String,AnyObject>
            }
        }
        //list = ["work","test","girl","boy","man","women"]
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}