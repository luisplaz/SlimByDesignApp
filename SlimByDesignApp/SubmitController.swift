//
//  SubmitController.swift
//  SlimByDesignApp
//
//  Created by Luis Plaz on 12/2/16.
//  Copyright © 2016 Luis Plaz. All rights reserved.
//

import UIKit

class SubmitController: UIViewController {
    
    var restaurant: SWRestaurant!
    var userRating: Double!
    var numRates: Int!
    
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var ratingLbl: UILabel!
    @IBOutlet weak var avgRatingLbl: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        ratingLbl.layer.cornerRadius = 3
        ratingLbl.layer.masksToBounds = true
        
        print(String(userRating))
        
        ratingLbl.text = String(userRating) + "/5"
        avgRatingLbl.text = String(format: "%.1f",(((restaurant.rating+userRating)/Double(numRates))/95)*100)
        
    }

}
