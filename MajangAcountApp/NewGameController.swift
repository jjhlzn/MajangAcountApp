//
//  NewGameController.swift
//  MajangAcountApp
//
//  Created by 刘兆娜 on 16/1/7.
//  Copyright © 2016年 金军航. All rights reserved.
//

import UIKit
import CoreData

class NewGameController: UIViewController {
    
    var addGameDelegate : AddGameDelegate?
    var gameStore: GameStore!
    
    @IBOutlet weak var play1Field: UITextField!
    @IBOutlet weak var play2Field: UITextField!
    @IBOutlet weak var play3Field: UITextField!
    @IBOutlet weak var play4Field: UITextField!
    @IBOutlet weak var totalCardsLabel: UITextField!
    @IBOutlet weak var priceField: UITextField!
    
    override func viewWillAppear(animated: Bool) {
        self.totalCardsLabel.text = "50"
        self.priceField.text = "5"
    }
    
    @IBAction func cancelPressed(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func savePressed(sender: UIBarButtonItem) {
        let player1 : String = play1Field.text!
        let player2 : String = play2Field.text!
        let player3 : String = play3Field.text!
        let player4 : String = play4Field.text!
        let cards = Int(totalCardsLabel.text!)!
        let price = NSDecimalNumber(string: priceField.text!)
        

        let context = gameStore.coreDataStack.mainQueueContext
        var newGame: Game!
        context.performBlockAndWait() {
            newGame = NSEntityDescription.insertNewObjectForEntityForName("Game", inManagedObjectContext: context) as! Game
            newGame.players = [player1, player2, player3, player4]
            newGame.price = price
            newGame.cards = cards
        }
        
        do {
            try gameStore.coreDataStack.saveChanges()
        }
        catch let error {
            print("Core Data save failed: \(error)")
        }

        
        if addGameDelegate != nil {
            addGameDelegate?.finishAddGame(self, game: newGame)
        }


    }
}
