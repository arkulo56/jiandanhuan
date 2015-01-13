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
    
    //应用集合
    @IBOutlet var cv: UICollectionView!
    //应用集合的上层view
    @IBOutlet var view12: UIView!
    
    //数据变量
    var dataArr:Array<AnyObject>! = []
    var data:NSManagedObject!
    var content:NSManagedObjectContext!
    
    var nowIndexData:Int!
    
    
    

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
        cv!.backgroundColor=UIColor.whiteColor()
        
        //路径
        println(applicationDirectoryPath())
        
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
            self.content.deleteObject(self.dataArr[self.nowIndexData] as NSManagedObject)
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        initData()
        cv!.reloadData()
    }
    func applicationDirectoryPath() -> String {
        return NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).last! as String
    }
}

