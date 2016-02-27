//
//  NewPlayerController.swift
//  MajangAcountApp
//
//  Created by 刘兆娜 on 16/2/22.
//  Copyright © 2016年 金军航. All rights reserved.
//

import UIKit
import CoreData

class NewPlayerController: UIViewController {
    
    var addPlayerDelegate : AddPlayerDelegate?
    var playerStore = PlayerStore()

    @IBOutlet weak var nameField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func savePressed(sender: UIBarButtonItem) {
        
        if nameField.text!.isEmpty {
            let alertController = UIAlertController(title: "",
                message: "姓名不能为空", preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "好的", style: UIAlertActionStyle.Default,
                handler: {
                    action in
                    print("点击了确定")
            })
            alertController.addAction(okAction)
            self.presentViewController(alertController, animated: true, completion: nil)
            return
        }
        
        let context = playerStore.coreDataStack.mainQueueContext
        var newPlayer: Player!
        context.performBlockAndWait() {
            newPlayer = NSEntityDescription.insertNewObjectForEntityForName("Player", inManagedObjectContext: context) as! Player
            newPlayer.name = self.nameField.text
            newPlayer.order = self.playerStore.getDefaultOrder()
        }
        
        do {
            try playerStore.coreDataStack.saveChanges()
        }
        catch let error {
            print("Core Data save failed: \(error)")
        }
        addPlayerDelegate?.finishAddPlayer(self, player: newPlayer)
    }

    @IBAction func backPressed(sender: UIBarButtonItem) {
        print("back pressed")
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
