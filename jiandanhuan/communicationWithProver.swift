//
//  communicationWithProver.swift
//  jiandanhuan
//
//  Created by 赵勇 on 15-2-13.
//  Copyright (c) 2015年 赵勇. All rights reserved.
//

import Foundation
import UIKit

class communicationWithProver{
    
    var deleGate = UIApplication.sharedApplication().delegate as AppDelegate

    //远程服务器增加数据
    func withConnectMyservice(day:NSNumber,dayType:Int)
    {
        if(deleGate.pushLock==1)
        {
            return
        }
        var d = String(Int(day))
        //给provider服务器提供数据
        var url:String = "http://www.lanmayi.cn/ios/addPushDay.php?token="+deleGate.deviceTokenString!+"&day="+d+"&type="+String(dayType)
        println(url)
        var request:NSMutableURLRequest = NSMutableURLRequest()
        request.URL = NSURL(string: url)
        request.HTTPMethod = "GET"
        println(url)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue(), completionHandler:{ (response:NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            var error: AutoreleasingUnsafeMutablePointer<NSError?> = nil
            let jsonResult: NSDictionary! = NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions.MutableContainers, error: error) as? NSDictionary
            
            if (jsonResult != nil) {
                println("connect service faild")
            } else {
                println("connect service ok")
            }
        })
        
    }
    
    //删除服务器端通知信息
    func withConnectDelete(day:NSNumber)
    {
        if(self.deleGate.pushLock==1)
        {
            return
        }
        var d = String(Int(day))
        //给provider服务器提供数据
        var url:String = "http://www.lanmayi.cn/ios/deletePushDay.php?token="+deleGate.deviceTokenString!+"&day="+d+"&type=1"
        var request:NSMutableURLRequest = NSMutableURLRequest()
        request.URL = NSURL(string: url)
        request.HTTPMethod = "GET"
        println(url)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue(), completionHandler:{ (response:NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            var error: AutoreleasingUnsafeMutablePointer<NSError?> = nil
            let jsonResult: NSDictionary! = NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions.MutableContainers, error: error) as? NSDictionary
            
            if (jsonResult != nil) {
                println("delete action connect service faild")
            } else {
                println("delete action connect service ok")
            }
        })
        
    }
}
