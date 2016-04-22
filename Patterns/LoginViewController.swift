//
//  LoginViewController.swift
//  Patterns
//
//  Created by Mathias Iden on 12.04.2016.
//  Copyright © 2016 TDT4240G12. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    private var keyboardHeight: CGFloat?
    private var initialContentHeight: Int?

    
    // MARK: Properties
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var messageHeader: UILabel!
    @IBOutlet weak var messageField: UILabel!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var contentHeight: NSLayoutConstraint!
    @IBOutlet weak var contentView: UIView!
    
    // MARK: View Controller Lifecycle

    override func viewDidLoad() {
        initialContentHeight = Int(contentView.frame.height);

        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(RegisterViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(RegisterViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(RegisterViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        messageField.hidden = true;
        messageHeader.hidden = true;
        usernameField?.delegate = self;
        passwordField?.delegate = self;
    }
    
    func keyboardWillShow(notification: NSNotification){
        let userInfo:NSDictionary = notification.userInfo!
        let keyboardFrame:NSValue = userInfo.valueForKey(UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.CGRectValue()
        keyboardHeight = keyboardRectangle.height
        contentHeight.constant = CGFloat(initialContentHeight!) + keyboardHeight!/2
        
        // If iPhone 5S or lower
        if(view.frame.height < 667){
            scrollOffset(100)
            return;
        }
    }
    
    func scrollOffset(offset: Int){
        scrollView.contentOffset = CGPoint(x: 0, y: offset)
    }
    
    func keyboardWillHide(notification: NSNotification){
        let userInfo:NSDictionary = notification.userInfo!
        let keyboardFrame:NSValue = userInfo.valueForKey(UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.CGRectValue()
        keyboardHeight = keyboardRectangle.height
        contentHeight.constant = CGFloat(initialContentHeight!) - keyboardHeight!/2 - 20
    }
    
    func dismissKeyboard(){
        view.endEditing(false)
        scrollOffset(0)
    }

    // MARK: Navigation

    @IBAction func loginButtonTapped(sender: UIButton) {
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
    
    private func getUserData() {
       Users.me { (username, email, wins, losses, errorOccured) in
            if !errorOccured {
                UserDefaultStorage.saveUsername(username!)
                UserDefaultStorage.saveEmail(email!)
            }
        }
    }
    
    @IBAction func registerNewAccountTapped(sender: AnyObject) {
        performSegueWithIdentifier("goToRegister", sender: self)
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == usernameField { // Switch focus to other text field
            passwordField.becomeFirstResponder()
        }
        if textField == passwordField {
            self.loginButtonTapped(loginButton)
        }
        return true
    }

    // MARK: View Controller Configuration
    
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
}
