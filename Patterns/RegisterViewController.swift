//
//  RegisterViewController.swift
//  Patterns
//
//  Created by Kristian Våge on 12.04.2016.
//  Copyright © 2016 TDT4240G12. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBAction func registerButtonTapped(sender: UIButton) {
        self.register(sender)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    func register(button: UIButton) {
        let username = usernameField.text!
        let email = emailField.text!
        let password = passwordField.text!
        
        print(username)
        print(email)
        print(password)
        
        Users.register(username, email: email, password: password) { token, message, error in
            if error == nil {
                UserDefaultStorage.saveToken(token ?? "")
                
                print(message)
            } else {
                print(error)
            }
        }
    }
}