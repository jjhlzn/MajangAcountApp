//
//  NewRoundController.swift
//  MajangAcountApp
//
//  Created by 刘兆娜 on 16/1/7.
//  Copyright © 2016年 金军航. All rights reserved.
//

import UIKit
import CoreData

class NewRoundController: UIViewController {
    
    var addRoundDelegate : AddRoundDelegate?

    @IBOutlet weak var player1Label: UILabel!
    @IBOutlet weak var player2Label: UILabel!
    @IBOutlet weak var player3Label: UILabel!
    @IBOutlet weak var player4Label: UILabel!
    @IBOutlet weak var player1Grade: UITextField!
    @IBOutlet weak var player2Grade: UITextField!
    @IBOutlet weak var player3Grade: UITextField!
    @IBOutlet weak var player4Grade: UITextField!
    
    @IBOutlet weak var player1Switch: UISwitch!
    @IBOutlet weak var player2Switch: UISwitch!
    @IBOutlet weak var player3Switch: UISwitch!
    @IBOutlet weak var player4Switch: UISwitch!
    
    
    var game : Game?
    var gameStore: GameStore!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        player1Label.text = game?.players[0]
        player2Label.text = game?.players[1]
        player3Label.text = game?.players[2]
        player4Label.text = game?.players[3]
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func savePressed(sender: UIBarButtonItem) {
        
        let grade1 = Int(player1Grade.text!)
        let grade2 = Int(player2Grade.text!)
        let grade3 = Int(player3Grade.text!)
        let grade4 = Int(player4Grade.text!)
        
        var hasError = false
        var errMsg = ""
        if grade1 == nil || grade2 == nil || grade3 == nil || grade4 == nil {
            print("必须输入数字")
            errMsg = "必须输入数字"
            hasError = true
        }
        else  {
            var sum = 0
            sum += (player1Switch.on ? -grade1! : grade1!)
            sum += (player2Switch.on ? -grade2! : grade2!)
            sum += (player3Switch.on ? -grade3! : grade3!)
            sum += (player4Switch.on ? -grade4! : grade4!)
            if  sum != 0 {
                print("总数相加不为0")
                if sum > 0 {
                    errMsg = "赢的多出\(sum)张"
                } else {
                    errMsg = "输的多出\(sum)张"
                }
                hasError = true
            }
        }
        
        if hasError {
            let alertController = UIAlertController(title: "",
                message: errMsg, preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "好的", style: UIAlertActionStyle.Default,
                handler: {
                    action in
                    print("点击了确定")
            })
            alertController.addAction(okAction)
            self.presentViewController(alertController, animated: true, completion: nil)
            return
        }
        
        let context = gameStore.coreDataStack.mainQueueContext
        var newRound: Round!
        context.performBlockAndWait() {
            newRound = NSEntityDescription.insertNewObjectForEntityForName("Round", inManagedObjectContext: context) as! Round
            newRound.grades = [self.player1Switch.on ? -grade1! : grade1!,
                               self.player2Switch.on ? -grade2! : grade2!,
                               self.player3Switch.on ? -grade3! : grade3!,
                               self.player4Switch.on ? -grade4! : grade4!]
        }
        
        game?.addRoundObject(newRound)
        
        do {
            try gameStore.coreDataStack.saveChanges()
        }
        catch let error {
            print("Core Data save failed: \(error)")
        }

        addRoundDelegate?.finishAddRound(self, round: newRound)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    }

    @IBAction func backPressed(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
