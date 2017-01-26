//
//  ReviewController.swift
//  SlimByDesignApp
//
//  Created by Luis Plaz on 11/24/16.
//  Copyright © 2016 Luis Plaz. All rights reserved.
//

import UIKit

var userRating: Double!

class ReviewController: UIViewController {
/*!
 * @discussion The ReviewController is used for user rating purposes. Here the user has access to 5 of the 10 questions that will reflect the selected restaurants rating.
 * @param userRating Double that represents the initial rating any retaurant starts with. If the user chooses no for any question the value will go down by 0.5 else if the user selects yes the rating will go back to its initial value before selecting no.
 * @param restaurant A SWRestaurant object that takes the form of the selected restaurant in the SearchTableViewController.
 */
    var restaurant: SWRestaurant!
    var userRating = 5.0

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var segmentedControl2: UISegmentedControl!
    @IBOutlet weak var segmentedControl3: UISegmentedControl!
    @IBOutlet weak var segmentedControl4: UISegmentedControl!
    @IBOutlet weak var segmentedControl5: UISegmentedControl!
    
    @IBOutlet weak var locationButton: UIButton!
    
    
    @IBAction func indexChanged(sender: UISegmentedControl) {
    /*!
     * @discussion Method that takes care of the modification of the rating score depending on the user's answer to each question. The index initially changes only if the no value is clicked. The initial state of the SegmentedControl is with a clicked YES.
     * @param sender UISegmentedControl instance. This accounts for the 5 buttons on the screen.
     */
        if(sender.selectedSegmentIndex == 0){
            
            userRating = userRating + 0.5
            
        }else if(sender.selectedSegmentIndex == 1){
            
            userRating = userRating - 0.5
            
        }
    }
    
    @IBAction func backButton(sender: AnyObject) {
    /*!
     * @discussion This method calls the perfomSegueWithIdentifier method call, this takes the view contoller name and the information we want to send to it.
     */
        performSegueWithIdentifier("BusinessDetailViewController", sender: restaurant)
        
    }
    
    @IBAction func nextReview(sender: UIButton) {
        /*!
         * @discussion This method calls the perfomSegueWithIdentifier method call, this takes the view contoller name and the information we want to send to it.
         */
        performSegueWithIdentifier("ReviewViewController2", sender: [restaurant,userRating])
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    /*!
     * @discussion Method that transfers information (In this case the SWRestaurant object) so it can be used and accessed by another view controller.
     * @param segue.identifier String that represents the View name we want to transfer the data to.
     * @param detailsVC View Controller that will be accessed to modify variable contents. In this case we access the view controller and set its restaurants variable to the SWRestaurant we are using in this view controller.
     */
        
        if segue.identifier == "ReviewViewController2" {
            
            if let detailsVC = segue.destinationViewController as? ReviewController2 {
                
                if let restaurant = sender![0] as? SWRestaurant {
                    
                    detailsVC.restaurant = restaurant
                    
                }
                
                if let userRating = sender![1] as? Double {
                    
                    detailsVC.userRating = userRating
                    
                }
            }
        
        } else if segue.identifier == "BusinessDetailViewController" {
            
            if let detailsVC = segue.destinationViewController as? BusinessDetailViewController {
                
                if let restaurant = sender as? SWRestaurant {
                    
                    detailsVC.restaurant = restaurant
                    
                }
        
            }
        }
    }
    
    
    override func viewDidLoad() {
       
        super.viewDidLoad()
        
        locationButton.setTitle(location_string, forState: .Normal)

        // Do any additional setup after loading the view.
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
