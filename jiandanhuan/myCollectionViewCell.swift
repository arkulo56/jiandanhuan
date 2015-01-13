//
//  myCollectionViewCell.swift
//  ceshi7
//
//  Created by 赵勇 on 14-12-28.
//  Copyright (c) 2014年 赵勇. All rights reserved.
//

import UIKit

class myCollectionViewCell: UICollectionViewCell {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    let textLabel: UILabel!
    let textLabel1: UILabel!
    let textLabel2: UILabel!
    //let imageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        /*
        imageView = UIImageView(frame: CGRect(x: 0, y: 16, width: frame.size.width, height: frame.size.height*2/3))
        //imageView = UIImageView()
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        contentView.addSubview(imageView)
        */
        
        //银行
        let textFrame1 = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height/2)
        textLabel1 = UILabel(frame: textFrame1)
        textLabel1.font = UIFont.systemFontOfSize(22)
        textLabel1.textAlignment = .Center
        textLabel1.textColor=UIColor.whiteColor()
        contentView.addSubview(textLabel1)
        //还款日期
        let textFrame = CGRect(x: 0, y: 25, width: frame.size.width, height: frame.size.height/2)
        textLabel = UILabel(frame: textFrame)
        textLabel.font = UIFont.systemFontOfSize(UIFont.smallSystemFontSize())
        textLabel.textAlignment = .Center
        textLabel.textColor=UIColor.whiteColor()
        contentView.addSubview(textLabel)
        
        let textFrame2 = CGRect(x: 0, y: 40, width: frame.size.width, height: frame.size.height/2)
        textLabel2 = UILabel(frame: textFrame2)
        textLabel2.font = UIFont.systemFontOfSize(UIFont.smallSystemFontSize())
        textLabel2.textAlignment = .Center
        textLabel2.textColor=UIColor.greenColor()
        contentView.addSubview(textLabel2)

        
        
    }
    
}
