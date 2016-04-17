//
//  FriendListViewController.swift
//  Patterns
//
//  Created by Mathias Iden on 14.04.2016.
//  Copyright © 2016 TDT4240G12. All rights reserved.
//

import UIKit

class FriendListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate, FriendCellDelegate {
    let friendCellIdentifier = "FriendCell"
    var dataSource = [(username: String, has_pending_invitation: String)]()
    var inputFieldInAlertView: UITextField = UITextField()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var friendsCountLabel: UILabel!
    
    @IBAction func backButtonTapped(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
        
    }
    
    func dataDidChange(){
        friendsCountLabel.text = String(dataSource.count)
        self.tableView.reloadData();
    }
    
    func inviteTapped(username: String) {
        Invitations.send(username) { message, error in
            if error == nil {
                self.getViewData()
                print(message)
            } else {
                print(error)
            }
        }
    }
    
    func getViewData(){
        Friends.friendsList() { friends, error in
            if error == nil {
                self.dataSource = friends!
                self.dataDidChange()
            } else {
                print(error)
            }
            self.friendsCountLabel.text = String(self.dataSource.count)
        }

    }
    
    override func viewDidAppear(animated: Bool) {
        self.getViewData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 76;
        self.navigationController!.interactivePopGestureRecognizer!.delegate = self;
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(friendCellIdentifier) as! FriendCellTableViewCell
        let username = dataSource[indexPath.row].username
        let has_pending_invitation = dataSource[indexPath.row].has_pending_invitation

        cell.configureCell(username, row: indexPath.row, has_pending_invitation: has_pending_invitation)
        cell.delegate = self;
        cell.userInteractionEnabled = true
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            let username = dataSource[indexPath.row].username
            Friends.delete(username) { deleted in
                if deleted {
                    self.dataSource.removeAtIndex(indexPath.row)
                    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
                    self.getViewData()
                } else {
                    print("user not deleted")
                }
            }
        }
    }

    @IBAction func addFriendTapped(sender: AnyObject) {
        let alertController = UIAlertController(title: "Add Friend", message: "Enter friends username", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addTextFieldWithConfigurationHandler { (UITextField) in
            self.inputFieldInAlertView = UITextField;
            self.inputFieldInAlertView.placeholder = "Username"
        }
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        alertController.addAction(UIAlertAction(title: "Add", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) in
            print("Trykket add")
            let username = self.inputFieldInAlertView.text!
            
            Friends.add(username) { added in
                if added {
                    self.getViewData()
                } else {
                    print("Add friend failed")
                }
            }
        }))
        self.presentViewController(alertController, animated: true) {
            // Do something when alert view is shown.
        }
        
    }
    
}
