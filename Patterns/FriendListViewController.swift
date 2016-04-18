//
//  FriendListViewController.swift
//  Patterns
//
//  Created by Mathias Iden on 14.04.2016.
//  Copyright © 2016 TDT4240G12. All rights reserved.
//

import UIKit

class FriendListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate, FriendCellDelegate {
    
    // MARK: Properties

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var friendsCountLabel: UILabel!

    let friendCellIdentifier = "FriendCell"
    var dataSource = [(username: String, has_pending_invitation: String)]()
    var inputFieldInAlertView: UITextField = UITextField()
    var refreshControl: UIRefreshControl?
    let emptyMessage = EmptyTableViewLabel(text: "You do not have any friends yet")
    
    // MARK: View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 76;
        self.navigationController!.interactivePopGestureRecognizer!.delegate = self;
        
        tableView.backgroundView = emptyMessage
        tableView.separatorStyle = .None
        
        refreshControl = UIRefreshControl()
        refreshControl!.addTarget(self, action: #selector(reloadData), forControlEvents: .ValueChanged)
        tableView.addSubview(refreshControl!)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        reloadData()
    }

    // MARK: Navigation
    
    @IBAction func backButtonTapped(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
        
    }

    func inviteTapped(username: String) {
        Invitations.send(username) { message, error in
            if error == nil {
                self.reloadData()
            } else {
                NSLog("error: %@", error!)
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
            let username = self.inputFieldInAlertView.text!
            
            Friends.add(username) { added, error in
                if added {
                    self.reloadData()
                } else {
                    self.displayAlertViewError(error!)
                }
            }
        }))
        self.presentViewController(alertController, animated: true) {
            // Do something when alert view is shown.
        }
    }

    // MARK: UIAlertController

    func displayAlertViewError(error: String){
        let alertController = UIAlertController(title: "Oooops!", message: error, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Okey", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }

    // MARK: UITableViewDataSource
    
    func dataDidChange(){
        let count = dataSource.count
        friendsCountLabel.text = String(count)
        self.tableView.reloadData();

        if (count == 0) {
            emptyMessage.hidden = false
            tableView.separatorStyle = .None
        } else {
            emptyMessage.hidden = true
            tableView.separatorStyle = .SingleLine
        }
    }

    func reloadData(){
        Friends.friendsList() { friends, error in
            if error == nil {
                self.dataSource = friends!
                self.dataDidChange()
            } else {
                NSLog("error: %@", error!)
            }
            self.refreshControl?.endRefreshing()
        }
    }

    // MARK: UITableViewDelegate

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(friendCellIdentifier) as! FriendCellTableViewCell
        let user = dataSource[indexPath.row]
        cell.configureCell(user, row: indexPath.row)
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
            Friends.delete(username) { deleted, error in
                if deleted {
                    self.dataSource.removeAtIndex(indexPath.row)
                    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
                    self.reloadData()
                } else {
                    NSLog("error: %@", error!)
                }
            }
        }
    }
}
