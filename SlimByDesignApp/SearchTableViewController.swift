//
//  SearchTableViewController.swift
//  SlimByDesignApp
//
//  Created by Luis Plaz on 11/4/16.
//  Copyright © 2014-2017 Slim By Design. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class SearchTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
/*!
* @discussion The SearcTableViewController used for showing and filtering restaurants obtainer through a Google Maps Web Request. It shows restaurants according to a set radius of the location returned by the mobile phone GPS.
* @param restaurantResult An array of type SWRestaurant obtained through an API call.
* @param filteredRestaurants An initially empty array of type SWRestaurant used as a filtering array for when user uses the search bar.
* @param inSearchMode A boolean that defines if the user is searching for a resturant through the search bar.
*/
    
    @IBOutlet weak var searchResultTable: UITableView!
    @IBOutlet weak var locationLbl: locationLabel!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var restaurantResult = [SWRestaurant]()
    var filteredRestaurants = [SWRestaurant]()
    var inSearchMode = false
    
    override func viewDidLoad() {
    /*!
     * @discussion Function called when the view is loaded. Its primary function here is to grab information from the Google Maps Api and create our initial set of SWRestaurant objects.
     * @param urlString A string that defines the url required to create a successfull request to the Google Api Web Server. It requires the latitude and longitud obtained by the mobile phone's GPS.
         Required syntax is the following:"https://maps.googleapis.com/maps/api/place/nearbysearch/output?parameters"
     * @param url An NSURL object that represents the url being used for information retrieval.
     * @param json An JSON object that represents the information returned by Google Map's Web Server in json format.
     * @param dict An Dictionary object that represents the information returned by Google Map's Web Server converted from the Json format to an accessible dictionary format.
     * @param name String that represents the name attribute of a restaurant retrieved from the dictionary dict through the "name" key.
     * @param address String that represents the address attribute of a restaurant retrieved from the dictionary dict through the "name" key.
     * @return no return
     */
        
        super.viewDidLoad()
        
        searchResultTable.delegate = self
        searchResultTable.dataSource = self
        searchBar.delegate = self
        
        self.locationLbl.text = location_string
        
        let urlString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=" + String(latitude) + "," + String(longitude) + "&radius=2000&type=restaurant&keyword=bagel&key=AIzaSyBVRB62LUeGyHVrqR21Zq9JCYfBagsW5DE"
        
//        let urlString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=" + String(latitude) + "," + String(longitude) + "&radius=2000&type=restaurant%7Cbakery%7Ccafe&keyword=&key=AIzaSyAyi6nes_UmhpXIv8j6KQeppGWRRuXih9E"
        
        let session = NSURLSession.sharedSession()
        
//        let urlwithPercentEscapes = urlString.stringByAddingPercentEncodingWithAllowedCharacters( NSCharacterSet.URLQueryAllowedCharacterSet())
        
        let url = NSURL(string: urlString)
        
        session.dataTaskWithURL(url!) { (data: NSData?, response: NSURLResponse?, error: NSError?) in
            
            if let data = data {
                
                do{
                    
                    let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)
                    
                    print(json)
                    
                    if let dict = json as? Dictionary<String, AnyObject> {
                        
                        for local in dict["results"] as! [AnyObject]{
                            
                            if let name = local["name"] as? String, let city = current_city as? String, let address = local["vicinity"] as? String, let reference = local["photos"]!![0]["photo_reference"] as? String{
                                
                                var price: Int! = 0
                                
                                if local["price_level"]! as? Int != nil{
                                
                                    price = local["price_level"]! as! Int
                                }
                                
                                var initialRating = 3.5
                                
                                var url = self.findPhoto(reference)
                                
                                for rest in DBlist {
                                    
                                    if rest.name == name {
                                        
                                        initialRating = rest.getRating()
                                        
                                    }
                                    
                                }
                                var rest =  SWRestaurant(name: name , address: address, city: city, photoUrl: url, rating: initialRating, price: price)
                                
                                self.restaurantResult.append(rest)
                            }
                        }
                    }
                    
                        dispatch_async(dispatch_get_main_queue(), {
                            self.searchResultTable.reloadData()
                        })
                    
                } catch {
                    
                    print("Could not serialize json")
                }
            }
            
            }.resume()
    }
    
    
    func findPhoto(reference: String) -> NSURL {
    /*!
     * @discussion Method dedicated to adding the first reference of photo as an NSURL String to the photoUrl attribute of the SWRestaurant class. This method hits the Google Photos API to obtain the photo url linked to the reference code obtained from the Google Place API.
     * @param urlString String that represents the API call. It returns the url for the first photograph stored in Google's Database.
     * @return NSURL object representing the url address for the SWRestaruant photo.
     */
        
        var urlString = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=" + reference + "&key=AIzaSyAyi6nes_UmhpXIv8j6KQeppGWRRuXih9E"
        
        let url = NSURL(string: urlString)!
        
        return url
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    /*!
     * @discussion Method that add the custom cell resultCell to the table view. It passes a SWRestaurant object to our resultCell, which later breaks down the attributes and show the information to the user.
     * @param restaurants An array of type SWRestaurants. It will either contain the filtered restaurants if the search is done or the original set of restaurants obtained by the API call.
     * @return A resultCell
     */
        
        if let cell = tableView.dequeueReusableCellWithIdentifier("resultCell") as? resultCell {
            
            let restaurants: SWRestaurant!
            
            if inSearchMode {
                
                restaurants = filteredRestaurants[indexPath.row]
                
            } else {
                
                restaurants = restaurantResult[indexPath.row]
                
            }
            
            cell.configureCell(restaurants)
            return cell
            
        } else {
            
            return resultCell()
            
        }
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    /*!
     * @discussion Method that defines number of sections in the Table View. For this case we will always need only one.
     * @return Integer referring to number of sections in table.
     */
        
        return 1
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    /*!
     * @discussion Method that defines the number of cells shown in the table.
     * @return Integer referring to number of cells needed.
     */
        if inSearchMode {
            
            return filteredRestaurants.count
            
        } else {
            
            return restaurantResult.count
        }
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    /*!
     * @discussion Method to feed information to the next screen through segue. We are passing the restaurant object so the detail view can access its attributes. This method also calls the perfomSegueWithIdentifier method call, this takes the view contoller name and the information we want to send to it.
     */
        var restaurant: SWRestaurant!
        
        if inSearchMode {
            
            restaurant = filteredRestaurants[indexPath.row]
            
        } else {
            
            restaurant = restaurantResult[indexPath.row]
            
        }
        
        performSegueWithIdentifier("BusinessDetailViewController", sender: restaurant)
    }
    
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
    /*!
     * @discussion Method that takes care of the search function. It first checks if the user s indeed in search mode and then filteres the SWRestaurant array by the tect input in the search bar.
     */
        
        if searchBar.text == nil || searchBar.text == "" {
            
            inSearchMode = false
            searchResultTable.reloadData()
            
        } else {
            
            inSearchMode = true
            let lower = searchBar.text!.lowercaseString
            filteredRestaurants = restaurantResult.filter({$0.name.lowercaseString.rangeOfString(lower) != nil})
            searchResultTable.reloadData()
            
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    /*!
     * @discussion Method that transfers information (In this case the SWRestaurant object) so it can be used and accessed by another view controller.
     * @param segue.identifier String that represents the View name we want to transfer the data to.
     * @param detailsVC View Controller that will be accessed to modify variable contents. In this case we access the view controller and set its restaurants variable to the SWRestaurant we are using in this view controller.
     */
        
        if segue.identifier == "BusinessDetailViewController" {
            
            if let detailsVC = segue.destinationViewController as? BusinessDetailViewController {
                
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
