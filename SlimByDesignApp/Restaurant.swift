//
//  Restaurant.swift
//  SlimByDesignApp
//
//  Created by Luis Plaz on 11/11/16.
//  Copyright © 2016 Luis Plaz. All rights reserved.
//

import Foundation
import Firebase

class SWRestaurant {
    
    private var _name: String!
    private var _address: String!
    private var _city: String!
    private var _photoUrl: NSURL!
    private var _price: Int?
    private var _rating: Double!
    private var _restRef: FIRDatabaseReference!
    
    //separate database for comments
    //comments rest id and date
    // add comments array
    
    var name: String {
        
        return _name
        
    }
    
    var address: String {
        
        return _address
        
    }
    
    var city: String {
        
        return _city
        
    }
    
    var photoUrl: NSURL {
        
        return _photoUrl
        
    }

    var price: Int? {
        
        return _price
        
    }
    
    var rating: Double {
    
        return _rating
        
    }
    
    func setRating(value: Double) {
        
        self._rating = value
        
    }
    
    init(name: String, address: String, city: String, photoUrl: NSURL, rating: Double, price: Int?) {
        
        self._name = name
        self._address = address
        self._city = city
        self._photoUrl = photoUrl
        self._rating = rating
        self._price = price
        
    }
    
}
