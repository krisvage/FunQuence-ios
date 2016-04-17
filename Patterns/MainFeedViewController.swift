//
//  MainFeedViewController.swift
//  Patterns
//
//  Created by Mathias Iden on 12.04.2016.
//  Copyright © 2016 TDT4240G12. All rights reserved.
//

import UIKit

class MainFeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    let textCellIdentifier = "GameCell"
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var gamesCountLabel: UILabel!
    @IBOutlet weak var notificationBadge: UIButton!

    var dataSource = staticGames;
    var refreshControl: UIRefreshControl?

    override func viewDidAppear(animated: Bool) {
        reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 76;
        
        refreshControl = UIRefreshControl()
        refreshControl!.addTarget(self, action: #selector(reloadData), forControlEvents: .ValueChanged)
        tableView.addSubview(refreshControl!)
        
        if UserDefaultStorage.getToken().isEmpty {
            performSegueWithIdentifier("launchLogin", sender: self)
        }
    }
    
    func reloadData() {
        Games.all { games, error in
            if error == nil {
                self.dataSource = games!
                self.tableView.reloadData()
            } else {
                print(error)
            }
            self.refreshControl!.endRefreshing()
            self.gamesCountLabel.text = String(self.dataSource.count)
        }
        
        Invitations.allCount { invitationCount, error in
            if (error != nil) {
                print(error)
            }
        }
    }

    // TODO: Fix settings, currently logout
    @IBAction func settingsButtonTapped(sender: AnyObject) {
        UserDefaultStorage.saveToken("")
        performSegueWithIdentifier("launchLogin", sender: self)
    }

    @IBAction func invitationsTapped(sender: AnyObject) {
        performSegueWithIdentifier("goToInvitations", sender: self)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    @IBAction func newGameTapped(sender: AnyObject) {
        performSegueWithIdentifier("goToFriendsList", sender: self)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(textCellIdentifier) as! GameCellTableViewCell
        let game = dataSource[indexPath.row]
        cell.configureCell(game)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
