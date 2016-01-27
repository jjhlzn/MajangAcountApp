//
//  Game.swift
//  MajangAcountApp
//
//  Created by 刘兆娜 on 16/1/25.
//  Copyright © 2016年 金军航. All rights reserved.
//

import Foundation
import CoreData


class Game: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    
    override func awakeFromInsert() {
        super.awakeFromInsert()
        
        gameId = NSUUID().UUIDString
        players = []
        cards = 0
        price = 0
        createTime = NSDate()
    }

    
    func allPlayerDesc() -> String {
        return players.joinWithSeparator("  ")
    }
    
    func addRoundObject(round: NSManagedObject) {
        let currentRounds = mutableSetValueForKey("rounds")
        currentRounds.addObject(round)
    }
    
    func getFinalGrades() -> [Int] {
        var finalGrades = [0, 0, 0, 0]
        for round in rounds {
            finalGrades[0] = finalGrades[0] + round.grades[0]
            finalGrades[1] = finalGrades[1] + round.grades[1]
            finalGrades[2] = finalGrades[2] + round.grades[2]
            finalGrades[3] = finalGrades[3] + round.grades[3]
        }
        return finalGrades
    }
    
    //返回按时间插入排序的局的数组（时间逆序）
    func getRounds() -> [Round] {
        return rounds.sort() { (round1, round2) -> Bool in
            if round1.finishTime.compare(round2.finishTime) == .OrderedAscending {
                return true
            } else {
                return false
            }
        }
    }
    
    /*
    func description() -> String {
        return "[\(players.joinWithSeparator(" "))]"
    }
    */

}
