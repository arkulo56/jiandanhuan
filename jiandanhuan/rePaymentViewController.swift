//
//  rePaymentViewController.swift
//  jiandanhuan
//
//  Created by 赵勇 on 15-1-12.
//  Copyright (c) 2015年 赵勇. All rights reserved.
//

import UIKit
import CoreData

class rePaymentViewController: UIViewController {
    //接收的数据参数
    var data:NSManagedObject!
    var content:NSManagedObjectContext!
    var year:Int!
    var month:Int!
    var day:Int!
    
    @IBOutlet weak var bankTF: UILabel!
    @IBOutlet weak var zhangdanriTF: UILabel!
    @IBOutlet weak var huankuanriTF: UILabel!
    @IBOutlet weak var amountTF: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //println(data.valueForKey("bank"))
        content = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
        bankTF.text = data.valueForKey("bank") as? String
        //取当前年月
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.CalendarUnitYear | .CalendarUnitMonth | .CalendarUnitDay, fromDate: date)
        year = components.year
        month = components.month
        day = components.day
        var preMonth:Int!
        if(month==1)
        {
            preMonth = 12
            
        }else
        {
            preMonth = month+1
        }
        
        var tmpZhangdanri: AnyObject? = data.valueForKey("zhangdanri")
        zhangdanriTF.text = "\(preMonth)月\(tmpZhangdanri!)日"
        var tmpHuankuanri: AnyObject? = data.valueForKey("huankuanri")
        huankuanriTF.text = "\(month)月\(tmpHuankuanri!)日"
    }
    
    
    
    @IBAction func addRepayment(sender: UIBarButtonItem) {
        var row = NSEntityDescription.insertNewObjectForEntityForName("Repayment", inManagedObjectContext: content!) as Repayment
        
        row.addDate = NSDate.date()
        row.year = year
        row.month = month
        row.payAmount = NSDecimalNumber(string: amountTF.text)
        row.toCredit = data
        
        content.save(nil)
        
        if let navController = self.navigationController {
            navController.popViewControllerAnimated(true)
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
