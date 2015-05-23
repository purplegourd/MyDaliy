//
//  Requst.swift
//  MyDayliy
//
//  Created by yong on 15/5/23.
//  Copyright (c) 2015年 yong. All rights reserved.
//

import Foundation

/**
    网络请求类
*/
class Rquests {
    struct Config
    {
        static var Host:String = "www.clgna.com"
        static var _queue:NSOperationQueue = NSOperationQueue()
    }
    
    class func setConfig( host:String, port:UInt8 )
    {
        Rquests.Config.Host = host
    }
    
    /**
    异步请求数据
    :param: action  String                      要调用的action
    :param: handler handler                     回调处理函数
    :param: args    Dictionary<String,String>   参数
    */
    class func call( action:String, handler: ( isok:Bool, error:String, data:Dictionary<String,AnyObject>!, errorn:NSError! ) -> Void, args:Dictionary<String,String> )
    {
        let send_str = Encoders.encodeJSON( args )
        if( send_str == "" )
        {
            dispatch_async( dispatch_get_main_queue(), { () -> Void in
                handler( isok: false, error: "收到异常数据", data: nil, errorn: nil )
            })
            return
        }
        
        // 拼接
        let url_str = String().stringByAppendingFormat( "http://%@%@", Rquests.Config.Host, action )
        
        let url = NSURL( string: url_str )!
        
        let req:NSMutableURLRequest = NSMutableURLRequest( URL: url, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 15 )
        req.HTTPMethod = "POST"
        req.setValue( "application/json; charset=utf-8", forHTTPHeaderField: "Content-Type" )
        req.setValue( "", forHTTPHeaderField: "Accept-Encoding" )
        req.HTTPBody = send_str.dataUsingEncoding( NSUTF8StringEncoding , allowLossyConversion: false )
        
        NSURLSession.sharedSession().dataTaskWithRequest( req, completionHandler: { data, res, err -> Void in
            
            dispatch_async( dispatch_get_main_queue(), { () -> Void in
                var datastring: NSString = NSString( data: data!, encoding: NSUTF8StringEncoding )!
                
                if( err != nil )
                {
                    println( "GYC.callback ERROR \(action) \(err)" )
                    return handler( isok: false, error: "发生未知错误", data: nil, errorn: err )
                }
                
                let json_obj: AnyObject! = Encoders.decodeJSON( datastring as String )
                
                if( json_obj == nil ) { return handler( isok: false, error: "收到异常数据", data: nil, errorn: err ) }
                println( "GYC.callback \(action) \(json_obj)" )
                
                if let r = json_obj as? Dictionary<String,AnyObject>
                {
                    let error:String! = r["error"] as? String
                    if( r["isok"] as! Bool == true )
                    {
                        handler( isok: true, error: error, data: r, errorn: err )
                    }
                    else
                    {
                        handler( isok: false, error: error, data: r, errorn: err )
                    }
                }
                else
                {
                    handler( isok: false, error: "收到异常数据", data: nil, errorn: err )
                }
            })
            
        } ).resume()
    }
    
    
    //同步处理请求
    class func callSyn(action:NSString,args:Dictionary<String,String> , handler:(isok:Bool, data:NSDictionary)->())->Bool{
        var error_msg:String = ""
        var cmpArgs = ""
        
        for (key,value) in args{
            cmpArgs += "\(key as NSString)=\(value as NSString)&"
        }
        cmpArgs = dropLast(cmpArgs)
        
        NSLog("comArgs: %@",cmpArgs)
        
        //var post:NSString = cmpArgs
        var post:NSString = Encoders.encodeJSON(args)
        println(post)
        NSLog("PostData: %@",post)
        
        //拼接url
        let url_str = String().stringByAppendingFormat( "http://%@%@", Rquests.Config.Host, action )
        var url:NSURL = NSURL(string: url_str)!
        
        //var postData:NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!
        var postData:NSData =  post.dataUsingEncoding( NSUTF8StringEncoding , allowLossyConversion: true )!
        
        var postLength:NSString = String( postData.length )
        
        var request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.HTTPBody = postData
        //request.setValue(postLength as String, forHTTPHeaderField: "Content-Length")
        request.setValue( "application/json; charset=utf-8", forHTTPHeaderField: "Content-Type" )
        request.setValue( "", forHTTPHeaderField: "Accept-Encoding" )
        
        
        
        var reponseError: NSError?
        var response: NSURLResponse?
        
        var urlData: NSData? = NSURLConnection.sendSynchronousRequest(request, returningResponse:&response, error:&reponseError)
        
        if ( urlData != nil ) {
            let res = response as! NSHTTPURLResponse!;
            
            NSLog("Response code: %ld", res.statusCode);
            
            if (res.statusCode >= 200 && res.statusCode < 300)
            {
                var responseData:NSString  = NSString(data:urlData!, encoding:NSUTF8StringEncoding)!
                
                NSLog("Response ==> %@", responseData);
                
                var error: NSError?
                
                if let jsonData:NSDictionary = NSJSONSerialization.JSONObjectWithData(urlData!, options:NSJSONReadingOptions.MutableContainers , error: &error) as? NSDictionary {
                    NSLog("result : %@", jsonData)
                    
                    let success:NSInteger = jsonData.valueForKey("isok") as! NSInteger
                    
                    NSLog("Success: %ld", success);
                    
                    if(success == 1)
                    {
                        NSLog("SUCCESS")
                        //println("##########")
                        //println(jsonData)
                        //println("##########")
                        handler(isok:true, data: jsonData)
                        return true
                    } else {
                        if jsonData["error"] as? NSString != nil {
                            error_msg = jsonData["error"] as! String
                        } else {
                            error_msg = "Unknown Error"
                        }
                    }
                }
                else{
                    error_msg = "返回数据异常"
                }
                
            } else {
                error_msg = "Connection Failed"
            }
        }  else {
            error_msg = "Connection Failure"
        }
        handler(isok: false, data: ["error":error_msg])
        return false
    }


}