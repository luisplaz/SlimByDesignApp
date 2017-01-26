//
//  locationLabel.swift
//  SlimByDesignApp
//
//  Created by Luis Plaz on 11/5/16.
//  Copyright © 2016 Luis Plaz. All rights reserved.
//

import UIKit

class locationLabel: UILabel {
    
    //A consistent location label class for all the labels in the storyboard referrencing to the location of the user.
    
    override func awakeFromNib() {
        
        self.textColor = UIColor(colorLiteralRed: 255/255.0, green: 210/255.0, blue: 79/255.0, alpha: 100/255.0)
        
    }

}
