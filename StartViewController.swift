//
//  StartViewController.swift
//  Patterns
//
//  Created by Kristian Våge on 11.04.2016.
//  Copyright © 2016 TDT4240G12. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {
    // MARK: Properties
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var guestButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameField.placeholder = "Username"
        passwordField.placeholder = "Password"

        loginButton.setTitle("LOGIN", forState: .Normal)
        
        loginButton.addTarget(self, action: #selector(StartViewController.loginButtonTapped), forControlEvents: .TouchDown)
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
    
    func loginButtonTapped(button: UIButton) {
        let username = usernameField.text
        let password = passwordField.text
        
        let token = Users.login(username!, password: password!)
        
        print(token)
    }
}
