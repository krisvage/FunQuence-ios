//
//  LoginViewController.swift
//  Patterns
//
//  Created by Mathias Iden on 12.04.2016.
//  Copyright © 2016 TDT4240G12. All rights reserved.
//

import UIKit
import Foundation

class LoginViewController: UIViewController {
    @IBOutlet weak var messageHeader: UILabel!
    @IBOutlet weak var messageField: UILabel!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBAction func loginButtonTapped(sender: UIButton) {
        self.login(sender)
    }
    
    @IBAction func registerNewAccountTapped(sender: AnyObject) {
        performSegueWithIdentifier("goToRegister", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageField.hidden = true;
        messageHeader.hidden = true;
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    // MARK: Button action
    
    func login(button: UIButton) {
        let username = usernameField.text
        let password = passwordField.text
        
        Users.login(username!, password: password!) { token, message, error in
            if error == nil {
                let defaults = NSUserDefaults.standardUserDefaults()
                defaults.setObject(token, forKey: "userToken")
                print(token)
                self.messageField.hidden = true
                self.messageHeader.hidden = true
                // TODO: Go to main feed view.
            } else {
                self.messageField.text = error
                self.messageField.hidden = false
                self.messageHeader.hidden = false
            }
        }
    }

}
