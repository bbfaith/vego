//
//  RestaurantDetailViewController.swift
//  Vego
//
//  Created by Robin Lin on 21/05/2016.
//  Copyright © 2016 Yanhong Ben. All rights reserved.
//

import UIKit
import MapKit

class RestaurantDetailViewController: UITableViewController {

    @IBOutlet weak var votesLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addressLabel: UILabel!
  
    var restaurant: Restaurant?
    
    var latitude: String?
    
    var longitude: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        if let r = restaurant {
            // Set basic info
            nameLabel.text = r.name
            locationLabel.text = r.location
            ratingLabel.text = r.rating
            votesLabel.text = r.votes! + " Votes"
            
            // Set MapView
            let initialLocation = CLLocationCoordinate2DMake(Double(r.latitude!)!, Double(r.longitude!)!)
            let span = MKCoordinateSpanMake(0.002, 0.002)
            let region = MKCoordinateRegion(center: initialLocation, span: span)
            mapView.setRegion(region, animated: true)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = initialLocation
            annotation.title = r.name
            annotation.subtitle = r.location
            mapView.addAnnotation(annotation)
            
            // Set other info
            addressLabel.text = r.address
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func getDirections(sender: AnyObject) {
        print("\(latitude),\(longitude)")
        var urlString = "http:/maps.google.com/maps?"
        urlString += "saddr=\(latitude!),\(longitude!)"
        urlString += "&daddr=\(restaurant!.latitude!),\(restaurant!.longitude!)"
        
        if let url = NSURL(string: urlString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!) {
            UIApplication.sharedApplication().openURL(url)
        }
    }

}
