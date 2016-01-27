//
//  GameDetailTVC.swift
//  MajangAcountApp
//
//  Created by 刘兆娜 on 16/1/7.
//  Copyright © 2016年 金军航. All rights reserved.
//

import UIKit
import CoreData

protocol AddRoundDelegate {
    func finishAddRound(controller : NewRoundController, round : Round)
}

class GameDetailTVC: UIViewController, UITableViewDelegate, UITableViewDataSource, AddRoundDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var gameStore: GameStore!
    var game : Game?
    var isGameOverPressed : Bool = false
    let itemLength = 10

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        isGameOverPressed = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        //print(game) //为什么一打印game就报异常
        
        if isGameOverPressed
        {
            return 3 + (game?.rounds.count)!
        } else {
            return 2 + (game?.rounds.count)!
        }

    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("roundCell", forIndexPath: indexPath) as! RoundCell
        
        var rounds = (game?.getRounds())!
        if indexPath.row == 0 {
            let players = (game?.players)!
            cell.firstLabel.text = ""
            cell.secondLabel.text = players[0]
            cell.thirdLabel.text = players[1]
            cell.fourthLabel.text = players[2]
            cell.fifthLabel.text = players[3]
        } else if indexPath.row == rounds.count + 1 {
            let finalGrades : [Int] = (game?.getFinalGrades())!
            cell.firstLabel.text = "总成绩"
            cell.secondLabel.text = String(finalGrades[0])
            cell.thirdLabel.text = String(finalGrades[1])
            cell.fourthLabel.text = String(finalGrades[2])
            cell.fifthLabel.text = String(finalGrades[3])
        } else if indexPath.row == rounds.count + 2 {
            let finalGrades : [Int] = (game?.getFinalGrades())!
            var gradesList : [String] = []
            for grade in finalGrades {
                gradesList.append( ("¥" + String(Int(Double(grade) * (game?.price.doubleValue)!))) )
            }
            cell.firstLabel.text = "金额"
            cell.secondLabel.text = gradesList[0]
            cell.thirdLabel.text = gradesList[1]
            cell.fourthLabel.text = gradesList[2]
            cell.fifthLabel.text = gradesList[3]
        } else {
            let round = rounds[indexPath.row - 1]
            cell.firstLabel.text = "第\(indexPath.row)轮"
            cell.secondLabel.text = String(round.grades[0])
            cell.thirdLabel.text = String(round.grades[1])
            cell.fourthLabel.text = String(round.grades[2])
            cell.fifthLabel.text = String(round.grades[3])
        }

        return cell
    }


    func finishAddRound(controller: NewRoundController, round: Round) {
                
        tableView.reloadData()
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "newRoundSegue" {
            let dest : NewRoundController? = segue.destinationViewController as? NewRoundController
            dest?.game = self.game
            dest?.addRoundDelegate = self
            dest?.gameStore = gameStore
        }
    }
    
    @IBAction func gameOverPressed(sender: UIButton) {
        isGameOverPressed = !isGameOverPressed
        tableView.reloadData()
    }
    

}
