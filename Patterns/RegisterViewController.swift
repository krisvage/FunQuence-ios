//
//  RegisterViewController.swift
//  Patterns
//
//  Created by Kristian Våge on 12.04.2016.
//  Copyright © 2016 TDT4240G12. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!

    @IBAction func registerButtonTapped(sender: UIButton) {
        self.register(sender)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        usernameField.delegate = self;
        emailField.delegate = self;
        passwordField.delegate = self;
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == usernameField { // Switch focus to other text field
            emailField.becomeFirstResponder()
        }
        if textField == emailField {
            passwordField.becomeFirstResponder()
        }
        if textField == passwordField {
            self.register(nil)
        }
        return true

    }
    
    func displayAlertViewError(error: String){
        let alertController = UIAlertController(title: "Oooops!", message: error, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Okey", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func register(button: UIButton?) {
        let username = usernameField.text!
        let email = emailField.text!
        let password = passwordField.text!

        Users.register(username, email: email, password: password) { token, message, error in
            if error == nil {
                UserDefaultStorage.saveToken(token ?? "")
                self.presentingViewController?.presentingViewController?.dismissViewControllerAnimated(true, completion: {})
            } else {
                if error == "Username already exists." {
                    self.usernameField.background = UIImage(named: "error_input")
                } else {
                    self.usernameField.background = UIImage(named: "inputField")
                }
                
                if error == "Email already exists." {
                    self.emailField.background = UIImage(named: "error_input")
                } else {
                    self.emailField.background = UIImage(named: "inputField")
                }
                self.displayAlertViewError(error!)
                
            }
        }
    }
}