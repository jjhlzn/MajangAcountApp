//
//  Player+CoreDataProperties.swift
//  MajangAcountApp
//
//  Created by 刘兆娜 on 16/2/20.
//  Copyright © 2016年 金军航. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Player {

    @NSManaged var name: String?
    @NSManaged var order: NSNumber?

}
