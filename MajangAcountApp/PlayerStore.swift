//
//  UsualPersonStore.swift
//  MajangAcountApp
//
//  Created by 刘兆娜 on 16/2/2.
//  Copyright © 2016年 金军航. All rights reserved.
//

import Foundation
import CoreData

class PlayerStore {
    
    var coreDataStack = CoreDataStack(modelName: "MajangAcountApp")
    
    func getDefaultOrder() -> Int {
        do {
            return try getAllPlayers().count
        }
        catch {
            return 0
        }
    }
    
    func getAllPlayers() throws -> [Player] {
        let fetchRequest = NSFetchRequest(entityName: "Player")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "order", ascending: true)]
        fetchRequest.predicate = nil
        
        let mainQueueContext = self.coreDataStack.mainQueueContext
        var mainQueuePlayers: [Player]?
        var fetchRequestError: ErrorType?
        mainQueueContext.performBlockAndWait() {
            do {
                mainQueuePlayers = try mainQueueContext.executeFetchRequest(fetchRequest) as? [Player]
            }
            catch let error {
                fetchRequestError = error
            }
        }
        
        guard let players = mainQueuePlayers else {
            throw fetchRequestError!
        }
        return players
    }
    
    func removePlayer(player : Player) throws {
        let context = coreDataStack.mainQueueContext
        var deleteError : ErrorType?
        context.performBlockAndWait() {
            do {
                context.deleteObject(player)
                try self.coreDataStack.saveChanges()
            }
            catch let error {
                deleteError = error
            }
        }
        
        if deleteError != nil {
            throw deleteError!
        }
    }
    
    func moveItemAtIndex(fromIndex: Int, toIndex: Int) {
        if fromIndex == toIndex {
            return
        }
        do {
            var players = try getAllPlayers()
            let fromPlayer = players[fromIndex]
            let toPlayer = players[toIndex]
            let order = fromPlayer.order
            fromPlayer.order = toPlayer.order
            toPlayer.order = order
            try toPlayer.managedObjectContext?.save()
            try fromPlayer.managedObjectContext?.save()
        }
        catch {
            
        }
        
    }
    
    
}