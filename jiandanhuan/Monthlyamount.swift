//
//  Monthlyamount.swift
//  jiandanhuan
//
//  Created by 赵勇 on 15-2-12.
//  Copyright (c) 2015年 赵勇. All rights reserved.
//

import Foundation
import CoreData

@objc(Monthlyamount)
class Monthlyamount: NSManagedObject {

    @NSManaged var year: NSNumber
    @NSManaged var month: NSNumber
    @NSManaged var amount: NSNumber

}
