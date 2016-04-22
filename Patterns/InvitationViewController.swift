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
    
    // MARK: Properties

    @IBOutlet weak var invitationCountLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!

    var unsubscribe: (() -> Void)?
    let textCellIdentifier = "InvitationCell"
    var dataSource = [Invitation]();
    var refreshControl: UIRefreshControl?
    let emptyMessage = EmptyTableViewLabel(text: "You do not have any invitations yet")
    let spinner = TableActivityIndicatorView()
    var networkError = false

    // MARK: View Controller Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 76;

        tableView.backgroundView = spinner
        spinner.center = CGPointMake(tableView.frame.size.width / 2, tableView.frame.size.height / 2)
        tableView.separatorStyle = .None

        refreshControl = UIRefreshControl()
        refreshControl!.addTarget(self, action: #selector(reloadData), forControlEvents: .ValueChanged)
        tableView.addSubview(refreshControl!)
        self.unsubscribe = NotificationEvents.sharedInstance.subscribe(function: reloadData)
        print("Notification subscribet")
    }
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if(Int(scrollView.contentOffset.y) < -50 && !(refreshControl?.refreshing)!){
            print("We reload now")
            self.refreshControl?.beginRefreshing()
            reloadData()
        }
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        reloadData()
    }
    override func viewDidDisappear(animated: Bool) {
        self.unsubscribe!();
    }
    
    // MARK: Navigation
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if(navigationController!.viewControllers.count > 1){
            return true
        }
        return false
    }
    
    @IBAction func exitTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: UITableViewDataSource
    
    func dataDidChange() {
        let count = dataSource.count
        
        self.invitationCountLabel.text = String(count)
        self.tableView.reloadData()
        
        if (tableView.backgroundView == spinner) {
            tableView.backgroundView = emptyMessage
        }

        if (count == 0) {
            emptyMessage.hidden = false
            tableView.separatorStyle = .None
            if (networkError) {
                emptyMessage.text = "No internet connection. Reconnect and reload."
            } else {
                emptyMessage.resetText()
            }
        } else {
            emptyMessage.hidden = true
            tableView.separatorStyle = .SingleLine
        }
    }

    func reloadData() {
        Invitations.all { invitations, error in
            if error == nil {
                self.dataSource = invitations!
                self.networkError = false
                self.dataDidChange()
            } else {
                if error == "API http request failed" {
                    self.networkError = true
                    self.dataDidChange()
                } else {
                    self.networkError = false
                    NSLog("error: %@", error!)
                }
            }
            self.refreshControl?.endRefreshing()
            self.spinner.stopAnimating()
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
        let invitation = dataSource[indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier(textCellIdentifier) as! InvitationCellViewController

        cell.configureCell(invitation, delegate: self)

        cell.userInteractionEnabled = true
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
