//
//  File.swift
//  MajangAcountApp
//
//  Created by 刘兆娜 on 16/1/30.
//  Copyright © 2016年 金军航. All rights reserved.
//

import Foundation
import UIKit

class SettingViewController : UITableViewController {
    
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("settingCell") as! SettingCell
        switch indexPath.row {
        case 0:
            cell.nameLabel.text = "常用人"
        case 1:
            cell.nameLabel.text = "版本号"
        default:
            ""
        }
        return cell
    }
      
}