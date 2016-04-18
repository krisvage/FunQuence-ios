//
//  emptyTableViewLabel.swift
//  Patterns
//
//  Created by Kristian Våge on 18.04.2016.
//  Copyright © 2016 TDT4240G12. All rights reserved.
//

import UIKit

class EmptyTableViewLabel: UILabel {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(text: String) {
        self.init(frame: CGRectZero)
        
        self.text = text
        self.textAlignment = .Center
        self.font = UIFont(name: "Helvetica Neue Thin", size: 16)
        self.hidden = true
    }
}
