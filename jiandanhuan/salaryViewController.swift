//
//  salaryViewController.swift
//  jiandanhuan
//
//  Created by 赵勇 on 15-1-15.
//  Copyright (c) 2015年 赵勇. All rights reserved.
//

import UIKit
import CoreData

class salaryViewController: UIViewController {

    var dateSel = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31]
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var textTF: UITextField!
    //当前选中的row
    var rowSelected:Int!
    //数据objectId
    var obId:NSManagedObjectID!
    //数据处理
    var content:NSManagedObjectContext!
    var data:Array<AnyObject>! = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        content = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
        
        var rq = NSFetchRequest(entityName: "Saraly")
        var whe = NSPredicate(format: "sId=%@", "1")
        rq.predicate = whe
        data = content.executeFetchRequest(rq, error: nil)
        //println(data[0].valueForKey("daySaraly"))
        if(data.count>0)
        {
            var daySet: AnyObject! = data[0].valueForKey("daySaraly")
            obId = data[0].objectID
            textTF.text = "\(daySet)号"
        }else
        {
            initData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initData()
    {
        var row = NSEntityDescription.insertNewObjectForEntityForName("Saraly", inManagedObjectContext: content!) as Saraly
        row.sId = 1
        row.daySaraly = 1
        content.save(nil)
        obId = row.objectID
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    /* func pickerView(pickerView: UIPickerView, numberOfRowsInComponent: component) {
    return colors.count
    }*/
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dateSel.count
    }
    
    // pragma MARK: UIPickerViewDelegate
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return "\(dateSel[row])号"
    }
    
    func pickerView(pickerView: UIPickerView!, didSelectRow row: Int, inComponent component: Int)
    {
        rowSelected = row
        textTF.text = "\(dateSel[row])号"
    }
    

    @IBAction func setSaraly(sender: UIBarButtonItem) {
        
        var dd = content.objectWithID(obId)
        dd.setValue(dateSel[rowSelected], forKeyPath: "daySaraly")
        content.save(nil)
        self.tabBarController?.selectedIndex=0
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
