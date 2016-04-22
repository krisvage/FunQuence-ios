//
//  SettingsViewController.swift
//  Patterns
//
//  Created by Mathias Iden on 17.04.2016.
//  Copyright © 2016 TDT4240G12. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    // MARK: Properties

    @IBOutlet weak var winsLabel: UILabel!
    @IBOutlet weak var lossesLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!

    // MARK: View Controller Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        usernameLabel.text = UserDefaultStorage.getUsername();
        emailLabel.text = UserDefaultStorage.getEmail();
        Users.me { (username, email, wins, losses, errorOccured) in
            if wins != nil {
                self.winsLabel.text = "Wins: " + String(wins!)
            }
            if(losses != nil){
                self.lossesLabel.text = "Losses: " + String(losses!)
            }
        }
    }

    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)

        self.navigationController?.viewControllers.popLast()
    }
    
    // MARK: Navigation

    @IBAction func backButtonTapped(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func logOutButtonTapped(sender: AnyObject) {
        UserDefaultStorage.saveToken("")
        UserDefaultStorage.saveUsername("")
        UserDefaultStorage.saveEmail("")
        self.performSegueWithIdentifier("settingsToLogin", sender: self)
    }
}
