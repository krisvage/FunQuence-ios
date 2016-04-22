//
//  TutorialViewController.swift
//  FunQuence
//
//  Created by Mathias Iden on 22.04.2016.
//  Copyright © 2016 TDT4240G12. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func finishButtonTapped(sender: AnyObject) {
        UserDefaultStorage.setFinishedTutorial(true);
        dismissViewControllerAnimated(true, completion: nil)
    }
}