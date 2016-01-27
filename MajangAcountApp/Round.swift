//
//  Round.swift
//  MajangAcountApp
//
//  Created by 刘兆娜 on 16/1/25.
//  Copyright © 2016年 金军航. All rights reserved.
//

import Foundation
import CoreData


class Round: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    func gradesDesc() -> String {
        return grades.map { String($0) }.joinWithSeparator("      ")
    }
    
    override func awakeFromInsert() {
        finishTime = NSDate()
    }
}
