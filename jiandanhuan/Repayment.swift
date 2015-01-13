//
//  Repayment.swift
//  jiandanhuan
//
//  Created by 赵勇 on 15-1-12.
//  Copyright (c) 2015年 赵勇. All rights reserved.
//

import Foundation
import CoreData

@objc(Repayment)
class Repayment: NSManagedObject {

    @NSManaged var year: NSNumber
    @NSManaged var month: NSNumber
    @NSManaged var payAmount: NSDecimalNumber
    @NSManaged var addDate: NSDate
    @NSManaged var toCredit: NSManagedObject

}
