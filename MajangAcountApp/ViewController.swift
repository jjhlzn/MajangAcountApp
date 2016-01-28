//
//  ViewController.swift
//  MajangAcountApp
//
//  Created by 刘兆娜 on 16/1/6.
//  Copyright © 2016年 金军航. All rights reserved.
//

import UIKit
import CoreData

protocol AddGameDelegate {
    func finishAddGame(controller : NewGameController, game : Game)
}

class ViewController: UITableViewController, AddGameDelegate {

    var gameStore: GameStore!
    
    var games : [Game]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //加载Games
        games = try! gameStore.fetchAllGames(predicate: nil, sortDescriptors: [NSSortDescriptor(key: "createTime", ascending: false)])
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear")
        //print(self.games)
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return games.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("gameCell") as! GameCell
        
        let game = games[indexPath.row]
        cell.titleLabel.text = game.allPlayerDesc()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        cell.createTimeLabel.text = dateFormatter.stringFromDate(game.createTime)
        return cell
    }
    
    /*
    override func tableView(tableView : UITableView, didSelectRowAtIndexPath indexPath : NSIndexPath) {
        print(indexPath.row.value)
        performSegueWithIdentifier("gameSegue", sender: indexPath.row)
    }*/
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "gameSegue" {
            let destination : GameDetailTVC? = segue.destinationViewController as? GameDetailTVC
            destination?.game = games[tableView.indexPathForSelectedRow!.row]
            destination?.gameStore = gameStore
        } else if segue.identifier == "newGameSegue" {
            let destination : NewGameController? = segue.destinationViewController as? NewGameController
            destination?.addGameDelegate = self
            destination?.gameStore = gameStore
        }
    }
    
    func finishAddGame(controller : NewGameController, game: Game) {
        
        var newGames = [Game]()
        newGames.append(game)
        for item in games {
            newGames.append(item)
        }
        self.games = newGames
        
        tableView.reloadData()
        controller.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func toggleEdit(sender: UIBarButtonItem) {
        if editing {
            sender.title = "编辑"
            setEditing(false, animated: true)
        } else {
            sender.title = "完成"
            setEditing(true, animated: true)
            
        }
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let game = games[indexPath.row]
            do {
                try gameStore.removeGame(game)
                games.removeAtIndex(indexPath.row)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            }
            catch let error {
                print("Core Data Stack save failed: \(error)")
            }
            
        }
    }
}

