//
//  BusinessDetailViewController.swift
//  SlimByDesignApp
//
//  Created by Luis Plaz on 11/14/16.
//  Copyright © 2016 Luis Plaz. All rights reserved.
//

import UIKit

class BusinessDetailViewController: UIViewController {
/*!
 * @discussion The BusinessDetailViewController is used for showing all the information stored in the clicked SWRestaurant. This View shows the name, address, rating, photo, and cost of the restaurant that was selected in the previous screen.
 * @param restaurant A SWRestaurant object that takes the form of the selected restaurant in the SearchTableViewController.
 */
    var restaurant: SWRestaurant!
    var ratingimg: Double!

    @IBOutlet weak var locationLbl: locationLabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var mainImg: UIImageView!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var scoreItButton: UIButton!
    @IBOutlet weak var ratingLbl: UILabel!
    @IBOutlet weak var costLbl: UILabel!
    @IBOutlet weak var ratingImg: UIImageView!
    
    override func viewDidLoad() {
    /*!
     * @discussion Function called when the view is loaded. Its primary function here is to access all attributes from the selected SWRestaurant and show them in the view. It also calls on the downloadImage method so we can download the image referenced by the url in the photoUrl attribute.
     * @return no return
     */
        super.viewDidLoad()
        
        scoreItButton.layer.cornerRadius = 3
        scoreItButton.layer.masksToBounds = true
        locationLbl.text = location_string
        nameLbl.text = restaurant.name
        addressLbl.text = restaurant.address
        ratingLbl.text = String(format: "%.1f", (self.restaurant.rating / 95) * 100) + "/5.0"
        if restaurant.price == 0 {
            costLbl.text = "-"
        }else {
            costLbl.text = String(restaurant.price!)
        }
        downloadImage(self.restaurant.photoUrl)
        
        
        ratingimg = (self.restaurant.rating / 95) * 100
        
        switch ratingimg {
        case 0 ... 0.5:
            ratingImg.image = UIImage(named: "Rate0.5")
        case 0.5 ... 1:
            ratingImg.image = UIImage(named: "Rate1")
        case 1 ... 1.5:
            ratingImg.image = UIImage(named: "Rate1.5")
        case 1.5 ... 2:
            ratingImg.image = UIImage(named: "Rate2")
        case 2 ... 2.5:
            ratingImg.image = UIImage(named: "Rate2.5")
        case 2.5 ... 3:
            ratingImg.image = UIImage(named: "Rate3")
        case 3 ... 3.5:
            ratingImg.image = UIImage(named: "Rate3.5")
        case 3.5 ... 4:
            ratingImg.image = UIImage(named: "Rate4")
        case 4 ... 4.5:
            ratingImg.image = UIImage(named: "Rate4.5")
        case 4.5 ... 5.5:
            ratingImg.image = UIImage(named: "Rate5")
        default:
            print("Could not assign image")
        }
        // Do any additional setup after loading the view.
    }

    
    func downloadImage(url: NSURL) {
    /*!
     * @discussion Method that takes an NSURL from the urlPhoto attribute stored in the selected SWRestaurant and downloads the image from the url using the getDataFromUrl method. It later sets the image as the image in the mainImg UIImageView.
     */
        getDataFromUrl(url) {(data,response,error) in
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                guard let data = data where error == nil else {return}
                self.mainImg.image = UIImage(data:data)
            }
        }
    }

    
    func getDataFromUrl(url: NSURL, completion: ((data: NSData?, response: NSURLResponse?, error: NSError?) -> Void)) {
    /*!
     * @discussion Method that takes an NSURL and downloads the image from the url.
     * @return Image obtained from url.
     */
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            completion(data: data, response: response, error: error)
            }.resume()
    }
    
    
    @IBAction func scoreIt(sender: UIButton) {
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
        }
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
