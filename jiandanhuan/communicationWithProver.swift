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

    //远程服务器增加数据
    func withConnectMyservice(day:NSNumber,dayType:Int)
    {
        var deleGate = UIApplication.sharedApplication().delegate as AppDelegate
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
}
