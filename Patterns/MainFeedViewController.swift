//
//  MainFeedViewController.swift
//  Patterns
//
//  Created by Mathias Iden on 12.04.2016.
//  Copyright © 2016 TDT4240G12. All rights reserved.
//

import UIKit

class MainFeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: Properties

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var gamesCountLabel: UILabel!
    @IBOutlet weak var notificationBadge: UIButton!

    let textCellIdentifier = "GameCell"
    var gamesList = [Game]();
    var invitationCount = 0
    var refreshControl: UIRefreshControl?
    let emptyMessage = EmptyTableViewLabel(text: "You do not have any games yet")

    // MARK: View Controller Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 76;

        tableView.backgroundView = emptyMessage
        tableView.separatorStyle = .None
        
        self.notificationBadge.hidden = true

        refreshControl = UIRefreshControl()
        refreshControl!.addTarget(self, action: #selector(reloadData), forControlEvents: .ValueChanged)
        tableView.addSubview(refreshControl!)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        reloadData()
        reloadInvitationCount()
        
        if UserDefaultStorage.getToken().isEmpty {
            performSegueWithIdentifier("launchLogin", sender: self)
        }
    }

    // MARK: Navigation
    
    @IBAction func settingsButtonTapped(sender: AnyObject) {
        performSegueWithIdentifier("goToSettings", sender: self)
    }
    
    @IBAction func invitationsTapped(sender: AnyObject) {
        performSegueWithIdentifier("goToInvitations", sender: self)
    }
    
    @IBAction func newGameTapped(sender: AnyObject) {
        performSegueWithIdentifier("goToFriendsList", sender: self)
    }

    // MARK: NotificationBadge
    
    func invitationCountDidChange() {
        if (invitationCount == 0) {
            self.notificationBadge.hidden = true
        } else {
            self.notificationBadge.setTitle(String(invitationCount), forState: .Normal)
            self.notificationBadge.hidden = false
        }
    }
    
    func reloadInvitationCount() {
        Invitations.allCount { invitationCount, error in
            if error != nil {
                NSLog("error: %@", error!)
            }
            
            if (invitationCount != self.invitationCount) {
                self.invitationCount = invitationCount
                self.invitationCountDidChange()
            }
        }
    }
    
    // MARK: UITableViewDataSource
    
    func dataDidChange() {
        gamesList.sortInPlace { (game1, game2) -> Bool in
            let status = game1.status["status"]!["message"] as! String
            let usernames = [
                game1.players[0]["username"] as! String,
                game1.players[1]["username"] as! String
            ]
            let opponentUsername = usernames[0] == UserDefaultStorage.getUsername() ? usernames[1] : usernames[0]
            if(status ==  "Waiting for both players." || status == "Waiting for \(UserDefaultStorage.getUsername())."){
                return true;
            }
            if(status == "Waiting for \(opponentUsername)."){
                return true;
            }
            return false;
            
        }
        
        let count = self.gamesList.count

        if (count == 0) {
            self.emptyMessage.hidden = false
            self.tableView.separatorStyle = .None
        } else {
            self.emptyMessage.hidden = true
            self.tableView.separatorStyle = .SingleLine
        }

        self.tableView.reloadData()
        self.gamesCountLabel.text = String(count)
    }
    
    func reloadData() {
        Games.all { games, error in
            if error == nil {
                self.gamesList = games!
                self.dataDidChange()
            } else {
                NSLog("error: %@", error!)
            }
            self.refreshControl!.endRefreshing()
        }
        reloadInvitationCount()
    }

    // MARK: UITableViewDelegate

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gamesList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(textCellIdentifier) as! GameCellTableViewCell
        let game = gamesList[indexPath.row]
        cell.configureCell(game)
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let game = gamesList[indexPath.row]
        let status = game.status["status"]!["message"] as! String
        if(status == "Waiting for \(UserDefaultStorage.getUsername())." || status == "Waiting for both players."){
            performSegueWithIdentifier("goToGame", sender: indexPath.row)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "goToGame") {
            let tappedIndex = sender as! Int;
            let currentGame = gamesList[tappedIndex]
            let destinationVC = segue.destinationViewController as! SequencePlaybackViewController
            destinationVC.currentGame = currentGame
        }
    }
}
