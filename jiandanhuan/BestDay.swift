//
//  BestDay.swift
//  jiandanhuan
//
//  Created by 赵勇 on 15-2-12.
//  Copyright (c) 2015年 赵勇. All rights reserved.
//

import Foundation
import CoreData

@objc(BestDay)
class BestDay: NSManagedObject {

    @NSManaged var bestDate: NSNumber
    @NSManaged var addDate: NSDate

}
