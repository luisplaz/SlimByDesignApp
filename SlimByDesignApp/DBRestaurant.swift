//
//  DBRestaurant.swift
//  SlimByDesignApp
//
//  Created by Luis Plaz on 12/1/16.
//  Copyright © 2016 Luis Plaz. All rights reserved.
//

import Foundation
import Firebase

class DBRestaurant {
    
    private var _name: String!
    private var _city: String!
    private var _rating: Double!
    private var _numRates: Int!
    private var _restkey: String!
    
    
    var name: String {
        
        return _name
        
    }
    
    var city: String {
        
        return _city
        
    }
    
    var rating: Double {
        
        return _rating
        
    }
    
    var numRates: Int {
        
        return _numRates
    }
    
    func setRating(value: Double) {
        
        self._rating = self._rating + value
        
    }
    
    func getRating() -> Double {
        
        let rating = self._rating
        let numRating = self._numRates
        
        return rating/Double(numRating)
        
    }
    
    func setNumRates() {
    
        self._numRates = self._numRates + 1
    
    }
    
    init(name: String, city: String, rating: Double, price: Int?) {
        
        self._name = name
        self._city = city
        self._rating = rating
        
    }
    
    init(restKey: String, dictionary: Dictionary<String, AnyObject>) {
        
        self._restkey = restKey
        
        if let name = dictionary["name"] as? String {
            
            self._name = name
            
        }
        
        if let city = dictionary["city"] as? String {
            
            self._city = city
            
        }
        
        if let rating = dictionary["rating"] as? Double {
            
            self._rating = rating
            
        }
        
        if let numRates = dictionary["numRates"] as? Int {
            
            self._numRates = numRates
            
        }
        
    }
    
}
