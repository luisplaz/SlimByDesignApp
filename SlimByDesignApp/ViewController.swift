//
//  ViewController.swift
//  SlimByDesignApp
//
//  Created by Luis Plaz on 11/4/16.
//  Copyright © 2016 Luis Plaz. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase
import FirebaseDatabase

var location_string: String = ""
var current_city: String = ""
var latitude: Double = 0.0
var longitude: Double = 0.0
var DBlist = [DBRestaurant]()

class ViewController: UIViewController, CLLocationManagerDelegate {
/*!
 * @discussion Viewcontroller for intial menu. This menu allows the selection of type of location the user wants to rate. (Home, Grocery, Restaurants, Schools)
 * @param location_String String initialized as an empty string that will later store the current user location and will be used in all locationLables in different views. This variables refers to the name seen on the top right of each screen.
 * @param latitude String initialized as an 0.0 float. It stores the latitude retrieved from mobile phone GPS.
 * @param longitude String initialized as an 0.0 float. It stores the longitude retrieved from mobile phone GPS.
 */
    
    @IBOutlet weak var locationLabel: UILabel!
    
    var manager: CLLocationManager!
    var Checked: Bool!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        Checked = false
        DBlist = []
        manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()

    }
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    /*!
     * @discussion Method that initializes location awareness and retireves the latitude and longitude of the user.
     * @param userLocation CLLlocation object with information about user location. From here we retireve the latitude and longitude by accessing coordinate attributes.
     */
        let userLocation:CLLocation = locations[0]
        latitude = userLocation.coordinate.latitude
        longitude = userLocation.coordinate.longitude
        
        CLGeocoder().reverseGeocodeLocation(userLocation) { (placemarks, error) -> Void in
            
            if (error != nil) {
                print(error)
            } else {
                if let p = placemarks?[0] {
                    location_string = "\(p.locality!) \(p.administrativeArea!)"
                    current_city = p.locality!
                    self.locationLabel.text = location_string
                    
                    if self.Checked == false {
                        self.Checked = true
                        self.recoverDB()
                    }
                }
            }
            

        }
    }
    
    func recoverDB(){
        
        print("Current city is" + current_city)

        DataService.ds.REF_RESTAURANTS.queryOrderedByChild("city").queryEqualToValue(current_city).observeEventType(.Value, withBlock: { snapshot in
         
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                for snap in snapshots {
                    
                    print("snap: \(snap)")

                    if let restDict = snap.value as? Dictionary<String, AnyObject> {
                        
                        let key = snap.key
                        let restaurant = DBRestaurant(restKey: key, dictionary: restDict)
                        DBlist.append(restaurant)
 
                    }
                }
            }
            
        })
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}