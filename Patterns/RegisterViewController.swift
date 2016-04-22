//
//  RegisterViewController.swift
//  Patterns
//
//  Created by Kristian Våge on 12.04.2016.
//  Copyright © 2016 TDT4240G12. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController, UITextFieldDelegate {
    private var keyboardHeight: CGFloat?
    private var initialContentHeight: Int?
    
    // MARK: Properties

    @IBOutlet weak var contentHeight: NSLayoutConstraint!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    // MARK: View Controller Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(RegisterViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(RegisterViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(RegisterViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        usernameField.delegate = self;
        emailField.delegate = self;
        passwordField.delegate = self;
        initialContentHeight = Int(contentView.frame.height);
    }
    
    func dismissKeyboard(){
        view.endEditing(false)
        scrollOffset(0)
    }
    
    @IBAction func closeTapped(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func keyboardWillShow(notification: NSNotification){
        let userInfo:NSDictionary = notification.userInfo!
        let keyboardFrame:NSValue = userInfo.valueForKey(UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.CGRectValue()
        keyboardHeight = keyboardRectangle.height
        contentHeight.constant = CGFloat(initialContentHeight!) + keyboardHeight!/2
        
        // If iPhone 5S or lower
        if(view.frame.height < 667){
            scrollOffset(200)
            return;
        }
        // If iPhone 6 or later
        scrollOffset(150)
    }
    
    func keyboardWillHide(notification: NSNotification){
        let userInfo:NSDictionary = notification.userInfo!
        let keyboardFrame:NSValue = userInfo.valueForKey(UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.CGRectValue()
        keyboardHeight = keyboardRectangle.height
        contentHeight.constant = CGFloat(initialContentHeight!) - keyboardHeight!/2 - 20
    }
    

    
    // MARK: Navigation
    @IBAction func registerButtonTapped(sender: UIButton?) {
        let username = usernameField.text!
        let email = emailField.text!
        let password = passwordField.text!
        
        Users.register(username, email: email, password: password, device_token: UserDefaultStorage.getDeviceToken()) { token, message, error in
            if error == nil {
                UserDefaultStorage.saveToken(token ?? "")
                self.getUserData()
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

    private func getUserData() {
        Users.me { (username, email, wins, losses, errorOccured) in
            if !errorOccured {
                UserDefaultStorage.saveUsername(username!)
                UserDefaultStorage.saveEmail(email!)
            }
        }
    }
    
    func scrollOffset(offset: Int){
        scrollView.contentOffset = CGPoint(x: 0, y: offset)
    }

    func displayAlertViewError(error: String) {
        let alertController = UIAlertController(title: "Oooops!", message: error, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Okey", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }

    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == usernameField { // Switch focus to other text field
            emailField.becomeFirstResponder()
        }
        if textField == emailField {
            passwordField.becomeFirstResponder()
        }
        if textField == passwordField {
            self.registerButtonTapped(nil)
        }
        return true
    }

    // MARK: View Controller Configuration

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}