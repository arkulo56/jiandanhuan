//
//  Monthly_repayment_amount.swift
//  jiandanhuan
//
//  Created by 赵勇 on 15-2-12.
//  Copyright (c) 2015年 赵勇. All rights reserved.
//

import Foundation
import CoreData

class Monthly_repayment_amount: NSManagedObject {

    @NSManaged var month: NSNumber
    @NSManaged var totalAmount: NSNumber
    @NSManaged var year: NSDate

}
