//
//  Round+CoreDataProperties.swift
//  MajangAcountApp
//
//  Created by 刘兆娜 on 16/1/25.
//  Copyright © 2016年 金军航. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Round {

    @NSManaged var grades: [Int]
    @NSManaged var finishTime: NSDate

}
