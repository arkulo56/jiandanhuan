//
//  Credit.swift
//  jiandanhuan
//
//  Created by 赵勇 on 15-1-12.
//  Copyright (c) 2015年 赵勇. All rights reserved.
//

import Foundation
import CoreData


@objc(Credit)
class Credit: NSManagedObject {

    @NSManaged var bank: String
    @NSManaged var bankId: NSNumber
    @NSManaged var huankuanri: NSNumber
    @NSManaged var zhangdanri: NSNumber
    @NSManaged var toRepayment: NSSet

}
