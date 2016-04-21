//
//  TableActivityIndicatorView.swift
//  FunQuence
//
//  Created by Kristian Våge on 21.04.2016.
//  Copyright © 2016 TDT4240G12. All rights reserved.
//

import UIKit

class TableActivityIndicatorView: UIActivityIndicatorView {
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(activityIndicatorStyle style: UIActivityIndicatorViewStyle) {
        super.init(activityIndicatorStyle: style)
    }
    
    convenience init() {
        self.init(activityIndicatorStyle: .Gray)

        self.transform = CGAffineTransformMakeScale(2.0, 2.0)
        self.hidesWhenStopped = true
        self.startAnimating()
    }
}