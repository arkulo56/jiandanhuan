//
//  addCredit.swift
//  jiandanhuan
//
//  Created by 赵勇 on 15-1-1.
//  Copyright (c) 2015年 赵勇. All rights reserved.
//

import UIKit
import CoreData

class addCredit: UIViewController {
    
    @IBOutlet var bankTF: UITextField!
    @IBOutlet var zhangdanriTF: UITextField!
    @IBOutlet var huankuanriTF: UITextField!
    //数据content
    var content:NSManagedObjectContext!
    //薪水
    var saralyGlobal:Int! = 1
    //最佳还款日objectId
    var obId:NSManagedObjectID!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        content = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
        //判断最佳还款日是否已有记录
        var rq = NSFetchRequest(entityName: "Saraly")
        var whe = NSPredicate(format: "sId=%@", "2")
        rq.predicate = whe
        var data:Array<AnyObject>! = content.executeFetchRequest(rq, error: nil)
        //println(data[0].valueForKey("daySaraly"))
        if(data.count>0)
        {
            obId = data[0].objectID
        }else
        {
            initBest()
        }
        
    }
    //初始化最佳还款日数据(借用Saraly表，sId=2)
    func initBest()
    {
        var row = NSEntityDescription.insertNewObjectForEntityForName("Saraly", inManagedObjectContext: content!) as Saraly
        row.sId = 2
        row.daySaraly = 1
        content.save(nil)
        obId = row.objectID
    }
    //薪水日
    func getSaraly()
    {
        var rq = NSFetchRequest(entityName: "Saraly")
        var whe = NSPredicate(format: "sId=%@", "1")
        rq.predicate = whe
        var saraly:Array<AnyObject>! = content.executeFetchRequest(rq, error: nil)
        if(saraly.count>0)
        {
            saralyGlobal = saraly[0].valueForKey("daySaraly") as Int
        }
    }
    
    //最后账单日and最近还款日
    func dayCalculation()
    {
        //获取薪水日
        getSaraly()
        var bestDay:Int = 0
        var zhangDay:Array<Int>! = [] //账单日
        var huanDay:Array<Int>! = [] //还款日
        //最大的还款日
        var rq1 = NSFetchRequest(entityName: "Credit")
        var d1:Array<AnyObject>! = content.executeFetchRequest(rq1, error: nil)
        if(d1.count > 0)
        {
        var key = 0
        for item in d1
        {
            //求账单日和还款日的最大最小值
            var z = item.valueForKey("zhangdanri") as Int
            var h = item.valueForKey("huankuanri") as Int
            zhangDay.append(z)
            //账单日和还款日如果不是同一个月，则给账单日加30天
            if(h > z)
            {
                huanDay.append(h)
            }else
            {
                huanDay.append(h+30)
            }
            key = key + 1
        }
        //最大最小值
        var z = maxElement(zhangDay) //账单日
        var h = minElement(huanDay)  //还款日
        if(saralyGlobal>z && saralyGlobal<h)
        {
            bestDay = saralyGlobal
        }else if (saralyGlobal+30>z && saralyGlobal<h)
        {
            bestDay = saralyGlobal
        }else
        {
            bestDay = z
        }
        //更新最佳还款日
        var dd = content.objectWithID(obId)
        dd.setValue(bestDay, forKeyPath: "daySaraly")
        content.save(nil)
        
        self.tabBarController?.selectedIndex=0
        }
    }
    
    //远程服务器写数据
    func withConnectMyservice(day:NSNumber)
    {
        var deleGate = UIApplication.sharedApplication().delegate as AppDelegate
        
        //给provider服务器提供数据
        
        var url:String = "http://www.lanmayi.cn/ios/addPushDay.php?token="+deleGate.deviceTokenString!
        var request:NSMutableURLRequest = NSMutableURLRequest()
        request.URL = NSURL(string: url)
        request.HTTPMethod = "GET"
        
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

    @IBAction func addSave(sender: UIBarButtonItem) {
        if(!bankTF.text.isEmpty && !zhangdanriTF.text.isEmpty && !huankuanriTF.text.isEmpty)
        {
            var row = NSEntityDescription.insertNewObjectForEntityForName("Credit", inManagedObjectContext: content!) as Credit
            //查询最大的bankId
            var rq = NSFetchRequest(entityName: "Credit")
            var sort = NSSortDescriptor(key: "bankId", ascending: false)
            rq.sortDescriptors = [sort]
            rq.fetchLimit = 1
            var res:Array<AnyObject>! = content.executeFetchRequest(rq, error: nil)
            var bankId = res[0].valueForKey("bankId") as Int//NSNumber
            
            row.bank = bankTF.text
            row.zhangdanri = zhangdanriTF.text.toInt()!
            row.huankuanri = huankuanriTF.text.toInt()!
            row.bankId = bankId+1
            content?.save(nil)
            //服务器推送提醒日程数据
            withConnectMyservice(row.zhangdanri)
            //计算最佳还款日
            dayCalculation()
            
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
