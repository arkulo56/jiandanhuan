//
//  addCredits.swift
//  jiandanhuan
//
//  Created by 赵勇 on 15-2-11.
//  Copyright (c) 2015年 赵勇. All rights reserved.
//

import UIKit
import CoreData


class addCredits: UIViewController,
    UITableViewDelegate,
    UITableViewDataSource,
    UIPickerViewDelegate,
    UIPickerViewDataSource{
    //表格句柄
    @IBOutlet weak var tb: UITableView!
    //表格title数组
    var tableTitle:Array<String>!
    var tableDetail:Array<String>!
    //银行名称和编号对象
    var bank:bankInfo!
    //可选日期对象
    var dateSelect:dateInMonth!
    //选择器视图
    @IBOutlet weak var viewIncludePicker: UIView!
    //选择器
    @IBOutlet weak var picker: UIPickerView!
    //当前选中的table的cell编号（方便确定picker该加载什么数据）
    var tbSelectId:Int! = 0
    //picker确定选中的item，用变量记录其编号
    var pickerSelectId:Int! = 0
    //数据库上下文变量
    var content:NSManagedObjectContext!
    //prover与服务器连接对象
    var proder:communicationWithProver!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //table和picker的代理
        tb.delegate = self
        tb.dataSource = self
        picker.delegate = self
        picker.dataSource = self
        //基本数据初始化
        tableTitle = ["银行","账单日","还款日"]
        tableDetail = ["---","---","---"]
        bank = bankInfo()
        dateSelect = dateInMonth()
        //初始化数据库上下文变量
        content = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
        //初始化prover服务器对象
        proder = communicationWithProver()
        
        
        println(applicationDirectoryPath())
        bestRepaymentDay()
    }
    
    //最后数据保存（导航加号）------------------------------------------
    @IBAction func saveData(sender: UIBarButtonItem) {
        //判断数据提交的数据是否完整
        println(tableDetail)
        var sign = 0
        for item in self.tableDetail{
            if item == "---"
            {
                sign = 1
                continue
            }
        }
        if(sign==0)
        {
            var row = NSEntityDescription.insertNewObjectForEntityForName("Credit", inManagedObjectContext: content) as Credit
            for (key,value) in bank.banks{
                if value == self.tableDetail[0]
                {
                    row.bankId = key
                    row.bank = value
                    continue
                }
            }
            row.zhangdanri = self.tableDetail[1].toInt()!
            row.huankuanri = self.tableDetail[2].toInt()!
            content.save(nil)
            //调用最佳还款日函数
            bestRepaymentDay()
            //页面离开之前，将所有数据还原
            self.tableDetail = ["---","---","---"]
            self.tb.reloadData()
            //与自己的proder服务器提交数据
            self.proder.withConnectMyservice(row.zhangdanri,dayType: 1)
            self.tabBarController?.selectedIndex=0
        }
    }
    //计算最佳还款日
    func bestRepaymentDay()
    {
        var f = NSFetchRequest(entityName: "Credit")
        var d:Array<AnyObject>! = content.executeFetchRequest(f, error: nil)
        var maxZhangdanri:Int! = 1
        //最佳还款日，其实就是所有信用卡最后的一个账单日，这个账单日是是最合理的还款日
        for item in d{
            var zhangdanri:Int! = item.valueForKey("zhangdanri") as Int
            if  zhangdanri > maxZhangdanri {
                maxZhangdanri = zhangdanri
            }
        }
        //保存数据库
        var row = NSEntityDescription.insertNewObjectForEntityForName("BestDay", inManagedObjectContext: content) as BestDay
        row.bestDate = maxZhangdanri
        row.addDate = NSDate()
        content.save(nil)
        //与自己的proder服务器提交数据
        self.proder.withConnectMyservice(row.bestDate,dayType: 2)
    }
    
    //table协议函数----------------------------
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableTitle.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        cell.textLabel?.text = tableTitle[indexPath.row]
        cell.detailTextLabel?.text = tableDetail[indexPath.row]
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        openPicker()
        self.tbSelectId = indexPath.row
        self.picker.reloadAllComponents()
    }
    
    //选择器试图动态效果-----------------------------------
    //默认关闭视图
    override func viewDidAppear(animated: Bool) {
        closePicker()
    }
    func closePicker()
    {
        var c = self.viewIncludePicker.frame
        c.origin.y = 580
        UIView.animateWithDuration(0.7,delay:0,usingSpringWithDamping:0.5,initialSpringVelocity:1.0,options:UIViewAnimationOptions.AllowUserInteraction,animations:{
            self.viewIncludePicker.frame = c
            },completion: { (finished: Bool) -> Void in
                
        })
    }
    func openPicker()
    {
        var c = self.viewIncludePicker.frame
        c.origin.y = 580-c.size.height-44
        UIView.animateWithDuration(0.7,delay:0,usingSpringWithDamping:0.8,initialSpringVelocity:1.0,options:UIViewAnimationOptions.AllowUserInteraction,animations:{
            self.viewIncludePicker.frame = c
            },completion: { (finished: Bool) -> Void in
                
        })
        //选择器默认选中第一个item
        self.pickerSelectId = 0
        picker.selectRow(0, inComponent: 0, animated: true)
    }
    //点击完成按钮(picker)
    @IBAction func selectPickerOk(sender: UIButton) {
        //不同的选项不用的数据
        switch tbSelectId {
        case 0:
            self.tableDetail[tbSelectId] = self.bank.banks[pickerSelectId]!
        default:
            var r = String(self.dateSelect.dates[pickerSelectId])
            self.tableDetail[tbSelectId] = r
        }
        closePicker()
        self.tb.reloadData()
    }
    //点击取消按钮(picker)
    @IBAction func selectPickerCancel(sender: UIButton) {
        closePicker()
    }
    
    //picker协议函数----------------------------------
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        //不同的选项有不同的数据
        switch self.tbSelectId{
        case 0:
            return self.bank.banks.count
        default:
            return self.dateSelect.dates.count
        }
    }
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        //不同的选项有不同的数据
        switch self.tbSelectId{
        case 0:
            return self.bank.banks[row]!
        default:
            var r = String(self.dateSelect.dates[row])
            return r+"日/月"
        }
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.pickerSelectId = row
    }
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func applicationDirectoryPath() -> String {
        return NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).last! as String
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
