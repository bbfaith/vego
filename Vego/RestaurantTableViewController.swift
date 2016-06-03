//
//  RestaurantTableViewController.swift
//  Vego
//
//  Created by Robin Lin on 21/05/2016.
//  Copyright © 2016 Yanhong Ben. All rights reserved.
//

import UIKit
import CoreLocation

class RestaurantTableViewController: UITableViewController, CLLocationManagerDelegate {
    

    @IBOutlet weak var errorImage: UIImageView!
    
    var latitude = "-34.40073"
    
    var longitude = "150.89125"
    
    let lManager = CLLocationManager()
    
    var restaurantData = [Restaurant]()
    
    var thumbImages = [Int: UIImage]()
    
    var indicator = UIActivityIndicatorView()
    
    // The API key
    let apiKey = "b4060070f6f00977bea3bb8e8743cd61"
    
    // The Zomato API base URL
    let apiBaseURL = "https://developers.zomato.com/api/v2.1/search"
    
    let ratingColor =
    [// rating < 1.0
        UIColor(red: 255/255, green: 186/255, blue: 0/255, alpha: 1.0),
        // 1.0 > rating >=2.0
        UIColor(red: 237/255, green: 214/255, blue: 20/255, alpha: 1.0),
        // 2.0 > rating >= 3.0
        UIColor(red: 154/255, green: 205/255, blue: 50/255, alpha: 1.0),
        // 3.0 > rating >= 3.0
        UIColor(red: 91/255, green: 168/255, blue: 41/255, alpha: 1.0),
        // rating > 4.0
        UIColor(red: 48/255, green: 93/255, blue: 2/255, alpha: 1.0)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator()
        
        lManager.delegate = self
        lManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // Check internet connection first
        if Reachability.isConnectedToNetwork() == false {
            self.indicator.stopAnimating()
            self.errorImage.hidden = false
            self.errorImage.image = UIImage(named: "no_connection")
        } else {
            // Preserve selection between presentations
            self.clearsSelectionOnViewWillAppear = false
            // Retrieve data based on location
            let status = CLLocationManager.authorizationStatus()
            if status == .NotDetermined {
                lManager.requestWhenInUseAuthorization()
            } else if status == .AuthorizedAlways || status == .AuthorizedWhenInUse {
                lManager.startUpdatingLocation()
            } else {
                performRequest(latitude,longitude: longitude)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Animate list
    override func viewWillAppear(animated: Bool) {
        animateTable()
    }
    
    func activityIndicator() {
        indicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 40, 40))
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        indicator.color = UIColor.grayColor()
        indicator.center = self.tableView.center
        indicator.hidesWhenStopped = true
        self.view.addSubview(indicator)
        indicator.startAnimating()
    }
    
    func animateTable() {
        tableView.reloadData()
        
        let cells = tableView.visibleCells
        let tableHeight: CGFloat = tableView.bounds.size.height
        
        for i in cells {
            let cell: UITableViewCell = i as UITableViewCell
            cell.transform = CGAffineTransformMakeTranslation(0, tableHeight)
        }
        
        var index = 0
        
        for a in cells {
            let cell: UITableViewCell = a as UITableViewCell
            UIView.animateWithDuration(1.5, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .TransitionNone, animations: {
                cell.transform = CGAffineTransformMakeTranslation(0, 0);
                }, completion: nil)
            
            index += 1
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return restaurantData.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("resCell", forIndexPath: indexPath) as! RestaurantCell
        let index = indexPath.row
        let aRestaurant = restaurantData[index]

        var cost = ""
        if let range = aRestaurant.price_range, currency = aRestaurant.currency {
            cost = String(count: range, repeatedValue: currency.characters.first!)
        }

        cell.location.text = aRestaurant.location
        cell.name.text = aRestaurant.name
        cell.cost.text = cost
        cell.cuisines.text = aRestaurant.cuisines
        if let ratingString = aRestaurant.rating where ratingString != "0" {
            cell.rating.text = ratingString
            let index = Int(Double(ratingString)!)
            cell.rating.backgroundColor = ratingColor[index]
        }
        
        if let thumbnail = self.thumbImages[index] {
            cell.thumbnail.image = thumbnail
        } else {
            let url = NSURL(string: aRestaurant.thumbURL!)
            let session = NSURLSession.sharedSession()
            let request = NSMutableURLRequest(URL: url!)
            request.timeoutInterval = 10
            let task = session.dataTaskWithRequest(request) {
                (let data, let response, let error) in
                
                dispatch_async(dispatch_get_main_queue()) {
                    if let data = data {
                        let thumbnail = UIImage(data: data)
                        cell.thumbnail.image = thumbnail
                        self.thumbImages[index] = thumbnail
                    }
                }
            }
            task.resume()
        }
        return cell
    }
    
    // MARK: - Json data retrive
    func  performRequest(latitude: String, longitude: String) {
        // Create NASA api base URL using NSURLComponents
        let urlComponents = NSURLComponents(string: apiBaseURL)!
        
        // Add params
        let queryItems = [
            NSURLQueryItem(name: "count", value: "100"),
            NSURLQueryItem(name: "lat", value: latitude),
            NSURLQueryItem(name: "lon", value: longitude),
            NSURLQueryItem(name: "radius", value: "15000"),
            NSURLQueryItem(name: "cuisines", value: "vegetarian"),
            NSURLQueryItem(name: "sort", value: "rating"),
            NSURLQueryItem(name: "order", value: "desc")]
        urlComponents.queryItems = queryItems
        
        // Set request for task
        let request = NSMutableURLRequest(URL: urlComponents.URL!)
        request.timeoutInterval = 30
        request.HTTPMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(apiKey, forHTTPHeaderField: "user-key")
        
        // Set task
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) {
            (data, response, error) -> Void in
            guard error == nil else {
                print(error!)
                self.errorImage.hidden = false
                self.errorImage.image = UIImage(named: "no_connection")
                self.indicator.stopAnimating()
                return
            }
            // Get response from server
            let httpResponse = response as! NSHTTPURLResponse
            let statusCode = httpResponse.statusCode
            // If the connection works
            if statusCode == 200 {
                var json: NSDictionary?
                do{
                    // Fetch json data
                    if let data = data {
                        if let fetchedJson = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary {
                            json = fetchedJson
                        }
                    }
                } catch {
                    print("Cannot load json correctly. error: \(error)")
                    return
                }
                
                // Fetch Json objects asyncronously
                var count = 0
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    if let restaurantsJson = json?["restaurants"] as? [NSDictionary] {
                        for aData in restaurantsJson {
                            // Set each restaurant data
                                let aRestaurantJson = aData["restaurant"] as! NSDictionary
                                let aRestaurant = Restaurant(aRestaurantJson: aRestaurantJson)
                                self.restaurantData.append(aRestaurant)
                                count += 1
                        }
                    }
                    self.indicator.stopAnimating()
                    self.tableView.reloadData()
                    self.viewWillAppear(true)
                }
            }
        }
        task.resume()
    }

    func fetchImage(index: Int, urlString: String) {
        let imageURL = NSURL(string: urlString)
        let imageData = NSData(contentsOfURL: imageURL!)
        if let data = imageData {
            thumbImages[index] = UIImage(data: data)
        }
    }
    
    func locationManager(_: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            longitude = String(location.coordinate.longitude)
            latitude = String(location.coordinate.latitude)
        }
        self.lManager.stopUpdatingLocation()
        performRequest(latitude,longitude: longitude)
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedAlways || status == .AuthorizedWhenInUse {
            self.lManager.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destination = segue.destinationViewController as? RestaurantDetailViewController {
            let rowIndex = self.tableView.indexPathForSelectedRow?.row
            destination.restaurant = self.restaurantData[rowIndex!]
            destination.latitude = self.latitude
            destination.longitude = self.longitude
        }
    }
    

}


