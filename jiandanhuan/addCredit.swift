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

    var content:NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        content = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
        
    }

    @IBAction func addSave(sender: UIBarButtonItem) {
        if(!bankTF.text.isEmpty && !zhangdanriTF.text.isEmpty && !huankuanriTF.text.isEmpty)
        {
            var row:AnyObject = NSEntityDescription.insertNewObjectForEntityForName("Credit", inManagedObjectContext: content!)
            var bank = bankTF.text
            var zhangdanri = zhangdanriTF.text.toInt()
            var huankuanri = huankuanriTF.text.toInt()
            
            row.setValue(bank, forKey: "bank")
            row.setValue(zhangdanri, forKey: "zhangdanri")
            row.setValue(huankuanri, forKey: "huankuanri")
            content?.save(nil)
            
            self.tabBarController?.selectedIndex=0
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
