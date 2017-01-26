//
//  ReviewController2.swift
//  SlimByDesignApp
//
//  Created by Luis Plaz on 11/24/16.
//  Copyright © 2016 Luis Plaz. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import Alamofire

class ReviewController2: UIViewController {
/*!
 * @discussion The ReviewController is used for user rating purposes. Here the user has access to 5 of the 10 questions that will reflect the selected restaurants rating.
 * @param restaurant A SWRestaurant object that takes the form of the selected restaurant in the SearchTableViewController.
 */
    
    var restaurant: SWRestaurant!
    var userRating: Double!
    var numRates: Int!
    
    @IBOutlet weak var segmentedControl6: UISegmentedControl!
    @IBOutlet weak var segmentedControl7: UISegmentedControl!
    @IBOutlet weak var segmentedControl8: UISegmentedControl!
    @IBOutlet weak var segmentedControl9: UISegmentedControl!
    @IBOutlet weak var segmentedControl10: UISegmentedControl!
    
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
    
    @IBAction func makeReview(sender: AnyObject) {
        
        postToFirebase()
        
        if numRates != nil {
            performSegueWithIdentifier("SubmitViewController", sender: [restaurant, userRating, numRates])
        }else{
            numRates = 2
            performSegueWithIdentifier("SubmitViewController", sender: [restaurant, userRating, numRates])
        }
        
        performSegueWithIdentifier("SubmitViewController", sender: [restaurant, userRating, numRates])
    }
    
    func postToFirebase(){
        
        var rest: Dictionary<String, AnyObject> = [
            "name": restaurant.name,
            "city": current_city,
            "rating": userRating,
            "numRates": 1
        ]
        
        DataService.ds.REF_RESTAURANTS.queryOrderedByChild("name").queryEqualToValue(restaurant.name)
            .observeSingleEventOfType(.Value, withBlock: { snapshot in
                
                if ( snapshot.value is NSNull ) {
                    let firebasePost = DataService.ds.REF_RESTAURANTS.childByAutoId()
                    firebasePost.setValue(rest)
                } else {
                    
                    for childSnap in  snapshot.children.allObjects {
                        let snap = childSnap as! FIRDataSnapshot
                        let ref = DataService.ds.REF_RESTAURANTS.childByAppendingPath(snap.key)
                        let value = snap.value as? NSDictionary
                        let dbRating = value?["rating"] as? Double
                        let dbNumRates = value?["numRates"] as? Int
                        self.numRates = dbNumRates
                        let newRestData = ["rating": (dbRating!+self.userRating), "numRates": (dbNumRates!+1)]
                        ref.updateChildValues(newRestData as [NSObject : AnyObject])
                    }
                }
        })
    }
    
    @IBAction func backButton(sender: AnyObject) {
        /*!
         * @discussion This method calls the perfomSegueWithIdentifier method call, this takes the view contoller name and the information we want to send to it.
         */
        performSegueWithIdentifier("ReviewViewController", sender: restaurant)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        /*!
         * @discussion Method that transfers information (In this case the SWRestaurant object) so it can be used and accessed by another view controller.
         * @param segue.identifier String that represents the View name we want to transfer the data to.
         * @param detailsVC View Controller that will be accessed to modify variable contents. In this case we access the view controller and set its restaurants variable to the SWRestaurant we are using in this view controller.
         */
        
        if segue.identifier == "ReviewViewController" {
            
            if let detailsVC = segue.destinationViewController as? ReviewController {
                
                if let restaurant = sender as? SWRestaurant {
                    
                    detailsVC.restaurant = restaurant
                    
                }
            }
        } else if segue.identifier == "SubmitViewController" {
            
            if let detailsVC = segue.destinationViewController as? SubmitController {
                
                if let restaurant = sender![0] as? SWRestaurant {
                    
                    detailsVC.restaurant = restaurant
                    
                }
                
                if let userRating = sender![1] as? Double {
                    
                    detailsVC.userRating = userRating
                    
                }
                
                if let numRates = sender![2] as? Int {
                    
                    detailsVC.numRates = numRates
                    
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
