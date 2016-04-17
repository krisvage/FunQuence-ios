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
    var dataSource = [Invitation]();
    var refreshControl: UIRefreshControl?
    let emptyMessage = UILabel()

    @IBOutlet weak var invitationCountLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!


    override func viewDidLoad() {
        super.viewDidLoad()

        emptyMessage.textAlignment = NSTextAlignment.Center
        emptyMessage.text = "You do not have any invitations yet"
        emptyMessage.font = UIFont(name: "Helvetica Neue Thin", size: 16)
        emptyMessage.hidden = true
        tableView.backgroundView = emptyMessage
        tableView.separatorStyle = .None
        
        reloadData()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 76;
        invitationCountLabel.text = String(dataSource.count)
        
        refreshControl = UIRefreshControl()
        refreshControl!.addTarget(self, action: #selector(reloadData), forControlEvents: .ValueChanged)
        tableView.addSubview(refreshControl!)
    }
    
    func dataDidChange() {
        let count = dataSource.count
        
        self.invitationCountLabel.text = String(count)
        self.tableView.reloadData()
        
        if (count == 0) {
            emptyMessage.hidden = false
            tableView.separatorStyle = .None
        } else {
            emptyMessage.hidden = true
            tableView.separatorStyle = .SingleLine
        }
    }
    
    func reloadData() {
        Invitations.all { invitations, error in
            if error == nil {
                self.dataSource.removeAll()
                self.dataSource.appendContentsOf(invitations!)
                self.dataDidChange()
            } else {
                print(error)
            }
            self.refreshControl?.endRefreshing()
        }
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
        let invitation = dataSource[indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier(textCellIdentifier) as! InvitationCellViewController
        let from_username = invitation.fromUsername // ["from_username"] as! String
        let timeStamp = invitation.invitationSent // ["invitation_sent"] as! Double

        let timeObject = NSDate(timeIntervalSince1970: floor(timeStamp/1000))

        let timeAgo = timeAgoSince(timeObject)
        let invitationId = invitation.invitationId
        cell.configureCell(from_username, time_ago: timeAgo, invitationId: invitationId, delegate: self)
        cell.userInteractionEnabled = true
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
