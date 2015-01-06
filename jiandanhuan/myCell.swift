//
//  myCell.swift
//  jiandanhuan
//
//  Created by 赵勇 on 14-12-31.
//  Copyright (c) 2014年 赵勇. All rights reserved.
//

import UIKit

class myCell: UICollectionViewCell {
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    let textLabel: UILabel!
    //let textLabel1: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let textFrame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        textLabel = UILabel(frame: textFrame)
        textLabel.font = UIFont.systemFontOfSize(UIFont.smallSystemFontSize())
        textLabel.textAlignment = .Center
        textLabel.textColor=UIColor.greenColor()
        contentView.addSubview(textLabel)
    }
}
