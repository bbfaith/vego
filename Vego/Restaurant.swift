//
//  Restaurant.swift
//  Vego
//
//  Created by Robin Lin on 23/05/2016.
//  Copyright © 2016 Yanhong Ben. All rights reserved.
//

import Foundation

class Restaurant {
    
    // Basic info
    var name: String?
    var url: String?
    
    // Location
    var address: String?
    var location: String?
    var latitude: String?
    var longitude: String?
    
    // Detail info
    var cuisines: String?
    var price_range: Int?
    var average_cost_for_two: String?
    var currency: String?
    
    // Image
    var thumbURL: String?
    
    // User rating
    var rating: String?
    var votes: String?
    var rating_color: String?
    
    init() {}
    
    convenience init(aRestaurantJson: NSDictionary) {
        self.init()
        self.setARestaurantDataFromJson(aRestaurantJson)
    }
    
    func setARestaurantDataFromJson(aRestaurantJson: NSDictionary) {
        name = aRestaurantJson["name"] as? String
        url = aRestaurantJson["url"] as? String
        if let location = aRestaurantJson["location"] as? NSDictionary {
            address = location["address"] as? String
            if let locality = location["locality"] as? String, city = location["city"] as? String {
                self.location = locality + ", " + city
            }
            latitude = location["latitude"] as? String
            longitude = location["longitude"] as? String
        }
        cuisines = aRestaurantJson["cuisines"] as? String
        if let range = aRestaurantJson["price_range"] as? Int {
            price_range = range
        }
        average_cost_for_two = aRestaurantJson["average_cost_for_two"] as? String
        currency = aRestaurantJson["currency"] as? String
        thumbURL = aRestaurantJson["thumb"] as? String
        if let userRating = aRestaurantJson["user_rating"] as? NSDictionary {
            rating = userRating["aggregate_rating"] as? String
            votes = userRating["votes"] as? String
        }
    }
}
