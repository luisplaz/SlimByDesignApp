//
//  resultCell.swift
//  SlimByDesignApp
//
//  Created by Luis Plaz on 11/4/16.
//  Copyright © 2016 Luis Plaz. All rights reserved.
//

import UIKit

class resultCell: UITableViewCell {
/*!
 * @discussion Cell class for table view. This is a custom cell that was made to reflect the information we considered relevant for the user to make a selection. Each cell is required to show the Name, address, rating and photo of the restaurant
 * @param nameLbl UILabel for the restaurant name
 * @param addressLbl UILabel for the restaurant address
 * @param mainImg UIImageView for the restaurant photo
 */
    
    @IBOutlet weak var mainImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var infoCell: UIView!
    @IBOutlet weak var ratingImg: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        infoCell.layer.cornerRadius = 3
        infoCell.layer.masksToBounds = true
    }
    
    var restaurant: SWRestaurant!
    var ratingimg: Double!
    
    func configureCell(restaurant: SWRestaurant) {
        self.restaurant = restaurant
        downloadImage(self.restaurant.photoUrl)
        nameLbl.text = self.restaurant.name.capitalizedString
        addressLbl.text = self.restaurant.address
        
        ratingimg = self.restaurant.rating
        
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
        
    }
    
    func downloadImage(url: NSURL){
        getDataFromUrl(url) {(data,response,error) in
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                guard let data = data where error == nil else {return}
                self.mainImg.image = UIImage(data:data)
            }
        }
        
    }
    
    func getDataFromUrl(url: NSURL, completion: ((data: NSData?, response: NSURLResponse?, error: NSError?) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            completion(data: data, response: response, error: error)
        }.resume()
    }
}

