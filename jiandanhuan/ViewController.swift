//
//  ViewController.swift
//  jiandanhuan
//
//  Created by 赵勇 on 14-12-31.
//  Copyright (c) 2014年 赵勇. All rights reserved.
//

import UIKit
import CoreData


class ViewController:
    UIViewController,
    UICollectionViewDelegateFlowLayout,
    UICollectionViewDataSource,
    UIGestureRecognizerDelegate
    {
    //最顶部的view视图
    @IBOutlet weak var view1: UIView!
    //view1的实时宽高
    var tWidth:CGFloat!
    var tHeight:CGFloat!
    //应用集合
    @IBOutlet var cv: UICollectionView!
    //应用集合的上层view
    @IBOutlet var view12: UIView!
    //最上面的图片
    //@IBOutlet weak var topImage: UIImageView!
    //当月还款总额label
    //@IBOutlet weak var currentMonthMoney: UILabel!
    //系统信息
    @IBOutlet weak var sysMessage: UILabel!
    
    @IBOutlet weak var sysMessage2: UILabel!
    //数据变量
    var dataArr:Array<AnyObject>! = []
    var data:NSManagedObject!
    var content:NSManagedObjectContext!
    //当前数据索引
    var nowIndexData:Int!
    //当月还款总额
    var amountNum:String!
    //发薪水的日子
    var daySaraly:String!
    
    //视图初始化
    override func viewDidLoad() {
        super.viewDidLoad()
        content = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
        //数据初始化
        initData()
        
        //集合布局
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
        layout.itemSize = CGSize(width: 80, height: 80)
        //collectionview属性修改
        cv!.frame = self.view12.bounds
        cv!.collectionViewLayout = layout
        cv!.dataSource=self
        cv!.delegate=self
        cv!.registerClass(myCollectionViewCell.self, forCellWithReuseIdentifier: "newCell")
        //cv!.backgroundColor=UIColor.whiteColor()
        
        //路径
        println(applicationDirectoryPath())
        
    }
    
    //查询发薪水的日子
    func initSaraly()
    {
        var rq = NSFetchRequest(entityName: "Saraly")
        var whe = NSPredicate(format: "sId=%@", "1")
        rq.predicate = whe
        var d:Array<AnyObject>! = content.executeFetchRequest(rq, error: nil)
        if(d?.count>0)
        {
            var tmpDay: AnyObject? = d[0].valueForKey("daySaraly")
            daySaraly = "每月\(tmpDay)号发薪水哦～"
        }else
        {
            daySaraly = "还没有设置发薪水日哦～"
        }
        sysMessage.text = daySaraly
    }
   
    //计算目前当月总计还款总额
    func computeAmount()
    {
        //取当前年月
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.CalendarUnitYear | .CalendarUnitMonth | .CalendarUnitDay, fromDate: date)
        var year = components.year
        var month = components.month
        //println("jinlaile")
        var rq = NSFetchRequest(entityName: "Repayment")
        var whe = NSPredicate(format: "year=%@","\(year)")
        var whe1 = NSPredicate(format: "month=%@", "\(month)")
        var compound = NSCompoundPredicate.andPredicateWithSubpredicates([whe!,whe1!])
        rq.predicate = compound
        var tmpData:Array<AnyObject>! = content.executeFetchRequest(rq, error: nil)
        //println(tmpData.count)
        var payAmout = 0
        for item in tmpData
        {
            //println(item.valueForKey("payAmount"))
            if let value = item.valueForKey("payAmount") as? Int {
                payAmout = payAmout+value
            }
        }
        amountNum = "本月应还款$\(payAmout).00"
        //改变label的内容
        sysMessage2.text = amountNum
        //改变top图片
        /*
        var image1:UIImage? = UIImage(named: "bik")
        var image2:UIImage? = UIImage(named: "motuo")
        var image3:UIImage? = UIImage(named: "qiche")
        switch payAmout
        {
        case 0...3000:
            topImage.image = image1
        case 3000...6000:
            topImage.image = image2
        case 6000...10000:
            topImage.image = image3
        default:
            topImage.image = image3
        }
        */
    }
    //数据总数
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArr.count
    }
    //每个cell的数据显示
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("newCell", forIndexPath: indexPath) as myCollectionViewCell
        //Credit数据处理,查询每张信用卡当月还款额度
        var rq = NSFetchRequest(entityName: "Repayment")
        var key = "toCredit.bankId"
        var pred:NSPredicate!
        //查询条件
        if let value = dataArr[indexPath.row].valueForKey("bankId") as? NSObject {
            pred = NSPredicate(format: "%K == %@", key, value)
        }
        rq.predicate = pred
        //排序
        var sort = NSSortDescriptor(key: "month", ascending: true)
        var sort1 = NSSortDescriptor(key: "year", ascending: true)
        rq.sortDescriptors = [sort,sort1]
        //limit
        rq.fetchLimit = 1
        var tmpArr:Array<AnyObject>! = content.executeFetchRequest(rq, error: nil)
        //给cell的3个label赋值
        var z: AnyObject! = dataArr[indexPath.row].valueForKey("zhangdanri")
        var h: AnyObject! = dataArr[indexPath.row].valueForKey("huankuanri")
        cell.textLabel?.text = "\(z)~\(h)"
        cell.textLabel1?.text=dataArr[indexPath.row].valueForKey("bank") as? String
        if(tmpArr.count>=1)
        {
            var reAmount: AnyObject! = tmpArr[0].valueForKey("payAmount")
            cell.textLabel2?.text = "$\(reAmount)"
        }else
        {
            cell.textLabel2?.text = "当月无数据"
        }
        cell.backgroundColor = UIColor.grayColor()
        cell.tag = indexPath.row
        //每个cell绑定long press事件
        var lp = UILongPressGestureRecognizer(target: self, action: Selector("longPress:"))
        lp.delegate = self
        cell.addGestureRecognizer(lp)
        return cell
    }
    //单击一个cell块后，跳转至添加当月还款额
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //println(indexPath.row)
        var dataTmp:NSManagedObject! = dataArr[indexPath.row] as NSManagedObject
        //println(data.valueForKey("bankId"))
        
        //跳转
        let myStoryBoard = self.storyboard
        let rePayment:rePaymentViewController = myStoryBoard?.instantiateViewControllerWithIdentifier("rePayment") as rePaymentViewController
        rePayment.data = dataTmp
        self.navigationController?.pushViewController(rePayment, animated: true)
        
    }

    
    //数据------------------------------------------------------------
    //初始化数据
    func initData()
    {
        var tmp = NSFetchRequest(entityName: "Credit")
        dataArr = content.executeFetchRequest(tmp,error:nil)
        //计算当月还款总额
        computeAmount()
        //获取薪水日
        initSaraly()
    }

    
    //给cell绑定long press的callback函数
    func longPress(recognizer: UILongPressGestureRecognizer){
        if(recognizer.state == .Began)
        {

        self.nowIndexData = recognizer.view?.tag
        if respondsToSelector("UIAlertController"){
            var refreshAlert = UIAlertController(title: "注意", message: "确定要删除该信用卡吗？", preferredStyle: UIAlertControllerStyle.Alert)
            refreshAlert.addAction(UIAlertAction(title: "是", style: .Default, handler:
                { (action: UIAlertAction!) in
                  
                    self.content.deleteObject(self.dataArr[self.nowIndexData] as NSManagedObject)
                    self.content.save(nil)
                    self.initData()
                    self.cv!.reloadData()
                }
                ))
            refreshAlert.addAction(UIAlertAction(title: "否", style: .Default, handler: nil))
            presentViewController(refreshAlert, animated: true, completion: nil)
        }
        else {
            let at = UIAlertView()
            at.delegate = self
            at.title = "注意"
            at.message = "确定要删除该信用卡吗？"
            at.addButtonWithTitle("是")
            at.addButtonWithTitle("否")
            at.show()
        }
        
        }
    }
    
    func alertView(View: UIAlertView!, clickedButtonAtIndex buttonIndex: Int){
        
        switch buttonIndex{
        case 0:
            //println("alert")
            self.content.deleteObject(self.dataArr[self.nowIndexData] as NSManagedObject)
            self.content.save(nil)
            self.initData()
            self.cv!.reloadData()
            break;
        case 1:
            //NSLog("Dismiss");
            break;
        default:
            //NSLog("Default");
            break;
            //Some code here..
        }
    }
    
    //给view1画图表
    func getLineChart() -> PDLineChart {
        var dataItem: PDLineChartDataItem = PDLineChartDataItem()
        dataItem.xMax = 12.0
        dataItem.xInterval = 1.0
        dataItem.yMax = 50.0
        dataItem.yInterval = 10.0
        dataItem.pointArray = [
            CGPoint(x: 1.0, y: 44.0),
            CGPoint(x: 2.0, y: 25.0),
            CGPoint(x: 3.0, y: 30.0),
            CGPoint(x: 4.0, y:28.0),
            CGPoint(x: 5.0, y: 14.0),
            CGPoint(x: 6.0, y: 6.0),
            CGPoint(x: 7.0, y: 40.0),
            CGPoint(x: 8.0, y: 44.0),
            CGPoint(x: 9.0, y: 25.0),
            CGPoint(x: 10.0, y: 30.0),
            CGPoint(x: 11.0, y:28.0),
            CGPoint(x: 12.0, y: 14.0)
        ]
        dataItem.xAxesDegreeTexts = ["1", "2", "3", "4", "5", "6", "7","8","9","10","11","12"]
        dataItem.yAxesDegreeTexts = ["4k","6k","8k","10k","12k"]
        
        var lineChart: PDLineChart = PDLineChart(frame: CGRectMake(0, 0, self.tWidth,self.tHeight), dataItem: dataItem)
        //var lineChart: PDLineChart = PDLineChart(frame: self.view1.bounds, dataItem: dataItem)
        
        return lineChart
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //当页面即将显示的时候
    override func viewWillAppear(animated: Bool) {
        initData()
        cv!.reloadData()
    }
    //当页面已经完成显示后
    override func viewDidAppear(animated: Bool){
        self.tWidth = self.view1.frame.size.width
        self.tHeight = self.view1.frame.size.height
        
        println(self.tWidth)
        println(self.tHeight)
        var lineChart: PDLineChart = self.getLineChart()
        self.view1.addSubview(lineChart)
        lineChart.strokeChart()
    }
    func applicationDirectoryPath() -> String {
        return NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).last! as String
    }
}

