//
//  GameStore.swift
//  MajangAcountApp
//
//  Created by 刘兆娜 on 16/1/25.
//  Copyright © 2016年 金军航. All rights reserved.
//

import Foundation
import CoreData


class GameStore {
    
    var coreDataStack = CoreDataStack(modelName: "MajangAcountApp")
    
    func fetchAllGames(predicate predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil) throws -> [Game] {
        let fetchRequest = NSFetchRequest(entityName: "Game")
        fetchRequest.sortDescriptors = sortDescriptors
        fetchRequest.predicate = predicate
        
        let mainQueueContext = self.coreDataStack.mainQueueContext
        var mainQueueGames: [Game]?
        var fetchRequestError: ErrorType?
        mainQueueContext.performBlockAndWait() {
            do {
                mainQueueGames = try mainQueueContext.executeFetchRequest(fetchRequest) as? [Game]
            }
            catch let error {
                fetchRequestError = error
            }
        }
        
        guard let games = mainQueueGames else {
            throw fetchRequestError!
        }
        
        return games
    }
}