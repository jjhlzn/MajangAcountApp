//
//  UsualPeopleViewController.swift
//  MajangAcountApp
//
//  Created by 刘兆娜 on 16/2/2.
//  Copyright © 2016年 金军航. All rights reserved.
//

import Foundation
import UIKit

protocol AddPlayerDelegate {
    func finishAddPlayer(controller : NewPlayerController, player : Player)
}

class UsualPeopleViewController : UIViewController, UITableViewDelegate, UITableViewDataSource, AddPlayerDelegate {
    
    var players : [Player]!
    var playerStore = PlayerStore()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("UsualPeopleViewController viewDidLoad")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print("UsualPeopleViewController viewWillAppear")
        players = try! playerStore.getAllPlayers()
        print("players.count = \(players.count)")
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("players.count = \(players.count)")
        return players.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        print("cellForRowAtIndexPath")
        let cell = self.tableView.dequeueReusableCellWithIdentifier("playerCell")
        let player = players[indexPath.row]
        cell?.textLabel!.text = player.name
        return cell!
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "newPlayerSegue" {
            let dest : NewPlayerController? = segue.destinationViewController as? NewPlayerController
            dest?.addPlayerDelegate = self
        }
    }
    
    func finishAddPlayer(controller: NewPlayerController, player: Player) {
        players = try! playerStore.getAllPlayers()
        tableView.reloadData()
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let player = players[indexPath.row]
            do {
                try playerStore.removePlayer(player)
                players.removeAtIndex(indexPath.row)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            }
            catch let error {
                print("Core Data Stack save failed: \(error)")
            }
            
        }
    }
    
    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        playerStore.moveItemAtIndex(sourceIndexPath.row, toIndex: destinationIndexPath.row)
    }
    
    @IBAction func editPressed(sender: UIButton) {
        if tableView.editing {
            sender.setTitle("编辑", forState: .Normal)
            tableView.setEditing(false, animated: true)
        } else {
            sender.setTitle("完成", forState: .Normal)
            tableView.setEditing(true, animated: true)
        }
    }
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
}
