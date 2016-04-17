//
//  SettingsViewController.swift
//  Patterns
//
//  Created by Mathias Iden on 17.04.2016.
//  Copyright © 2016 TDT4240G12. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    @IBAction func backButtonTapped(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        usernameLabel.text = UserDefaultStorage.getUsername();
        emailLabel.text = UserDefaultStorage.getEmail();
    }
    
    override func viewDidDisappear(animated: Bool) {
        self.navigationController?.popViewControllerAnimated(false)
    }
    
    @IBAction func logOutButtonTapped(sender: AnyObject) {
        UserDefaultStorage.saveToken("")
        self.performSegueWithIdentifier("settingsToLogin", sender: self)
    }
}
