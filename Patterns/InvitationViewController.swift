//
//  NotificationsViewController.swift
//  Patterns
//
//  Created by Mathias Iden on 14.04.2016.
//  Copyright © 2016 TDT4240G12. All rights reserved.
//

import UIKit
import Foundation

class InvitationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    let textCellIdentifier = "InvitationCell"
    let dataSource = staticInvitations;

    @IBOutlet weak var invitationCountLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 76;
        invitationCountLabel.text = String(staticInvitations.count)
    }
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if(navigationController!.viewControllers.count > 1){
            return true
        }
        return false
    }
    
    @IBAction func exitTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(textCellIdentifier) as! InvitationCellViewController
        let from_username = dataSource[indexPath.row]["from_username"] as! String
        let timeStamp = dataSource[indexPath.row]["invitation_sent"] as! Double
        let timeObject = NSDate(timeIntervalSince1970: floor(timeStamp/1000))
        let timeAgo = timeAgoSince(timeObject)
        cell.configureCell(from_username, time_ago: timeAgo)
        cell.userInteractionEnabled = false
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
