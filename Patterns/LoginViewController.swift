//
//  LoginViewController.swift
//  Patterns
//
//  Created by Mathias Iden on 12.04.2016.
//  Copyright © 2016 TDT4240G12. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var messageHeader: UILabel!
    @IBOutlet weak var messageField: UILabel!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!

    @IBAction func loginButtonTapped(sender: UIButton) {
        self.login()
    }
    
    @IBAction func registerNewAccountTapped(sender: AnyObject) {
        performSegueWithIdentifier("goToRegister", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageField.hidden = true;
        messageHeader.hidden = true;
        usernameField?.delegate = self;
        passwordField?.delegate = self;
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == usernameField { // Switch focus to other text field
            passwordField.becomeFirstResponder()
        }
        if textField == passwordField {
            self.login()
        }
        return true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
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
    
    func login() {
        let username = usernameField.text!
        let password = passwordField.text!
        Users.login(username, password: password) { token, message, error in
            if error == nil {
                UserDefaultStorage.saveToken(token ?? "")
                self.messageField.hidden = true
                self.messageHeader.hidden = true
                self.view.endEditing(true)
                self.getUserData()
                self.dismissViewControllerAnimated(true, completion: {})
            } else {
                self.messageField.text = error
                self.messageField.hidden = false
                self.messageHeader.hidden = false
                self.view.endEditing(true)
            }
        }
    }

    func getUserData() {
        Users.me { username, email, errorOccured in
            if !errorOccured {
                UserDefaultStorage.saveUsername(username!)
                UserDefaultStorage.saveEmail(email!)
            }
        }
    }
}
