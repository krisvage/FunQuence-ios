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
        print("hei")
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

                self.navigationController?.popToRootViewControllerAnimated(true)
            } else {
                print(error)
            }
        }
    }
}