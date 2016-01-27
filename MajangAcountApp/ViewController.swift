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

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AddGameDelegate {

    @IBOutlet weak var tableView: UITableView!
    var gameStore: GameStore!
    
    var games : [Game] = []
    
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
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return games.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell(style:UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        
        let game = games[indexPath.row]
        cell.textLabel?.text = game.allPlayerDesc()
        cell.textLabel?.font = UIFont.systemFontOfSize(14)
        print(game.allPlayerDesc())
        return cell
    }
    
    func tableView(tableView : UITableView, didSelectRowAtIndexPath indexPath : NSIndexPath) {
        performSegueWithIdentifier("gameSegue", sender: indexPath.row)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "gameSegue" {
            let destination : GameDetailTVC? = segue.destinationViewController as? GameDetailTVC
            destination?.game = games[(sender as? Int)!]
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

}

