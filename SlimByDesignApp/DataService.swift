//
//  DataService.swift
//  SlimByDesignApp
//
//  Created by Luis Plaz on 11/30/16.
//  Copyright © 2016 Luis Plaz. All rights reserved.
//

import Foundation
import Firebase

let URL_BASE = FIRDatabase.database().reference()

class DataService {
    static let ds = DataService()
    
    private var _REF_BASE = URL_BASE
    private var _REF_RESTAURANTS = URL_BASE.child("restaurants")
    private var _REF_COMMENTS = URL_BASE.child("comments")
    
    var REF_BASE: FIRDatabaseReference {
        
        return _REF_BASE
        
    }
    
    var REF_RESTAURANTS: FIRDatabaseReference {
        
        return _REF_RESTAURANTS
        
    }
    
    var REF_COMMENTS: FIRDatabaseReference {
        
        return _REF_COMMENTS
        
    }
    
    
}
